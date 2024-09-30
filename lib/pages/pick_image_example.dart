// // Dart imports:
// import 'dart:io';
// import 'dart:math';
//
// // Flutter imports:
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// // Package imports:
// import 'package:image_picker/image_picker.dart';
// import 'package:pro_image_editor/pro_image_editor.dart';
//
// // Project imports:
// import '../utils/example_helper.dart';
//
// class PickImageExample extends StatefulWidget {
//   const PickImageExample({super.key});
//
//   @override
//   State<PickImageExample> createState() => _PickImageExampleState();
// }
//
// class _PickImageExampleState extends State<PickImageExample>
//     with ExampleHelperState<PickImageExample> {
//   void _openPicker(ImageSource source) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: source);
//
//     if (image == null) return;
//
//     String? path;
//     Uint8List? bytes;
//
//     if (kIsWeb) {
//       bytes = await image.readAsBytes();
//
//       if (!mounted) return;
//       await precacheImage(MemoryImage(bytes), context);
//     } else {
//       path = image.path;
//       if (!mounted) return;
//       await precacheImage(FileImage(File(path)), context);
//     }
//
//     if (!mounted) return;
//     if (kIsWeb ||
//         (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)) {
//       Navigator.pop(context);
//     }
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => _buildEditor(path: path, bytes: bytes),
//       ),
//     );
//   }



import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;

import '../utils/example_helper.dart';

class PickImageExample extends StatefulWidget {
  const PickImageExample({super.key});

  @override
  State<PickImageExample> createState() => _PickImageExampleState();
}

class _PickImageExampleState extends State<PickImageExample>
    with ExampleHelperState<PickImageExample> {

  // Future<File> addStampToImage(File imageFile, ImageSource source) async {
  //   final bytes = await imageFile.readAsBytes();
  //   final image = img.decodeImage(bytes);
  //
  //   if (image == null) {
  //     throw Exception('Failed to decode image');
  //   }
  //
  //   final stampText = await getStampText(imageFile, source);
  //   final stampedImage = img.drawString(image, stampText, font: img.arial48,);
  //   final outputPath = imageFile.path.replaceFirst('.jpg', '_stamped.jpg');
  //   final stampedFile = File(outputPath)..writeAsBytesSync(img.encodeJpg(stampedImage));
  //
  //   return stampedFile;
  Future<File> addStampToImage(File imageFile, ImageSource source) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final stampText = await getStampText(imageFile, source);

    // Use arial48 as the base font
    final font = img.arial48;

    // Calculate text dimensions (approximate)
    final textWidth = stampText.length * font.size ~/4.0;  // Rough estimate
    final textHeight = font.size;

    // Calculate position (bottom right corner with 10px padding)
    final x = image.width - textWidth;
    final y = image.height - textHeight;

    // Draw the text twice to create a bold effect
    img.drawString(
      image,
      font:font,
     x: x - 3,
     y:y - 3,
      stampText,
      color: img.ColorRgb8(0, 0, 0), // Black shadow for visibility
    );

    img.drawString(
      image,
     font:  font,
      x:x,
      y:y,
      stampText,
      color: img.ColorRgb8(255, 255, 255), // White color for main text
    );

    final outputPath = imageFile.path.replaceFirst('.jpg', '_stamped.jpg');
    final stampedFile = File(outputPath)..writeAsBytesSync(img.encodeJpg(image));

    return stampedFile;
  }

  Future<String> getStampText(File imageFile, ImageSource source) async {
    if (source == ImageSource.camera) {
      final exifData = await readExifFromBytes(await imageFile.readAsBytes());
      final dateTime = exifData['EXIF DateTimeOriginal']?.printable ?? 'Unknown';
      final latitude = exifData['GPS GPSLatitude']?.printable ?? 'Unknown';
      final longitude = exifData['GPS GPSLongitude']?.printable ?? 'Unknown';
      return 'Date: $dateTime\nLocation: $latitude, $longitude';
    } else {
      return 'Uploaded from Gallery';
    }
  }

  void _openPicker(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    String? path;
    Uint8List? bytes;

    if (kIsWeb) {
      bytes = await image.readAsBytes();
      // Note: We can't add stamps to web images in this example
      if (!mounted) return;
      await precacheImage(MemoryImage(bytes), context);
    } else {
      File imageFile = File(image.path);
      File stampedFile = await addStampToImage(imageFile, source);
      path = stampedFile.path;
      if (!mounted) return;
      await precacheImage(FileImage(stampedFile), context);
    }

    if (!mounted) return;
    if (kIsWeb ||
        (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)) {
      Navigator.pop(context);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _buildEditor(path: path, bytes: bytes),
      ),
    );
  }
  void _chooseCameraOrGallery() async {
    /// Open directly the gallery if the camera is not supported
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      _openPicker(ImageSource.gallery);
      return;
    }

    if (!kIsWeb && Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoTheme(
          data: const CupertinoThemeData(),
          child: CupertinoActionSheet(
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () => _openPicker(ImageSource.camera),
                child: const Wrap(
                  spacing: 7,
                  runAlignment: WrapAlignment.center,
                  children: [
                    Icon(CupertinoIcons.photo_camera),
                    Text('Camera'),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () => _openPicker(ImageSource.gallery),
                child: const Wrap(
                  spacing: 7,
                  runAlignment: WrapAlignment.center,
                  children: [
                    Icon(CupertinoIcons.photo),
                    Text('Gallery'),
                  ],
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        constraints: BoxConstraints(
          minWidth: min(MediaQuery.of(context).size.width, 360),
        ),
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                child: Wrap(
                  spacing: 45,
                  runSpacing: 30,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    MaterialIconActionButton(
                      primaryColor: const Color(0xFFEC407A),
                      secondaryColor: const Color(0xFFD3396D),
                      icon: Icons.photo_camera,
                      text: 'Camera',
                      onTap: () => _openPicker(ImageSource.camera),
                    ),
                    MaterialIconActionButton(
                      primaryColor: const Color(0xFFBF59CF),
                      secondaryColor: const Color(0xFFAC44CF),
                      icon: Icons.image,
                      text: 'Gallery',
                      onTap: () => _openPicker(ImageSource.gallery),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: _chooseCameraOrGallery,
      leading: const Icon(Icons.attachment_outlined),
      title: const Text('Pick from Gallery or Camera'),
      subtitle: !kIsWeb &&
              (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
          ? const Text('The camera is not supported on this platform.')
          : null,
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildEditor({String? path, Uint8List? bytes}) {
    if (path != null) {
      return ProImageEditor.file(
        File(path),
        callbacks: ProImageEditorCallbacks(
          onImageEditingStarted: onImageEditingStarted,
          onImageEditingComplete: onImageEditingComplete,
          onCloseEditor: onCloseEditor,
        ),
        configs: ProImageEditorConfigs(
          designMode: platformDesignMode,
        ),
      );
    } else {
      return ProImageEditor.memory(
        bytes!,
        callbacks: ProImageEditorCallbacks(
          onImageEditingStarted: onImageEditingStarted,
          onImageEditingComplete: onImageEditingComplete,
          onCloseEditor: onCloseEditor,
        ),
        configs: ProImageEditorConfigs(
          designMode: platformDesignMode,
        ),
      );
    }
  }
}

class MaterialIconActionButton extends StatelessWidget {
  const MaterialIconActionButton({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: onTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                CustomPaint(
                  painter: CircleHalf(secondaryColor),
                  size: const Size(60, 60),
                ),
                Icon(icon, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class CircleHalf extends CustomPainter {
  CircleHalf(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      pi,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
