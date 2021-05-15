import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

const String permissionDialogTitle = 'Permission required';

const String permissionRationale = '''
To save your image to the gallery, Mojidraw needs to access media files on your device.\n
Please grant the permission in the following dialog.''';

const String permissionPermanentlyDeniedHint = '''
You permanently denied the permission to access media files on your device.\n
To undo this, grant the permission in the app settings and press the save button again.''';

class GalleryService {
  static const platform = MethodChannel('mojidraw.app/gallery');

  final BuildContext context;

  GalleryService(this.context);

  Future<bool> tryGetGalleryAccess() async {
    if (!Platform.isAndroid) {
      throw GalleryServiceException(
          'Saving to gallery is only supported on Android');
    }

    if (!(await _isStoragePermissionRequired())) {
      return true;
    }

    final permission = Permission.storage;
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (await permission.shouldShowRequestRationale) {
      await _showRequestRationaleDialog();
    }

    final statusAfterRequest = await permission.request();

    if (!statusAfterRequest.isPermanentlyDenied) {
      return statusAfterRequest.isGranted;
    }

    final shouldOpenAppSettings = await _showPermanentlyDeniedDialog();
    if (shouldOpenAppSettings) {
      await openAppSettings();
    }

    return false;
  }

  Future<void> saveImageToGallery(
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

  Future<bool> _isStoragePermissionRequired() async {
    try {
      return (await platform
          .invokeMethod<bool>('isStoragePermissionRequired'))!;
    } on PlatformException catch (e) {
      throw GalleryServiceException(e.message);
    }
  }

  Future<void> _showRequestRationaleDialog() async => showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: const Text(permissionDialogTitle),
            content: const Text(permissionRationale),
            actions: [
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('GOT IT'))
            ],
          ));

  Future<bool> _showPermanentlyDeniedDialog() async =>
      await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text(permissionDialogTitle),
                content: const Text(permissionPermanentlyDeniedHint),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('CANCEL')),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('OPEN APP SETTINGS'))
                ],
              )) ??
      false;

  static Uint8List _toByteArray(ByteData byteData) => byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
}

class GalleryServiceException implements Exception {
  final String? message;

  GalleryServiceException(this.message);
}
