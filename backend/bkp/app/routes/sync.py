from flask import Blueprint, request, jsonify, current_app
from app.utils.decorators import token_required
import datetime
from bson import ObjectId

sync_bp = Blueprint("sync", __name__)

# Helper function to parse timestamp strings safely
def parse_timestamp(timestamp_str):
    if not timestamp_str:
        return None
    try:
        # Assuming ISO format. Adjust if your client sends another format.
        return datetime.datetime.fromisoformat(timestamp_str)
    except ValueError:
        return None

@sync_bp.route("/check_sync_status", methods=["GET"]) # Renamed for clarity
@token_required
def check_sync_status(current_user):
    # For GET requests, use request.args
    client_last_sync_str = request.args.get("last_success_sync") or None
    client_last_sync = parse_timestamp(client_last_sync_str) or None

    sync_doc = current_app.mongo_db.sync_data.find_one({"username": current_user["username"]})

    # If no sync data on server, client should perform an initial sync (push data)
    if not sync_doc:
        return jsonify({"status": "initial_sync_required", "message": "No sync data on server for this user."}), 200

    server_last_modified = sync_doc.get("last_modified")
    if not isinstance(server_last_modified, datetime.datetime):
        # Attempt to parse if it's a string, otherwise handle as an error
        server_last_modified = parse_timestamp(server_last_modified)
        if not server_last_modified:
            current_app.logger.error(f"Invalid last_modified format in sync_doc for user {current_user['username']}")
            return jsonify({"status": "error", "error": "Server sync data corrupted (invalid timestamp)"}), 500

    device_info = {}
    last_modified_by_device_id = sync_doc.get("last_modified_by_device")
    if last_modified_by_device_id:
        device = current_app.mongo_db.devices.find_one({"device_id": last_modified_by_device_id})
        if device:
            device_info = {
                "name": device.get("name", "Unknown Device"),
                "device_id": device.get("device_id", "Unknown ID")
            }

    # Scenario 1: Client has no sync data or server has newer data
    if client_last_sync is None or client_last_sync < server_last_modified:
        is_initial_sync = (client_last_sync is None)
        return jsonify({
            "status": "pull_required", # Client needs to pull data from server
            "message": "Server has newer data or client needs initial sync.",
            "server_last_modified": server_last_modified.isoformat(),
            "last_modified_by_device": device_info.get("name"),
            "device_id": device_info.get("device_id"),
            "initial_sync": is_initial_sync
        }), 200
    # Scenario 2: Client has newer data (or equal, implying client needs to push)
    elif client_last_sync > server_last_modified:
        return jsonify({
            "status": "push_required", # Client needs to push data to server
            "message": "Client has newer data than server.",
            "server_last_modified": server_last_modified.isoformat(),
            "last_modified_by_device": device_info.get("name"),
            "device_id": device_info.get("device_id")
        }), 200
    # Scenario 3: Client and server are in sync
    else: # client_last_sync == server_last_modified
        return jsonify({"status": "in_sync", "message": "Client and server data are in sync."}), 200

@sync_bp.route("/perform_sync", methods=["POST", "GET"]) # Renamed for clarity
@token_required
def perform_sync(current_user):
    # Common data extraction (assuming request.json for POST, request.args for GET for common fields)
    client_last_sync_str = request.json.get("last_success_sync") if request.method == "POST" else request.args.get("last_success_sync")
    client_last_sync = parse_timestamp(client_last_sync_str) or None
    device_id_from_client = request.json.get("device_id") if request.method == "POST" else request.args.get("device_id")


    sync_doc = current_app.mongo_db.sync_data.find_one({"username": current_user["username"]})
    server_last_modified = None
    if sync_doc:
        server_last_modified = sync_doc.get("last_modified")
        if not isinstance(server_last_modified, datetime.datetime):
            server_last_modified = parse_timestamp(server_last_modified)
            if not server_last_modified:
                current_app.logger.error(f"Invalid last_modified format in sync_doc for user {current_user['username']}")
                return jsonify({"status": "error", "error": "Server sync data corrupted (invalid timestamp)"}), 500

    # --- POST Request: Client is sending data to server (Push) ---
    if request.method == "POST":
        client_data = request.json.get("data")
        print(f"Client data: {client_last_sync}, {client_data}, {device_id_from_client}")
        if not client_data or not device_id_from_client:
            return jsonify({"status": "error", "error": "Missing required sync data (data, last_success_sync, or device_id)"}), 400

        # Validate that client has newer data or it's an initial sync
        if sync_doc and (client_last_sync is None or client_last_sync < server_last_modified):
            # Client's data is older, it should have pulled first
            return jsonify({"status": "error", "error": "Conflict: Server has newer data. Please pull from server first."}), 409

        # Update or insert the sync data
        new_sync_data = {
            "username": current_user["username"],
            "data": client_data,
            "last_modified": datetime.datetime.now(), # Server's timestamp when it received the update
            "last_modified_by_device": device_id_from_client,
            "sync_id": f"{current_user['username']}.sitemarker_main_sync_id" # A single, consistent sync_id for the main data blob
        }

        if sync_doc:
            # Update existing document
            current_app.mongo_db.sync_data.update_one(
                {"username": current_user["username"]},
                {"$set": new_sync_data}
            )
        else:
            # Insert new document (for initial sync)
            current_app.mongo_db.sync_data.insert_one(new_sync_data)

        return jsonify({"status": "success", "message": "Data pushed to server successfully."}), 200

    # --- GET Request: Client is requesting data from server (Pull) ---
    elif request.method == "GET":
        if not sync_doc:
            return jsonify({"status": "error", "error": "No sync data found for user. Client should perform initial push."}), 404

        # If client's last sync is newer or equal, server has nothing to give
        if client_last_sync and client_last_sync >= server_last_modified:
            return jsonify({"status": "error", "error": "Client is already up-to-date or has newer data. No pull required."}), 409

        device_info = {}
        last_modified_by_device_id = sync_doc.get("last_modified_by_device")
        if last_modified_by_device_id:
            device = current_app.mongo_db.devices.find_one({"device_id": last_modified_by_device_id})
            if device:
                device_info = {
                    "name": device.get("name", "Unknown Device"),
                    "device_id": device.get("device_id", "Unknown ID")
                }

        return jsonify({
            "status": "success",
            "message": "Data pulled from server successfully.",
            "data": sync_doc["data"],
            "last_synced_at": server_last_modified.isoformat(),
            "last_modified_by": device_info.get("name"),
            "device_id": device_info.get("device_id")
        }), 200