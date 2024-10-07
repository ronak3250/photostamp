// Dart imports:
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:screenshot/screenshot.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:mime/mime.dart';

import '../utils/pixel_transparent_painter.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PreviewImgPage extends StatefulWidget {
  final Uint8List imgBytes;
  final double? generationTime;
  final bool showThumbnail;
  final ui.Image? rawOriginalImage;
  final ImageGenerationConfigs? generationConfigs;

  const PreviewImgPage({
    super.key,
    required this.imgBytes,
    this.generationTime,
    this.rawOriginalImage,
    this.generationConfigs,
    this.showThumbnail = false,
  }) : assert(showThumbnail == false || rawOriginalImage != null,
            'rawOriginalImage is required if you want to display a thumbnail.');

  @override
  State<PreviewImgPage> createState() => _PreviewImgPageState();
}

class _PreviewImgPageState extends State<PreviewImgPage> {
  final _valueStyle = const TextStyle(fontStyle: FontStyle.italic);

  Future<ImageInfos>? _decodedImageInfos;
  String _contentType = 'Unknown';
  double? _generationTime;

  Future<Uint8List?>? _highQualityGeneration;

  late Uint8List _imageBytes;

  final _numberFormatter = NumberFormat();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    _generationTime = widget.generationTime;
    _imageBytes = widget.imgBytes;
    _setContentType();
    super.initState();
  }

  void _setContentType() {
    _contentType = lookupMimeType('', headerBytes: _imageBytes) ?? 'Unknown';
  }

  String formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (log(bytes) / log(1024)).floor();
    var size = bytes / pow(1024, i);
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }
  // Future<void> _takeScreenshot() async {
  //   // Step 1: Capture the screenshot
  //   Uint8List? screenshotImage = await _screenshotController.capture();
  //
  //   if (screenshotImage == null) {
  //     // Handle case where screenshot failed
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to capture screenshot')),
  //     );
  //     return;
  //   }
  //
  //   // Step 2: Use FilePicker to let the user select a folder
  //   String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  //
  //   if (selectedDirectory == null) {
  //     // User canceled the folder selection
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Folder selection canceled')),
  //     );
  //     return;
  //   }
  //
  //   // Step 3: Save the screenshot in the chosen directory
  //   String fileName = 'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
  //   String filePath = path.join(selectedDirectory, fileName);
  //
  //   // Create a file and write the screenshot bytes to it
  //   File file = File(filePath);
  //   await file.writeAsBytes(screenshotImage);
  //
  //   // Notify the user that the screenshot has been saved
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Screenshot saved at $filePath')),
  //   );
  //
  //   // Step 4: Open the saved screenshot
  //   OpenFile.open(filePath);
  // }

  // Future<void> _takeScreenshot() async {
  //       final directory = await getApplicationDocumentsDirectory();
  //       final path = '${directory.path}/preview_image.png';
  //
  //       _screenshotController.capture().then((Uint8List? image) async {
  //         if (image != null) {
  //           final file = File(path);
  //           await file.writeAsBytes(image);
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('Screenshot saved at $path')),
  //           );
  //         }
  //       }).catchError((onError) {
  //         print(onError);
  //       });
  //     }

  Future<void> _takeScreenshot() async {
    try {
      // Step 1: Capture the screenshot
      Uint8List? screenshotImage = await _screenshotController.capture();

      if (screenshotImage == null) {
        // Handle case where screenshot failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture screenshot')),
        );
        return;
      }

      // Step 2: Get the internal storage directory (for Android devices)
      final directory = await getExternalStorageDirectory();

      if (directory == null) {
        // Handle case where directory is not accessible
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access internal storage')),
        );
        return;
      }

      // Step 3: Create a file path in the internal storage directory
      String fileName = 'edited_image_${DateTime.now().millisecondsSinceEpoch}.png';
      String filePath = path.join(directory.path, fileName);

      // Step 4: Save the screenshot to the internal storage
      File file = File(filePath);
      await file.writeAsBytes(screenshotImage);

      // Step 5: Notify the user that the screenshot has been saved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot saved at $filePath')),
      );

      // Step 6: Optionally, open the saved image
      OpenFile.open(filePath);
    } catch (e) {
      // Handle any errors during the saving process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving screenshot: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _decodedImageInfos ??=
          decodeImageInfos(bytes: _imageBytes, screenSize: constraints.biggest);

      if (widget.showThumbnail) {
        Stopwatch stopwatch = Stopwatch()..start();
        _highQualityGeneration ??= generateHighQualityImage(
          widget.rawOriginalImage!,

          /// Set optional configs for the output
          configs: widget.generationConfigs ?? const ImageGenerationConfigs(),
          context: context,
        ).then((res) {
          if (res == null) return res;
          _imageBytes = res;
          _generationTime = stopwatch.elapsedMilliseconds.toDouble();
          stopwatch.stop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _decodedImageInfos = null;
            _setContentType();
            setState(() {});
          });
          return res;
        });
      }
      return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Result'),
            actions: [
              IconButton(
                icon: const Icon(Icons.camera),
                onPressed:() {
                  _takeScreenshot();
                },
              ),
            ],
          ),
          body: CustomPaint(
            painter: const PixelTransparentPainter(
              primary: Color.fromARGB(255, 17, 17, 17),
              secondary: Color.fromARGB(255, 36, 36, 37),
            ),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                if (!widget.showThumbnail)
                  Hero(
                    tag: const ProImageEditorConfigs().heroTag,
                    child: _buildFinalImage(),
                  )
                else
                  _buildThumbnailPreview(),
                if (_generationTime != null) _buildGenerationInfos(),
              ],
            ),
          ),
        ),
      );
    });
  }
  Widget _buildFinalImage({Uint8List? bytes}) {
    return Screenshot(
      controller: _screenshotController,
      child: InteractiveViewer(
        maxScale: 7,
        minScale: 1,
        child: Image.memory(
          bytes ?? _imageBytes,
          fit: BoxFit.contain,
        ),
      ),
    );
  }


  // Widget _buildFinalImage({Uint8List? bytes}) {
  //   return InteractiveViewer(
  //     maxScale: 7,
  //     minScale: 1,
  //     child: Image.memory(
  //       bytes ?? _imageBytes,
  //       fit: BoxFit.contain,
  //     ),
  //   );
  // }


  Widget _buildGenerationInfos() {
    TableRow tableSpace = const TableRow(
      children: [SizedBox(height: 3), SizedBox()],
    );
    return Positioned(
      top: 10,
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: FutureBuilder<ImageInfos>(
                future: _decodedImageInfos,
                builder: (context, snapshot) {
                  return Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        const Text('Generation-Time'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '${_numberFormatter.format(_generationTime)} ms',
                            style: _valueStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]),
                      tableSpace,
                      TableRow(children: [
                        const Text('Image-Size'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            formatBytes(_imageBytes.length),
                            style: _valueStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]),
                      tableSpace,
                      TableRow(children: [
                        const Text('Content-Type'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _contentType,
                            style: _valueStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]),
                      tableSpace,
                      TableRow(children: [
                        const Text('Dimension'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            snapshot.connectionState == ConnectionState.done
                                ? '${_numberFormatter.format(snapshot.data!.rawSize.width.round())} x ${_numberFormatter.format(snapshot.data!.rawSize.height.round())}'
                                : 'Loading...',
                            style: _valueStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]),
                      tableSpace,
                      TableRow(children: [
                        const Text('Pixel-Ratio'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            snapshot.connectionState == ConnectionState.done
                                ? snapshot.data!.pixelRatio.toStringAsFixed(3)
                                : 'Loading...',
                            style: _valueStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailPreview() {
    if (_highQualityGeneration == null) return Container();
    return FutureBuilder<Uint8List?>(
        future: _highQualityGeneration,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: snapshot.connectionState == ConnectionState.done
                ? _buildFinalImage(bytes: snapshot.data)
                : Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Hero(
                        tag: const ProImageEditorConfigs().heroTag,
                        child: Image.memory(
                          widget.imgBytes,
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (snapshot.connectionState != ConnectionState.done)
                        const Center(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: FittedBox(
                              child: PlatformCircularProgressIndicator(
                                configs: ProImageEditorConfigs(),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          );
        });
  }
}
