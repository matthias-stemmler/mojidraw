import 'dart:typed_data';

import 'package:flutter/services.dart';

class GalleryService {
  static const platform = MethodChannel('mojidraw.app/gallery');

  static Future<void> saveImageToGallery(
      {required ByteData imageData,
      required String mimeType,
      required String displayName,
      required String album}) async {
    try {
      await platform.invokeMethod('saveImageToGallery', {
        'imageData': _toByteArray(imageData),
        'mimeType': mimeType,
        'displayName': displayName,
        'album': album
      });
    } on PlatformException catch (e) {
      throw GalleryServiceException(e.message);
    }
  }

  static Uint8List _toByteArray(ByteData byteData) => byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
}

class GalleryServiceException implements Exception {
  final String? message;

  GalleryServiceException(this.message);
}
