package app.mojidraw

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private val galleryChannelHandler = GalleryChannelHandler(context)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        galleryChannelHandler.register(flutterEngine)
    }
}
