import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:pro_image_editor/widgets/extended/extended_pop_scope.dart';
import 'package:proeditors/pages/pick_image_example.dart';
import 'package:proeditors/utils/example_constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Stamper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
          secondary: const Color(0xFFFF9800),
          tertiary: const Color(0xFF03DAC6),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6200EE),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollCtrl;
  String _locationMessage = "Requesting location permission...";
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;



  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _requestLocationPermission();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _checkLocationServices();
    } else {
      setState(() {
        _locationMessage = 'Location permissions are denied.';
        _isLoading = false;
      });
    }
    _animationController.forward();
  }

  Future<void> _checkLocationServices() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showEnableLocationDialog();
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _locationMessage =
            'Lat: ${position.latitude.toStringAsFixed(4)}, Long: ${position.longitude.toStringAsFixed(4)}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _locationMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Location Services'),
        content: const Text('Please enable location services to continue.'),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
              Navigator.of(context).pop();
              _checkLocationServices();
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
        value: SystemUiOverlayStyle.light,
        child: ExtendedPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Image Stamper',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              actions: [
                // IconButton(
                //   icon: const Icon(Icons.info_outline),
                //   onPressed: () {
                //     // TODO: Implement info action
                //   },
                // ),
              ],
            ),
            body: _isLoading ? _buildLoadingIndicator() : PickImageExample(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets5.lottiefiles.com/packages/lf20_usmfx6bp.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 16),
          Text(
            'Getting things ready...',
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.titleMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }





}
