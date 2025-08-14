// package io.github.aerocyber.sitemarker

// import io.flutter.embedding.android.FlutterActivity

// class MainActivity: FlutterActivity()

package io.github.aerocyber.sitemarker

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.DocumentsContract
import androidx.annotation.NonNull
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStream
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "io.github.aerocyber.sitemarker.files"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "saveFile") {
                val name = call.argument<String>("name") ?: run {
                    result.error("INVALID_NAME", "Missing file name", null)
                    return@setMethodCallHandler
                }

                val safeName = name.replace(Regex("[^A-Za-z0-9_.-]"), "_")
                if (!safeName.endsWith(".omio")) {
                    result.error("INVALID_EXTENSION", "Only .omio extension is allowed", null)
                    return@setMethodCallHandler
                }

                val byteArray = call.argument<ByteArray>("bytes")
                if (byteArray == null || byteArray.isEmpty()) {
                    result.error("INVALID_DATA", "No data to write", null)
                    return@setMethodCallHandler
                }

                try {
                    val outputStream: OutputStream? = when {
                        Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> {
                            val resolver = contentResolver
                            val contentValues = android.content.ContentValues().apply {
                                put(android.provider.MediaStore.MediaColumns.DISPLAY_NAME, safeName)
                                put(android.provider.MediaStore.MediaColumns.MIME_TYPE, "application/x-omio")
                                put(android.provider.MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                            }
                            val uri = resolver.insert(android.provider.MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
                            uri?.let { resolver.openOutputStream(it) }
                        }
                        else -> {
                            val dir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                            val file = File(dir, safeName)
                            FileOutputStream(file)
                        }
                    }

                    outputStream?.use { it.write(byteArray) }
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
