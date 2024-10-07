import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/example_helper.dart';

class PickImageExample extends StatefulWidget {
  const PickImageExample({super.key});

  @override
  State<PickImageExample> createState() => _PickImageExampleState();
}

class _PickImageExampleState extends State<PickImageExample>
    with ExampleHelperState<PickImageExample> {
  File? customLogo;
  static const String defaultLogoPath = 'assets/images/default_logo.png';
  static const String customLogoKey = 'custom_logo_path';

  bool _isLoading = false; // Add this variable
  @override
  void initState() {
    super.initState();
    _loadCustomLogo();
  }

  Future<void> _loadCustomLogo() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLogoPath = prefs.getString(customLogoKey);
    if (savedLogoPath != null) {
      setState(() {
        customLogo = File(savedLogoPath);
      });
    }
  }

  Future<void> _changeLogoFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String newPath = '${directory.path}/custom_logo.png';
      final File newLogoFile = await File(image.path).copy(newPath);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(customLogoKey, newPath);

      setState(() {
        customLogo = newLogoFile;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logo updated successfully')),
      );
    }
  }

  Future<img.Image?> _getLogoImage() async {
    try {
      if (customLogo != null && await customLogo!.exists()) {
        final bytes = await customLogo!.readAsBytes();
        return img.decodeImage(bytes);
      } else {
        // Load default logo from assets
        final ByteData data = await rootBundle.load(defaultLogoPath);
        final bytes = data.buffer.asUint8List();
        return img.decodeImage(bytes);
      }
    } catch (e) {
      print('Error loading logo: $e');
      return null;
    }
  }

  Future<File> addStampToImage(File imageFile, ImageSource source) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Add logo
    try {
      final logoImage = await _getLogoImage();
      if (logoImage != null) {
        // Resize logo to be proportional to the image size
        final logoSize = image.width ~/ 6;
        final resizedLogo = img.copyResize(
          logoImage,
          width: logoSize,
          height: (logoSize * logoImage.height ~/ logoImage.width),
          interpolation: img.Interpolation.linear,
        );

        // Calculate position for bottom left with padding
        final padding = 20;
        final x = padding;
        final y = image.height - resizedLogo.height - padding;

        // Composite the logo onto the main image
        img.compositeImage(
          image,
          resizedLogo,
          dstX: x,
          dstY: y,
          blend: img.BlendMode.hardLight,
        );
      }
    } catch (e) {
      print('Error adding logo: $e');
    }

    final stampText = await getStampText(imageFile, source);

    // Use a smaller font for gallery images, larger font for camera images
    final font = source == ImageSource.gallery ? img.arial24 : img.arial48;

    // Calculate text dimensions and position
    var textWidth = (source == ImageSource.gallery)
        ? stampText.length * font.size ~/ 10
        : stampText.length * font.size ~/ 3.5;
    final textHeight = font.size;

    var x = (source == ImageSource.gallery)
        ? image.width - textWidth - 250
        : image.width - textWidth - -300;
    var y = (source == ImageSource.gallery)
        ? image.height - textHeight - 10
        : image.height - textHeight - 100;

    // Draw text with shadow effect
    img.drawString(
      image,
      font: font,
      x: x - 1,
      y: y - 1,
      stampText,
      color: img.ColorRgb8(0, 0, 0),
    );

    img.drawString(
      image,
      font: font,
      x: x,
      y: y,
      stampText,
      color: img.ColorRgb8(255, 255, 255),
    );

    final outputPath = imageFile.path.replaceFirst('.jpg', '_stamped.jpg');
    final stampedFile = File(outputPath)
      ..writeAsBytesSync(img.encodeJpg(image));

    return stampedFile;
  }

  Future<String> getStampText(File imageFile, ImageSource source) async {
    if (source == ImageSource.camera) {
      final exifData = await readExifFromBytes(await imageFile.readAsBytes());
      final dateTime = exifData['EXIF DateTimeOriginal']?.printable ??
          DateTime.now().toString();

      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        String place = placemarks.isNotEmpty
            ? '${placemarks.first.locality}, ${placemarks.first.country}'
            : 'Unknown Place';

        return 'Date: $dateTime\nPlace: $place\nLocation: ${position.latitude}, ${position.longitude}';
      } catch (e) {
        return 'Date: $dateTime\nLocation: Unavailable';
      }
    } else {
      return 'Uploaded from Gallery\n${DateTime.now()}';
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _openPicker(ImageSource source) async {
    setState(() {
      _isLoading = true; // Show loader
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image == null) return;

      String? path;
      Uint8List? bytes;

      if (kIsWeb) {
        bytes = await image.readAsBytes();
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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
  }

  void _chooseCameraOrGallery() async {
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
              onPressed: () => Navigator.pop(context),
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

  List<Widget> examples = [];

  @override
  void didChangeDependencies() {
    examples = [
      ListTile(
        onTap: _chooseCameraOrGallery,
        leading: const Icon(Icons.attachment_outlined),
        title: const Text('Pick from Gallery or Camera'),
        subtitle: !kIsWeb &&
                (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
            ? const Text('The camera is not supported on this platform.')
            : null,
        trailing: const Icon(Icons.chevron_right),
      ),
      ListTile(
        onTap: _changeLogoFromGallery,
        leading: const Icon(Icons.photo_outlined),
        title: const Text('Change Watermark Logo'),
        trailing: const Icon(Icons.chevron_right),
      ),
    ];
  }

  Widget _buildExampleItem(Widget example1) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            example1,
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return Container(
        color: Colors.black54, // Semi-transparent overlay
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    return Stack(
      children: [
        AnimationLimiter(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: 100,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: examples.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: 1,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _buildExampleItem(examples[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
                  // painter: CircleHalf(secondaryColor),
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
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
