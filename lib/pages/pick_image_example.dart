// // import 'dart:io';
// // import 'dart:math';
// // import 'dart:typed_data';
// //
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:pro_image_editor/pro_image_editor.dart';
// // import 'package:exif/exif.dart';
// // import 'package:image/image.dart' as img;
// //
// // import '../utils/example_helper.dart';
// //
// // class PickImageExample extends StatefulWidget {
// //   const PickImageExample({super.key});
// //
// //   @override
// //   State<PickImageExample> createState() => _PickImageExampleState();
// // }
// //
// // class _PickImageExampleState extends State<PickImageExample>
// //     with ExampleHelperState<PickImageExample> {
// //   Future<File> addStampToImage(File imageFile, ImageSource source) async {
// //     final bytes = await imageFile.readAsBytes();
// //     final image = img.decodeImage(bytes);
// //
// //     if (image == null) {
// //       throw Exception('Failed to decode image');
// //     }
// //
// //     final stampText = await getStampText(imageFile, source);
// //
// //     // Use a smaller font for gallery images, larger font for camera images
// //     final font = source == ImageSource.gallery ? img.arial24 : img.arial48;
// //
// //     // Calculate text dimensions (approximate)
// //     var textWidth = (source == ImageSource.gallery)
// //         ? stampText.length * font.size ~/ 10
// //         : stampText.length * font.size ~/ 3.5; // Rough estimate
// //
// //     final textHeight = font.size;
// //
// //     // Calculate position (bottom right corner with 10px padding)
// //     var x = (source == ImageSource.gallery)
// //         ? image.width - textWidth - 250
// //         : image.width - textWidth - -350;
// //     var y = (source == ImageSource.gallery)
// //         ? image.height - textHeight - 10
// //         : image.height - textHeight - 100;
// //
// //     // Draw the text twice to create a bold effect
// //     img.drawString(
// //       image,
// //       font: font,
// //       x: x - 1,
// //       y: y - 1,
// //       stampText,
// //       color: img.ColorRgb8(0, 0, 0), // Black shadow for visibility
// //     );
// //
// //     img.drawString(
// //       image,
// //       font: font,
// //       x: x,
// //       y: y,
// //       stampText,
// //       color: img.ColorRgb8(255, 255, 255), // White color for main text
// //     );
// //
// //     final outputPath = imageFile.path.replaceFirst('.jpg', '_stamped.jpg');
// //     final stampedFile = File(outputPath)
// //       ..writeAsBytesSync(img.encodeJpg(image));
// //
// //     return stampedFile;
// //   }
// //
// //   // Future<File> addStampToImage(File imageFile, ImageSource source) async {
// //   //   final bytes = await imageFile.readAsBytes();
// //   //   final image = img.decodeImage(bytes);
// //   //
// //   //   if (image == null) {
// //   //     throw Exception('Failed to decode image');
// //   //   }
// //   //
// //   //   final stampText = await getStampText(imageFile, source);
// //   //
// //   //   // Use a smaller font size for gallery images
// //   //   final font = img.arial24; // Reduced font size
// //   //
// //   //   // Calculate text dimensions (approximate)
// //   //   final textWidth = stampText.length * font.size ~/ 4.0;  // Rough estimate
// //   //   final textHeight = font.size;
// //   //
// //   //   // Calculate position (bottom right corner with 10px padding)
// //   //   final x = image.width - textWidth - 10;
// //   //   final y = image.height - textHeight - 10;
// //   //
// //   //   // Draw the text twice to create a bold effect
// //   //   img.drawString(
// //   //     image,
// //   //     font: font,
// //   //     x: x - 3,
// //   //     y: y - 3,
// //   //     stampText,
// //   //     color: img.ColorRgb8(0, 0, 0), // Black shadow for visibility
// //   //   );
// //   //
// //   //   img.drawString(
// //   //     image,
// //   //     font: font,
// //   //     x: x,
// //   //     y: y,
// //   //     stampText,
// //   //     color: img.ColorRgb8(255, 255, 255), // White color for main text
// //   //   );
// //   //
// //   //   final outputPath = imageFile.path.replaceFirst('.jpg', '_stamped.jpg');
// //   //   final stampedFile = File(outputPath)..writeAsBytesSync(img.encodeJpg(image));
// //   //
// //   //   return stampedFile;
// //   // }
// //
// //   // Future<File> addStampToImage(File imageFile, ImageSource source) async {
// //   //   final bytes = await imageFile.readAsBytes();
// //   //   final image = img.decodeImage(bytes);
// //   //
// //   //   if (image == null) {
// //   //     throw Exception('Failed to decode image');
// //   //   }
// //   //
// //   //   final stampText = await getStampText(imageFile, source);
// //   //
// //   //   // Use arial48 as the base font
// //   //   final font = img.arial48;
// //   //
// //   //   // Calculate text dimensions (approximate)
// //   //   final textWidth = stampText.length * font.size ~/4.0;  // Rough estimate
// //   //   final textHeight = font.size;
// //   //
// //   //   // Calculate position (bottom right corner with 10px padding)
// //   //   final x = image.width - textWidth;
// //   //   final y = image.height - textHeight;
// //   //
// //   //   // Draw the text twice to create a bold effect
// //   //   img.drawString(
// //   //     image,
// //   //     font:font,
// //   //    x: x - 3,
// //   //    y:y - 3,
// //   //     stampText,
// //   //     color: img.ColorRgb8(0, 0, 0), // Black shadow for visibility
// //   //   );
// //   //
// //   //   img.drawString(
// //   //     image,
// //   //    font:  font,
// //   //     x:x,
// //   //     y:y,
// //   //     stampText,
// //   //     color: img.ColorRgb8(255, 255, 255), // White color for main text
// //   //   );
// //   //
// //   //   final outputPath = imageFile.path.replaceFirst('.jpg', '_stamped.jpg');
// //   //   final stampedFile = File(outputPath)..writeAsBytesSync(img.encodeJpg(image));
// //   //
// //   //   return stampedFile;
// //   // }
// //
// //   Future<String> getStampText(File imageFile, ImageSource source) async {
// //     if (source == ImageSource.camera) {
// //       final exifData = await readExifFromBytes(await imageFile.readAsBytes());
// //       final dateTime =
// //           exifData['EXIF DateTimeOriginal']?.printable ?? 'Unknown';
// //
// //       // Get current location
// //       Position position = await Geolocator.getCurrentPosition(
// //           desiredAccuracy: LocationAccuracy.high);
// //
// //       // Perform reverse geocoding to get place name
// //       List<Placemark> placemarks = await placemarkFromCoordinates(
// //         position.latitude,
// //         position.longitude,
// //       );
// //       String place = placemarks.isNotEmpty
// //           ? '${placemarks.first.locality}, ${placemarks.first.country}'
// //           : 'Unknown Place';
// //
// //       // Return formatted text including place name and coordinates
// //       return 'Date: $dateTime\nPlace: $place\nLocation: ${position.latitude}, ${position.longitude}';
// //     } else {
// //       return 'Uploaded from Gallery';
// //     }
// //   }
// //   Future<Position> _determinePosition() async {
// //     bool serviceEnabled;
// //     LocationPermission permission;
// //
// //     // Test if location services are enabled.
// //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) {
// //       // Location services are not enabled, request user to enable it
// //       return Future.error('Location services are disabled.');
// //     }
// //
// //     permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.denied) {
// //         // Permissions are denied, next time you could try requesting permissions again
// //         return Future.error('Location permissions are denied');
// //       }
// //     }
// //
// //     if (permission == LocationPermission.deniedForever) {
// //       // Permissions are permanently denied, we cannot request permissions.
// //       return Future.error('Location permissions are permanently denied.');
// //     }
// //
// //     // When permissions are granted, get the position of the device.
// //     return await Geolocator.getCurrentPosition();
// //   }
// //
// //   // Future<String> getStampText(File imageFile, ImageSource source) async {
// //   //   if (source == ImageSource.camera) {
// //   //     // Fetch EXIF data
// //   //     final exifData = await readExifFromBytes(await imageFile.readAsBytes());
// //   //     final dateTime =
// //   //         exifData['EXIF DateTimeOriginal']?.printable ?? 'Unknown';
// //   //
// //   //     try {
// //   //       // Get current location
// //   //       Position position = await _determinePosition();
// //   //
// //   //       // Reverse geocode to get place name
// //   //       List<Placemark> placemarks = await placemarkFromCoordinates(
// //   //         position.latitude,
// //   //         position.longitude,
// //   //       );
// //   //       String place = placemarks.isNotEmpty
// //   //           ? '${placemarks.first.locality}, ${placemarks.first.country}'
// //   //           : 'Unknown Place';
// //   //
// //   //       // Return formatted stamp text with location, place name, and coordinates
// //   //       return 'Date: $dateTime\nPlace: $place\nLocation: ${position.latitude}, ${position.longitude}';
// //   //     } catch (e) {
// //   //       // Handle potential errors in getting location
// //   //       return 'Date: $dateTime\nLocation: Location unavailable';
// //   //     }
// //   //   } else {
// //   //     return 'Uploaded from Gallery';
// //   //   }
// //   // }
// //
// //   // Future<String> getStampText(File imageFile, ImageSource source) async {
// //   //   if (source == ImageSource.camera) {
// //   //     final exifData = await readExifFromBytes(await imageFile.readAsBytes());
// //   //     final dateTime =
// //   //         exifData['EXIF DateTimeOriginal']?.printable ?? 'Unknown';
// //   //     final latitude = exifData['GPS GPSLatitude']?.printable ?? 'Unknown';
// //   //     final longitude = exifData['GPS GPSLongitude']?.printable ?? 'Unknown';
// //   //     return 'Date: $dateTime\nLocation: $latitude, $longitude';
// //   //   } else {
// //   //     return 'Uploaded from Gallery';
// //   //   }
// //   // }
// //
// //   void _openPicker(ImageSource source) async {
// //     final ImagePicker picker = ImagePicker();
// //     final XFile? image = await picker.pickImage(source: source);
// //
// //     if (image == null) return;
// //
// //     String? path;
// //     Uint8List? bytes;
// //
// //     if (kIsWeb) {
// //       bytes = await image.readAsBytes();
// //       // Note: We can't add stamps to web images in this example
// //       if (!mounted) return;
// //       await precacheImage(MemoryImage(bytes), context);
// //     } else {
// //       File imageFile = File(image.path);
// //       File stampedFile = await addStampToImage(imageFile, source);
// //       path = stampedFile.path;
// //       if (!mounted) return;
// //       await precacheImage(FileImage(stampedFile), context);
// //     }
// //
// //     if (!mounted) return;
// //     if (kIsWeb ||
// //         (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)) {
// //       Navigator.pop(context);
// //     }
// //
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => _buildEditor(path: path, bytes: bytes),
// //       ),
// //     );
// //   }
// //
// //   void _chooseCameraOrGallery() async {
// //     /// Open directly the gallery if the camera is not supported
// //     if (!kIsWeb &&
// //         (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
// //       _openPicker(ImageSource.gallery);
// //       return;
// //     }
// //
// //     if (!kIsWeb && Platform.isIOS) {
// //       showCupertinoModalPopup(
// //         context: context,
// //         builder: (BuildContext context) => CupertinoTheme(
// //           data: const CupertinoThemeData(),
// //           child: CupertinoActionSheet(
// //             actions: <CupertinoActionSheetAction>[
// //               CupertinoActionSheetAction(
// //                 onPressed: () => _openPicker(ImageSource.camera),
// //                 child: const Wrap(
// //                   spacing: 7,
// //                   runAlignment: WrapAlignment.center,
// //                   children: [
// //                     Icon(CupertinoIcons.photo_camera),
// //                     Text('Camera'),
// //                   ],
// //                 ),
// //               ),
// //               CupertinoActionSheetAction(
// //                 onPressed: () => _openPicker(ImageSource.gallery),
// //                 child: const Wrap(
// //                   spacing: 7,
// //                   runAlignment: WrapAlignment.center,
// //                   children: [
// //                     Icon(CupertinoIcons.photo),
// //                     Text('Gallery'),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //             cancelButton: CupertinoActionSheetAction(
// //               isDefaultAction: true,
// //               onPressed: () {
// //                 Navigator.pop(context);
// //               },
// //               child: const Text('Cancel'),
// //             ),
// //           ),
// //         ),
// //       );
// //     } else {
// //       showModalBottomSheet(
// //         context: context,
// //         showDragHandle: true,
// //         constraints: BoxConstraints(
// //           minWidth: min(MediaQuery.of(context).size.width, 360),
// //         ),
// //         builder: (context) {
// //           return Material(
// //             color: Colors.transparent,
// //             child: SingleChildScrollView(
// //               child: Padding(
// //                 padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
// //                 child: Wrap(
// //                   spacing: 45,
// //                   runSpacing: 30,
// //                   crossAxisAlignment: WrapCrossAlignment.center,
// //                   runAlignment: WrapAlignment.center,
// //                   alignment: WrapAlignment.spaceAround,
// //                   children: [
// //                     MaterialIconActionButton(
// //                       primaryColor: const Color(0xFFEC407A),
// //                       secondaryColor: const Color(0xFFD3396D),
// //                       icon: Icons.photo_camera,
// //                       text: 'Camera',
// //                       onTap: () => _openPicker(ImageSource.camera),
// //                     ),
// //                     MaterialIconActionButton(
// //                       primaryColor: const Color(0xFFBF59CF),
// //                       secondaryColor: const Color(0xFFAC44CF),
// //                       icon: Icons.image,
// //                       text: 'Gallery',
// //                       onTap: () => _openPicker(ImageSource.gallery),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListTile(
// //       onTap: _chooseCameraOrGallery,
// //       leading: const Icon(Icons.attachment_outlined),
// //       title: const Text('Pick from Gallery or Camera'),
// //       subtitle: !kIsWeb &&
// //               (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
// //           ? const Text('The camera is not supported on this platform.')
// //           : null,
// //       trailing: const Icon(Icons.chevron_right),
// //     );
// //   }
// //
// //   Widget _buildEditor({String? path, Uint8List? bytes}) {
// //     if (path != null) {
// //       return ProImageEditor.file(
// //         File(path),
// //         callbacks: ProImageEditorCallbacks(
// //           onImageEditingStarted: onImageEditingStarted,
// //           onImageEditingComplete: onImageEditingComplete,
// //           onCloseEditor: onCloseEditor,
// //         ),
// //         configs: ProImageEditorConfigs(
// //           designMode: platformDesignMode,
// //         ),
// //       );
// //     } else {
// //       return ProImageEditor.memory(
// //         bytes!,
// //         callbacks: ProImageEditorCallbacks(
// //           onImageEditingStarted: onImageEditingStarted,
// //           onImageEditingComplete: onImageEditingComplete,
// //           onCloseEditor: onCloseEditor,
// //         ),
// //         configs: ProImageEditorConfigs(
// //           designMode: platformDesignMode,
// //         ),
// //       );
// //     }
// //   }
// // }
// //
// // class MaterialIconActionButton extends StatelessWidget {
// //   const MaterialIconActionButton({
// //     super.key,
// //     required this.primaryColor,
// //     required this.secondaryColor,
// //     required this.icon,
// //     required this.text,
// //     required this.onTap,
// //   });
// //
// //   final Color primaryColor;
// //   final Color secondaryColor;
// //   final IconData icon;
// //   final String text;
// //   final VoidCallback onTap;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: 65,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           InkWell(
// //             borderRadius: BorderRadius.circular(60),
// //             onTap: onTap,
// //             child: Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 Container(
// //                   width: 60,
// //                   height: 60,
// //                   decoration: BoxDecoration(
// //                     color: primaryColor,
// //                     borderRadius: BorderRadius.circular(100),
// //                   ),
// //                 ),
// //                 CustomPaint(
// //                   painter: CircleHalf(secondaryColor),
// //                   size: const Size(60, 60),
// //                 ),
// //                 Icon(icon, color: Colors.white),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 7),
// //           Text(
// //             text,
// //             overflow: TextOverflow.ellipsis,
// //             maxLines: 1,
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 20),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class CircleHalf extends CustomPainter {
// //   CircleHalf(this.color);
// //
// //   final Color color;
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     Paint paint = Paint()..color = color;
// //     canvas.drawArc(
// //       Rect.fromCenter(
// //         center: Offset(size.height / 2, size.width / 2),
// //         height: size.height,
// //         width: size.width,
// //       ),
// //       pi,
// //       pi,
// //       false,
// //       paint,
// //     );
// //   }
// //
// //   @override
// //   bool shouldRepaint(CustomPainter oldDelegate) => false;
// // }
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pro_image_editor/pro_image_editor.dart';
// import 'package:exif/exif.dart';
// import 'package:image/image.dart' as img;
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
//
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
//   // Add logo URL and cache
//   String logoUrl = 'https://img.freepik.com/premium-photo/3d-rgb-letters-white-background_764664-3604.jpg?w=996'; // Replace with your actual logo URL
//   File? cachedLogo;
//
//   // Method to download and cache the logo
//   Future<File> getLogoFile() async {
//     if (cachedLogo != null) return cachedLogo!;
//
//     try {
//       final response = await http.get(Uri.parse(logoUrl));
//       final documentDirectory = await getApplicationDocumentsDirectory();
//       final logoFile = File('${documentDirectory.path}/logo.png');
//
//       await logoFile.writeAsBytes(response.bodyBytes);
//       cachedLogo = logoFile;
//       return logoFile;
//     } catch (e) {
//       throw Exception('Failed to download logo: $e');
//     }
//   }
//
//   Future<File> addStampToImage(File imageFile, ImageSource source) async {
//     final bytes = await imageFile.readAsBytes();
//     final image = img.decodeImage(bytes);
//
//     if (image == null) {
//       throw Exception('Failed to decode image');
//     }
//
//     // Add logo
//     try {
//       final logoFile = await getLogoFile();
//       final logoBytes = await logoFile.readAsBytes();
//       final logoImage = img.decodeImage(logoBytes);
//
//       if (logoImage != null) {
//         // Resize logo to be proportional to the image size
//         final logoSize = image.width ~/ 6; // Logo width will be 1/6 of image width
//         final resizedLogo = img.copyResize(
//           logoImage,
//           width: logoSize,
//           height: (logoSize * logoImage.height ~/ logoImage.width),
//           interpolation: img.Interpolation.linear,
//         );
//
//         // Calculate position for bottom left with padding
//         final padding = 20;
//         final x = padding;
//         final y = image.height - resizedLogo.height - padding;
//
//         // Composite the logo onto the main image
//         img.compositeImage(
//           image,
//           resizedLogo,
//           dstX: x,
//           dstY: y,
//           blend: img.BlendMode.divide,
//         );
//       }
//     } catch (e) {
//       print('Error adding logo: $e');
//     }
//
//     final stampText = await getStampText(imageFile, source);
//
//     // Use a smaller font for gallery images, larger font for camera images
//     final font = source == ImageSource.gallery ? img.arial24 : img.arial48;
//
//     // Calculate text dimensions (approximate)
//     var textWidth = (source == ImageSource.gallery)
//         ? stampText.length * font.size ~/ 10
//         : stampText.length * font.size ~/ 3.5;
//
//     final textHeight = font.size;
//
//     // Calculate position (bottom right corner with padding)
//     var x = (source == ImageSource.gallery)
//         ? image.width - textWidth - 250
//         : image.width - textWidth - -300;
//     var y = (source == ImageSource.gallery)
//         ? image.height - textHeight - 10
//         : image.height - textHeight - 100;
//
//     // Draw the text twice to create a bold effect
//     img.drawString(
//       image,
//       font: font,
//       x: x - 1,
//       y: y - 1,
//       stampText,
//       color: img.ColorRgb8(0, 0, 0), // Black shadow for visibility
//     );
//
//     img.drawString(
//       image,
//       font: font,
//       x: x,
//       y: y,
//       stampText,
//       color: img.ColorRgb8(255, 255, 255), // White color for main text
//     );
//
//     final outputPath = imageFile.path.replaceFirst('.jpg', '_stamped.jpg');
//     final stampedFile = File(outputPath)
//       ..writeAsBytesSync(img.encodeJpg(image));
//
//     return stampedFile;
//   }
//
//   Future<String> getStampText(File imageFile, ImageSource source) async {
//     if (source == ImageSource.camera) {
//       final exifData = await readExifFromBytes(await imageFile.readAsBytes());
//       final dateTime =
//           exifData['EXIF DateTimeOriginal']?.printable ?? 'Unknown';
//
//       // Get current location
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//
//       // Perform reverse geocoding to get place name
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//       String place = placemarks.isNotEmpty
//           ? '${placemarks.first.locality}, ${placemarks.first.country}'
//           : 'Unknown Place';
//
//       // Return formatted text including place name and coordinates
//       return 'Date: $dateTime\nPlace: $place\nLocation: ${position.latitude}, ${position.longitude}';
//     } else {
//       return 'Uploaded from Gallery';
//     }
//   }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied.');
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
//
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
//       if (!mounted) return;
//       await precacheImage(MemoryImage(bytes), context);
//     } else {
//       File imageFile = File(image.path);
//       File stampedFile = await addStampToImage(imageFile, source);
//       path = stampedFile.path;
//       if (!mounted) return;
//       await precacheImage(FileImage(stampedFile), context);
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
//
//   void _chooseCameraOrGallery() async {
//     if (!kIsWeb &&
//         (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
//       _openPicker(ImageSource.gallery);
//       return;
//     }
//
//     if (!kIsWeb && Platform.isIOS) {
//       showCupertinoModalPopup(
//         context: context,
//         builder: (BuildContext context) => CupertinoTheme(
//           data: const CupertinoThemeData(),
//           child: CupertinoActionSheet(
//             actions: <CupertinoActionSheetAction>[
//               CupertinoActionSheetAction(
//                 onPressed: () => _openPicker(ImageSource.camera),
//                 child: const Wrap(
//                   spacing: 7,
//                   runAlignment: WrapAlignment.center,
//                   children: [
//                     Icon(CupertinoIcons.photo_camera),
//                     Text('Camera'),
//                   ],
//                 ),
//               ),
//               CupertinoActionSheetAction(
//                 onPressed: () => _openPicker(ImageSource.gallery),
//                 child: const Wrap(
//                   spacing: 7,
//                   runAlignment: WrapAlignment.center,
//                   children: [
//                     Icon(CupertinoIcons.photo),
//                     Text('Gallery'),
//                   ],
//                 ),
//               ),
//             ],
//             cancelButton: CupertinoActionSheetAction(
//               isDefaultAction: true,
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Cancel'),
//             ),
//           ),
//         ),
//       );
//     } else {
//       showModalBottomSheet(
//         context: context,
//         showDragHandle: true,
//         constraints: BoxConstraints(
//           minWidth: min(MediaQuery.of(context).size.width, 360),
//         ),
//         builder: (context) {
//           return Material(
//             color: Colors.transparent,
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
//                 child: Wrap(
//                   spacing: 45,
//                   runSpacing: 30,
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   runAlignment: WrapAlignment.center,
//                   alignment: WrapAlignment.spaceAround,
//                   children: [
//                     MaterialIconActionButton(
//                       primaryColor: const Color(0xFFEC407A),
//                       secondaryColor: const Color(0xFFD3396D),
//                       icon: Icons.photo_camera,
//                       text: 'Camera',
//                       onTap: () => _openPicker(ImageSource.camera),
//                     ),
//                     MaterialIconActionButton(
//                       primaryColor: const Color(0xFFBF59CF),
//                       secondaryColor: const Color(0xFFAC44CF),
//                       icon: Icons.image,
//                       text: 'Gallery',
//                       onTap: () => _openPicker(ImageSource.gallery),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: _chooseCameraOrGallery,
//       leading: const Icon(Icons.attachment_outlined),
//       title: const Text('Pick from Gallery or Camera'),
//       subtitle: !kIsWeb &&
//           (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
//           ? const Text('The camera is not supported on this platform.')
//           : null,
//       trailing: const Icon(Icons.chevron_right),
//     );
//   }
//
//   Widget _buildEditor({String? path, Uint8List? bytes}) {
//     if (path != null) {
//       return ProImageEditor.file(
//         File(path),
//         callbacks: ProImageEditorCallbacks(
//           onImageEditingStarted: onImageEditingStarted,
//           onImageEditingComplete: onImageEditingComplete,
//           onCloseEditor: onCloseEditor,
//         ),
//         configs: ProImageEditorConfigs(
//           designMode: platformDesignMode,
//         ),
//       );
//     } else {
//       return ProImageEditor.memory(
//         bytes!,
//         callbacks: ProImageEditorCallbacks(
//           onImageEditingStarted: onImageEditingStarted,
//           onImageEditingComplete: onImageEditingComplete,
//           onCloseEditor: onCloseEditor,
//         ),
//         configs: ProImageEditorConfigs(
//           designMode: platformDesignMode,
//         ),
//       );
//     }
//   }
// }
//
// class MaterialIconActionButton extends StatelessWidget {
//   const MaterialIconActionButton({
//     super.key,
//     required this.primaryColor,
//     required this.secondaryColor,
//     required this.icon,
//     required this.text,
//     required this.onTap,
//   });
//
//   final Color primaryColor;
//   final Color secondaryColor;
//   final IconData icon;
//   final String text;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 65,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           InkWell(
//             borderRadius: BorderRadius.circular(60),
//             onTap: onTap,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: primaryColor,
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                 ),
//                 CustomPaint(
//                   painter: CircleHalf(secondaryColor),
//                   size: const Size(60, 60),
//                 ),
//                 Icon(icon, color: Colors.white),
//               ],
//             ),
//           ),
//           const SizedBox(height: 7),
//           Text(
//             text,
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 20),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CircleHalf extends CustomPainter {
//   CircleHalf(this.color);
//
//   final Color color;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = color;
//     canvas.drawArc(
//       Rect.fromCenter(
//         center: Offset(size.height / 2, size.width / 2),
//         height: size.height,
//         width: size.width,
//       ),
//       pi,
//       pi,
//       false,
//       paint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
    }
  }

  void _chooseCameraOrGallery() async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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

