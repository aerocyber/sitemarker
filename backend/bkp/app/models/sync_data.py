def sync_record(user_id, encrypted_data, modified_at):
    return {
        "user_id": user_id,
        "data": encrypted_data,
        "modified_at": modified_at
    }
