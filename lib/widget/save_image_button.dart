import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../platform/gallery_service.dart';
import '../state/drawing_state.dart';
import '../util/render_grid_image.dart';

const double _cellWidth = 128.0;

@immutable
class SaveImageButton extends StatefulWidget {
  final String? fontFamily;

  const SaveImageButton({Key? key, this.fontFamily}) : super(key: key);

  @override
  State createState() => _SaveImageButtonState();
}

class _SaveImageButtonState extends State<SaveImageButton> {
  bool _saving = false;

  Future<void> _saveImageUnlessAlreadySaving() async {
    if (_saving) {
      return;
    }

    _saving = true;

    try {
      await _saveImage(context);
    } finally {
      _saving = false;
    }
  }

  Future<void> _saveImage(BuildContext context) async {
    final galleryService = GalleryService(context);

    try {
      final DrawingState state = context.read<DrawingState>();

      if (state.saved) {
        await Fluttertoast.showToast(msg: 'Already saved to gallery');
        return;
      }

      final bool permitted = await galleryService.tryGetGalleryAccess();
      if (!permitted) {
        return;
      }

      await Fluttertoast.showToast(
        msg: 'Saved to gallery',
      );

      final Image image = await renderGridImage(
          grid: state.grid,
          cellSize: const Size.square(_cellWidth),
          fontFamily: widget.fontFamily,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(_cellWidth / 4));
      final ByteData? imageData =
          await image.toByteData(format: ImageByteFormat.png);

      if (imageData == null) {
        throw GalleryServiceException("Failed to encode image");
      }

      final timestamp = DateFormat("yyyy-MM-dd-HHmmss").format(DateTime.now());

      await galleryService.saveImageToGallery(
          imageData: imageData,
          mimeType: 'image/png',
          displayName: 'mojidraw-$timestamp',
          album: 'Mojidraw');

      state.markSaved();
    } on GalleryServiceException catch (e) {
      await Fluttertoast.cancel();

      await Fluttertoast.showToast(
          msg: 'Saving to gallery failed:\n${e.message}',
          backgroundColor: Theme.of(context).errorColor);
    }
  }

  @override
  Widget build(_) => IconButton(
      icon: const Icon(Icons.save_alt),
      tooltip: 'Save image to gallery',
      onPressed: _saveImageUnlessAlreadySaving);
}
