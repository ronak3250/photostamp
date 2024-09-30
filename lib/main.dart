import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_image_editor/widgets/extended/extended_pop_scope.dart';
import 'package:proeditors/pages/pick_image_example.dart';
import 'package:proeditors/utils/example_constants.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final List<Widget> _examples = [
    // const DefaultExample(),
    // const DesignExample(),
    // const StandaloneExample(),
    // const CropToMainEditorExample(),
    // const SignatureDrawingExample(),
    // const StickersExample(),
    // const FirebaseSupabaseExample(),
    // const ReorderLayerExample(),
    // const RoundCropperExample(),
    // const SelectableLayerExample(),
    // const GenerationConfigsExample(),
    const PickImageExample(),
    // const GoogleFontExample(),
    // const CustomAppbarBottombarExample(),
    // const ImportExportExample(),
    // const MoveableBackgroundImageExample(),
    // const ZoomMoveEditorExample(),
    // const ImageFormatConvertExample(),
  ];

  @override
  void initState() {
    _scrollCtrl = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleConstants(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: ExtendedPopScope(
          child: Scaffold(
            body: SafeArea(child: _buildCard()),
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