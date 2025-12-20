// package io.github.aerocyber.sitemarker

// import io.flutter.embedding.android.FlutterActivity

// class MainActivity: FlutterActivity()

package io.github.aerocyber.sitemarker

import android.os.Build
import android.os.Environment
import android.content.ContentValues
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "io.github.aerocyber.sitemarker.files"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "saveFile") {
                val rawName = call.argument<String>("name")
                val byteArray = call.argument<ByteArray>("bytes")

                if (rawName == null) {
                    result.error("INVALID_NAME", "Missing file name", null)
                    return@setMethodCallHandler
                }

                if (byteArray == null || byteArray.isEmpty()) {
                    result.error("INVALID_DATA", "No data to write", null)
                    return@setMethodCallHandler
                }

                // Strip path separators to prevent directory traversal
                val simpleName = File(rawName).name
                // Replace invalid chars
                val safeName = simpleName.replace(Regex("[^A-Za-z0-9_.-]"), "_")

                if (!safeName.endsWith(".omio")) {
                    result.error("INVALID_EXTENSION", "Only .omio extension is allowed", null)
                    return@setMethodCallHandler
                }

                try {
                    val outputStream: OutputStream?

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        // Android 10+ (Scoped Storage) - No Permissions needed
                        val contentValues = ContentValues().apply {
                            put(MediaStore.MediaColumns.DISPLAY_NAME, safeName)
                            // Use octet-stream for unknown custom types to be safe
                            put(MediaStore.MediaColumns.MIME_TYPE, "application/json")
                            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                            // Mark as pending while writing
                            put(MediaStore.MediaColumns.IS_PENDING, 1)
                        }

                        val uri = contentResolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)

                        if (uri == null) {
                            result.error("WRITE_FAILED", "Could not create MediaStore entry", null)
                            return@setMethodCallHandler
                        }

                        outputStream = contentResolver.openOutputStream(uri)

                        // Write data
                        outputStream?.use { it.write(byteArray) }

                        // Mark as finished (not pending)
                        contentValues.clear()
                        contentValues.put(MediaStore.MediaColumns.IS_PENDING, 0)
                        contentResolver.update(uri, contentValues, null, null)

                    } else {
                        // Android 9 and below - Requires WRITE_EXTERNAL_STORAGE permission
                        // Ensure your Flutter code requests this permission BEFORE calling this method
                        val downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                        if (!downloadDir.exists()) {
                            downloadDir.mkdirs()
                        }
                        val file = File(downloadDir, safeName)
                        outputStream = FileOutputStream(file)
                        outputStream.use { it.write(byteArray) }
                    }

                    result.success(null)

                } catch (e: Exception) {
                    result.error("WRITE_FAILED", e.message, e.stackTraceToString())
                }
            } else {
                result.notImplemented()
            }
        }
    }
}