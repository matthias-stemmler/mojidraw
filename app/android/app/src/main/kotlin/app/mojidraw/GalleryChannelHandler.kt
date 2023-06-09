package app.mojidraw

import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import androidx.annotation.UiThread
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.OutputStream

class GalleryChannelHandler(context: Context) : MethodChannel.MethodCallHandler {
    private val channel: String = "mojidraw.app/gallery"
    private val context: Context = context

    fun register(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler(this)
    }

    @UiThread
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isStoragePermissionRequired" -> {
                try {
                    result.success(isStoragePermissionRequired())
                } catch (e: Throwable) {
                    result.error(e.javaClass.name, e.message, null)
                }
            }
            "saveImageToGallery" -> {
                CoroutineScope(Dispatchers.Default).launch {
                    try {
                        saveImageToGallery(
                                imageData = call.argument("imageData")!!,
                                mimeType = call.argument("mimeType")!!,
                                displayName = call.argument("displayName")!!,
                                album = call.argument("album")!!
                        )

                        launch(Dispatchers.Main) {
                            result.success(null)
                        }
                    } catch (e: Throwable) {
                        launch(Dispatchers.Main) {
                            result.error(e.javaClass.name, e.message, null)
                        }
                    }
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun isStoragePermissionRequired(): Boolean = !isMediaStoreSupported()

    private fun isMediaStoreSupported(): Boolean = Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q

    private fun saveImageToGallery(imageData: ByteArray, mimeType: String, displayName: String, album: String) {
        if (!isMediaStoreSupported()) {
            return saveImageToGalleryLegacy(imageData, mimeType, displayName, album)
        }

        val directory: File = File(Environment.DIRECTORY_PICTURES).resolve(album)

        val contentValues = ContentValues();
        contentValues.put(MediaStore.MediaColumns.RELATIVE_PATH, directory.path)
        contentValues.put(MediaStore.MediaColumns.DISPLAY_NAME, displayName)
        contentValues.put(MediaStore.MediaColumns.MIME_TYPE, mimeType)

        val resolver = context.contentResolver

        var uri: Uri? = null
        var stream: OutputStream? = null

        try {
            val contentUri: Uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
            uri = resolver.insert(contentUri, contentValues)

            if (uri == null) {
                throw IOException("Failed to create MediaStore record")
            }

            stream = resolver.openOutputStream(uri)

            if (stream == null) {
                throw IOException("Failed to open output stream")
            }

            stream.write(imageData)
        } catch (e: IOException) {
            if (uri != null) {
                resolver.delete(uri, null, null)
            }

            throw e
        } finally {
            stream?.close()
        }
    }

    @Suppress("DEPRECATION")
    private fun saveImageToGalleryLegacy(imageData: ByteArray, mimeType: String, displayName: String, album: String) {
        val directory: File = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).resolve(album)

        val extension: String = MimeTypeMap.getSingleton().getExtensionFromMimeType(mimeType)
                ?: throw IOException("Unsupported MIME type: $mimeType")

        val file = File(directory, "$displayName.$extension")

        directory.mkdirs()

        var stream: OutputStream? = null

        try {
            stream = FileOutputStream(file)
            stream.write(imageData)
        } finally {
            stream?.close()
        }

        val mediaScanIntent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
        val contentUri: Uri = Uri.fromFile(file)
        mediaScanIntent.data = contentUri
        context.sendBroadcast(mediaScanIntent)
    }
}