// // import 'package:flutter/gestures.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:pro_image_editor/widgets/extended/extended_pop_scope.dart';
// // import 'package:proeditors/pages/pick_image_example.dart';
// // import 'package:proeditors/utils/example_constants.dart';
// // import 'package:url_launcher/url_launcher.dart';
// //
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //
// //
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Pro-Image-Editor',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
// //         useMaterial3: true,
// //       ),
// //       debugShowCheckedModeBanner: false,
// //       home: const MyHomePage(),
// //     );
// //   }
// // }
// //
// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({super.key});
// //
// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends State<MyHomePage> {
// //   late final ScrollController _scrollCtrl;
// //
// //   final List<Widget> _examples = [
// //     // const DefaultExample(),
// //     // const DesignExample(),
// //     // const StandaloneExample(),
// //     // const CropToMainEditorExample(),
// //     // const SignatureDrawingExample(),
// //     // const StickersExample(),
// //     // const FirebaseSupabaseExample(),
// //     // const ReorderLayerExample(),
// //     // const RoundCropperExample(),
// //     // const SelectableLayerExample(),
// //     // const GenerationConfigsExample(),
// //     const PickImageExample(),
// //     // const GoogleFontExample(),
// //     // const CustomAppbarBottombarExample(),
// //     // const ImportExportExample(),
// //     // const MoveableBackgroundImageExample(),
// //     // const ZoomMoveEditorExample(),
// //     // const ImageFormatConvertExample(),
// //   ];
// //
// //   @override
// //   void initState() {
// //     _scrollCtrl = ScrollController();
// //     super.initState();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _scrollCtrl.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ExampleConstants(
// //       child: AnnotatedRegion<SystemUiOverlayStyle>(
// //         value: SystemUiOverlayStyle.dark,
// //         child: ExtendedPopScope(
// //           child: Scaffold(
// //             body: SafeArea(child: _buildCard()),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCard() {
// //     return Center(
// //       child: LayoutBuilder(builder: (context, constraints) {
// //         if (constraints.maxWidth >= 750) {
// //           return Container(
// //             constraints: const BoxConstraints(maxWidth: 700),
// //             child: Card.outlined(
// //               margin: const EdgeInsets.all(16),
// //               clipBehavior: Clip.hardEdge,
// //               child: _buildExamples(),
// //             ),
// //           );
// //         } else {
// //           return _buildExamples();
// //         }
// //       }),
// //     );
// //   }
// //
// //   Widget _buildExamples() {
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //
// //
// //         const Divider(height: 1),
// //         Flexible(
// //           child: Scrollbar(
// //             controller: _scrollCtrl,
// //             thumbVisibility: true,
// //             trackVisibility: true,
// //             child: SingleChildScrollView(
// //               controller: _scrollCtrl,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: ListTile.divideTiles(
// //                   context: context,
// //                   tiles: _examples,
// //                 ).toList(),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pro_image_editor/widgets/extended/extended_pop_scope.dart';
// import 'package:proeditors/pages/pick_image_example.dart';
// import 'package:proeditors/utils/example_constants.dart';
// import 'package:geolocator/geolocator.dart'; // Import geolocator
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pro-Image-Editor',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late final ScrollController _scrollCtrl;
//   String _locationMessage = "Requesting location permission...";
//
//   final List<Widget> _examples = [
//     const PickImageExample(),
//   ];
//
//   @override
//   void initState() {
//     _scrollCtrl = ScrollController();
//     super.initState();
//     _initLocationService(); // Request location on startup
//   }
//
//   @override
//   void dispose() {
//     _scrollCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initLocationService() async {
//     try {
//       Position position = await _determinePosition();
//       setState(() {
//         _locationMessage = 'Position: ${position.latitude}, ${position.longitude}';
//       });
//     } catch (e) {
//       setState(() {
//         _locationMessage = 'Error: $e';
//       });
//     }
//   }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
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
//   @override
//   Widget build(BuildContext context) {
//     return ExampleConstants(
//       child: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.dark,
//         child: ExtendedPopScope(
//           child: Scaffold(
//             body: SafeArea(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(_locationMessage), // Display location or error message
//                   _buildCard(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard() {
//     return Center(
//       child: LayoutBuilder(builder: (context, constraints) {
//         if (constraints.maxWidth >= 750) {
//           return Container(
//             constraints: const BoxConstraints(maxWidth: 700),
//             child: Card.outlined(
//               margin: const EdgeInsets.all(16),
//               clipBehavior: Clip.hardEdge,
//               child: _buildExamples(),
//             ),
//           );
//         } else {
//           return _buildExamples();
//         }
//       }),
//     );
//   }
//
//   Widget _buildExamples() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Divider(height: 1),
//         Flexible(
//           child: Scrollbar(
//             controller: _scrollCtrl,
//             thumbVisibility: true,
//             trackVisibility: true,
//             child: SingleChildScrollView(
//               controller: _scrollCtrl,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: ListTile.divideTiles(
//                   context: context,
//                   tiles: _examples,
//                 ).toList(),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator for location services
import 'package:pro_image_editor/widgets/extended/extended_pop_scope.dart';
import 'package:proeditors/pages/pick_image_example.dart';
import 'package:proeditors/utils/example_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pro-Image-Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ScrollController _scrollCtrl;
  String _locationMessage = "Requesting location permission...";

  final List<Widget> _examples = [
    const PickImageExample(),
  ];

  @override
  void initState() {
    _scrollCtrl = ScrollController();
    super.initState();
    _requestLocationPermission(); // Request location permission when app starts
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  // Request location permission and handle location services
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // Permission granted, now check if location services are enabled
      _checkLocationServices();
    } else {
      // Permission denied
      setState(() {
        _locationMessage = 'Location permissions are denied.';
      });
    }
  }

  // Check if location services are enabled and prompt the user if necessary
  Future<void> _checkLocationServices() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, prompt the user to enable them
      _showEnableLocationDialog();
    } else {
      // Location services are enabled, get the location
      _getCurrentLocation();
    }
  }

  // Get the current location if permission is granted and services are enabled
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _locationMessage = 'Position: ${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        _locationMessage = 'Error: $e';
      });
    }
  }

  // Show a dialog to the user asking to enable location services
  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Location Services'),
        content: const Text('Please enable location services to continue.'),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings(); // Open location settings for the user to enable location services
              Navigator.of(context).pop();
              _checkLocationServices(); // Recheck location services after the user returns
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExampleConstants(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: ExtendedPopScope(
          child: Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_locationMessage), // Display location or error message
                  _buildCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 750) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Card.outlined(
              margin: const EdgeInsets.all(16),
              clipBehavior: Clip.hardEdge,
              child: _buildExamples(),
            ),
          );
        } else {
          return _buildExamples();
        }
      }),
    );
  }

  Widget _buildExamples() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        Flexible(
          child: Scrollbar(
            controller: _scrollCtrl,
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: ListTile.divideTiles(
                  context: context,
                  tiles: _examples,
                ).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
