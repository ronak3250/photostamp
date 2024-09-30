// Flutter imports:
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../utils/example_helper.dart';

class GenerationConfigsExample extends StatefulWidget {
  const GenerationConfigsExample({super.key});

  @override
  State<GenerationConfigsExample> createState() =>
      _GenerationConfigsExampleState();
}

class _GenerationConfigsExampleState extends State<GenerationConfigsExample> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GenerationConfig(),
          ),
        );
      },
      leading: const Icon(Icons.memory_outlined),
      title: const Text('Generation Configurations'),
      subtitle:
          const Text('Adjust output format, set processor usage, and more'),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class GenerationConfig extends StatefulWidget {
  const GenerationConfig({super.key});

  @override
  State<GenerationConfig> createState() => _GenerationConfigState();
}

class _GenerationConfigState extends State<GenerationConfig>
    with ExampleHelperState<GenerationConfig> {
  bool _generateThumbnail = false;
  bool _generateOnlyDrawingBounds = true;
  bool _generateImageInBackground = true;
  bool _generateInsideSeparateThread = true;
  bool _singleFrame = true;

  int _customPixelRatio = 0;
  int _numberOfBackgroundProcessors = 2;
  int _maxConcurrency = 1;
  int _pngLevel = 6;
  int _jpegQuality = 100;

  TextItem<ProcessorMode> _processorMode = const TextItem<ProcessorMode>(
    text: 'Auto',
    value: ProcessorMode.auto,
  );
  TextItem<OutputFormat> _outputFormat = const TextItem<OutputFormat>(
    text: 'jpg',
    value: OutputFormat.jpg,
  );
  TextItem<PngFilter> _pngFilter = const TextItem<PngFilter>(
    text: 'none',
    value: PngFilter.none,
  );
  TextItem<JpegChroma> _jpegChroma = const TextItem<JpegChroma>(
    text: 'yuv444',
    value: JpegChroma.yuv444,
  );
  TextItem<Size> _maxOutputSize = const TextItem<Size>(
    text: '2000x2000',
    value: Size(2000, 2000),
  );
  TextItem<Size> _maxThumbSize = const TextItem<Size>(
    text: '100x100',
    value: Size(100, 100),
  );

  ui.Image? _rawOriginalImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generation Configurations'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          ..._buildGenerationConfigs(),
          ..._buildSizeConfigs(),
          ..._buildProcessorConfigs(),
          ..._buildPngConfigs(),
          ..._buildJpegConfigs(),
          ..._buildVariousConfigs(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _rawOriginalImage = null;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _buildEditor(),
            ),
          );
        },
        icon: const Icon(Icons.open_in_browser_outlined),
        label: const Text('Open Editor'),
      ),
    );
  }

  Widget _buildGroupHeader(String title) {
    return ListTile(
      tileColor: const Color.fromARGB(255, 201, 201, 201),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }

  List<Widget> _buildGenerationConfigs() {
    return [
      TextPickerListTile<OutputFormat>(
        title: 'Output format',
        subtitle: 'Specifies the output format for the generated image.',
        selected: _outputFormat,
        textOptions: const [
          TextItem<OutputFormat>(
            text: 'jpg',
            value: OutputFormat.jpg,
          ),
          TextItem<OutputFormat>(
            text: 'png',
            value: OutputFormat.png,
          ),
          TextItem<OutputFormat>(
            text: 'bmp',
            value: OutputFormat.bmp,
          ),
          TextItem<OutputFormat>(
            text: 'tiff',
            value: OutputFormat.tiff,
          ),
          TextItem<OutputFormat>(
            text: 'cur',
            value: OutputFormat.cur,
          ),
          TextItem<OutputFormat>(
            text: 'ico',
            value: OutputFormat.ico,
          ),
          TextItem<OutputFormat>(
            text: 'pvr',
            value: OutputFormat.pvr,
          ),
          TextItem<OutputFormat>(
            text: 'tga',
            value: OutputFormat.tga,
          ),
        ],
        onUpdate: (val) => _outputFormat = val,
      ),
      SwitchListTile.adaptive(
        title: const Text('Generate thumbnail'),
        subtitle: const Text(
            'This option is useful if you have a high-resolution image that typically takes a long time to generate, but you need to display it quickly.'),
        value: _generateThumbnail,
        onChanged: (value) => setState(() => _generateThumbnail = value),
      ),
      SwitchListTile.adaptive(
        title: const Text('Generate image in background'),
        subtitle: const Text(
            'Captures the final image after each change, such as adding a layer. This significantly speeds up the editor because in most cases, the image is already created when the user presses "done".'),
        value: _generateImageInBackground,
        onChanged: (value) =>
            setState(() => _generateImageInBackground = value),
      ),
      SwitchListTile.adaptive(
        title: const Text('Generate in a separate thread'),
        subtitle: const Text(
            'Allows image generation to run in an separate thread, preventing any impact on the UI.'),
        value: _generateInsideSeparateThread,
        onChanged: (value) =>
            setState(() => _generateInsideSeparateThread = value),
      ),
    ];
  }

  List<Widget> _buildProcessorConfigs() {
    return [
      _buildGroupHeader('Processor'),
      TextPickerListTile<ProcessorMode>(
        title: 'Processor mode',
        subtitle: 'The mode in which processors will operate.',
        selected: _processorMode,
        textOptions: const [
          TextItem<ProcessorMode>(
            text: 'Auto',
            value: ProcessorMode.auto,
          ),
          TextItem<ProcessorMode>(
            text: 'Limit',
            value: ProcessorMode.limit,
          ),
          TextItem<ProcessorMode>(
            text: 'Maximum (All processors)',
            value: ProcessorMode.maximum,
          ),
          TextItem<ProcessorMode>(
            text: 'Minimum (One processor)',
            value: ProcessorMode.minimum,
          ),
        ],
        onUpdate: (val) => _processorMode = val,
      ),
      NumberPickerListTile(
        minValue: 1,
        maxValue: 16,
        title: 'Background processors',
        subtitle:
            'The number of background processors to use. This option only has an effect when the processor mode is "limit".',
        initialValue: _numberOfBackgroundProcessors,
        onUpdate: (val) => _numberOfBackgroundProcessors = val,
      ),
      NumberPickerListTile(
        minValue: 1,
        maxValue: 7,
        title: 'Task concurrency',
        subtitle:
            'The maximum concurrency level. This option only has an effect when the processor mode is "limit" or "auto".',
        initialValue: _maxConcurrency,
        onUpdate: (val) => _maxConcurrency = val,
      ),
    ];
  }

  List<Widget> _buildSizeConfigs() {
    return [
      _buildGroupHeader('Size limits'),
      TextPickerListTile<Size>(
        title: 'Maximum output size',
        subtitle:
            'The maximum output size for the image. It will maintain the image\'s aspect ratio but will fit within the specified constraints, similar to BoxFit.contain.',
        selected: _maxOutputSize,
        textOptions: const [
          TextItem<Size>(
            text: '100x100',
            value: Size(100, 100),
          ),
          TextItem<Size>(
            text: '500x500',
            value: Size(500, 500),
          ),
          TextItem<Size>(
            text: '500x700',
            value: Size(500, 700),
          ),
          TextItem<Size>(
            text: '1000x1000',
            value: Size(1000, 1000),
          ),
          TextItem<Size>(
            text: '2000x2000',
            value: Size(2000, 2000),
          ),
          TextItem<Size>(
            text: '5000x5000',
            value: Size(5000, 5000),
          ),
          TextItem<Size>(
            text: 'infinite',
            value: Size.infinite,
          ),
        ],
        onUpdate: (val) => _maxOutputSize = val,
      ),
      TextPickerListTile<Size>(
        title: 'Maximum thumbnail size',
        subtitle:
            'The maximum output size for the thumbnail image. It will maintain the image\'s aspect ratio but will fit within the specified constraints, similar to BoxFit.contain.',
        selected: _maxThumbSize,
        textOptions: const [
          TextItem<Size>(
            text: '50x50',
            value: Size(50, 50),
          ),
          TextItem<Size>(
            text: '50x70',
            value: Size(50, 70),
          ),
          TextItem<Size>(
            text: '80x80',
            value: Size(80, 80),
          ),
          TextItem<Size>(
            text: '100x100',
            value: Size(100, 100),
          ),
          TextItem<Size>(
            text: '200x200',
            value: Size(200, 200),
          ),
          TextItem<Size>(
            text: '500x500',
            value: Size(500, 500),
          ),
        ],
        onUpdate: (val) => _maxThumbSize = val,
      ),
    ];
  }

  List<Widget> _buildPngConfigs() {
    return [
      _buildGroupHeader('PNG'),
      TextPickerListTile<PngFilter>(
        title: 'PNG-Filter',
        subtitle:
            'Specifies the filter method for optimizing PNG compression. It determines how scanline filtering is applied.',
        selected: _pngFilter,
        textOptions: const [
          TextItem<PngFilter>(
            text: 'none',
            value: PngFilter.none,
          ),
          TextItem<PngFilter>(
            text: 'sub',
            value: PngFilter.sub,
          ),
          TextItem<PngFilter>(
            text: 'up',
            value: PngFilter.up,
          ),
          TextItem<PngFilter>(
            text: 'average',
            value: PngFilter.average,
          ),
          TextItem<PngFilter>(
            text: 'paeth',
            value: PngFilter.paeth,
          ),
        ],
        onUpdate: (val) => _pngFilter = val,
      ),
      NumberPickerListTile(
        minValue: 0,
        maxValue: 9,
        title: 'PNG-Level',
        subtitle:
            'Specifies the compression level for PNG images. It ranges from 0 to 9, where 0 indicates no compression and 9 indicates maximum compression.',
        initialValue: _pngLevel,
        onUpdate: (val) => _pngLevel = val,
      ),
      SwitchListTile.adaptive(
        title: const Text('Single frame generation'),
        subtitle: const Text(
            'Specifies whether single frame generation is enabled for the output formats PNG, TIFF, CUR, PVR, and ICO.'),
        value: _singleFrame,
        onChanged: (value) => setState(() => _singleFrame = value),
      ),
    ];
  }

  List<Widget> _buildJpegConfigs() {
    return [
      _buildGroupHeader('JPEG'),
      NumberPickerListTile(
        minValue: 1,
        maxValue: 100,
        title: 'JPEG-Quality',
        subtitle:
            'Specifies the quality level for JPEG images. It ranges from 1 to 100, where 1 indicates the lowest quality and 100 indicates the highest quality.',
        initialValue: _jpegQuality,
        onUpdate: (val) => _jpegQuality = val,
      ),
      TextPickerListTile<JpegChroma>(
        title: 'JPEG Chroma (sub)sampling format.',
        subtitle:
            'Specifies the chroma subsampling method for JPEG images. It defines the compression ratio for chrominance components.',
        selected: _jpegChroma,
        textOptions: const [
          TextItem<JpegChroma>(
            text: 'yuv444',
            value: JpegChroma.yuv444,
          ),
          TextItem<JpegChroma>(
            text: 'yuv420',
            value: JpegChroma.yuv420,
          ),
        ],
        onUpdate: (val) => _jpegChroma = val,
      ),
    ];
  }

  List<Widget> _buildVariousConfigs() {
    return [
      _buildGroupHeader('Various'),
      SwitchListTile.adaptive(
        title: const Text('Capture only drawing areas'),
        subtitle: const Text(
            'Determines whether to capture only the content within the boundaries of the image when editing is complete.'),
        value: _generateOnlyDrawingBounds,
        onChanged: (value) =>
            setState(() => _generateOnlyDrawingBounds = value),
      ),
      NumberPickerListTile(
        minValue: 0,
        maxValue: 20,
        title: 'Custom pixel ratio',
        subtitle:
            'The pixel ratio of the image relative to the content. If "0", the editor will select automatically.',
        initialValue: _customPixelRatio,
        onUpdate: (val) => _customPixelRatio = val,
      ),
    ];
  }

  Widget _buildEditor() {
    Size outputSize = _maxOutputSize.value;
    OutputFormat outputFormat = _outputFormat.value;

    if (outputFormat == OutputFormat.ico || outputFormat == OutputFormat.cur) {
      outputSize = const Size(256, 256);
      debugPrint('Format ICO and CUR support only sizes until 256!');
    } else if (outputFormat == OutputFormat.pvr ||
        outputFormat == OutputFormat.tga) {
      debugPrint('Format PVR and TGA cannot be displayed in Flutter');
      outputFormat = OutputFormat.jpg;
    }

    var generationConfigs = ImageGenerationConfigs(
      captureOnlyDrawingBounds: _generateOnlyDrawingBounds,
      generateImageInBackground: _generateImageInBackground,
      generateInsideSeparateThread: _generateInsideSeparateThread,
      singleFrame: _singleFrame,
      customPixelRatio:
          _customPixelRatio == 0 ? null : _customPixelRatio.toDouble(),
      processorConfigs: ProcessorConfigs(
        numberOfBackgroundProcessors: _numberOfBackgroundProcessors,
        maxConcurrency: _maxConcurrency,
        processorMode: _processorMode.value,
      ),
      outputFormat: outputFormat,
      maxOutputSize: outputSize,
      maxThumbnailSize:
          _maxThumbSize.value > outputSize ? outputSize : _maxThumbSize.value,
      pngFilter: _pngFilter.value,
      pngLevel: _pngLevel,
      jpegQuality: _jpegQuality,
      jpegChroma: _jpegChroma.value,
    );
    return ProImageEditor.network(
      'https://picsum.photos/id/110/${_generateThumbnail ? '5000' : '2000'}',
      callbacks: ProImageEditorCallbacks(
        onImageEditingStarted: onImageEditingStarted,
        onImageEditingComplete: onImageEditingComplete,
        onCloseEditor: () => onCloseEditor(
          showThumbnail: _generateThumbnail,
          rawOriginalImage: _rawOriginalImage,
          generationConfigs: generationConfigs,
        ),
        onThumbnailGenerated: _generateThumbnail
            ? (thumbnailBytes, rawImage) async {
                editedBytes = thumbnailBytes;
                _rawOriginalImage = rawImage;
                setGenerationTime();

                /// The example for the generation part of the final image can
                /// you checkout in the file `preview_img.dart`.
                ///
                /// In short you can call then in the background the method
                /// `generateHighQualityImage(rawImage)`.
              }
            : null,
      ),
      configs: ProImageEditorConfigs(
        designMode: platformDesignMode,
        imageGenerationConfigs: generationConfigs,
      ),
    );
  }
}

class NumberPickerListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final Function(int) onUpdate;

  const NumberPickerListTile({
    super.key,
    this.initialValue = 0,
    required this.title,
    required this.subtitle,
    required this.minValue,
    required this.maxValue,
    required this.onUpdate,
  });

  @override
  State<NumberPickerListTile> createState() => _NumberPickerListTileState();
}

class _NumberPickerListTileState extends State<NumberPickerListTile> {
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  void _showNumberPicker(BuildContext context) {
    int tempValue = _selectedValue;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoButton(
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: CupertinoColors.activeBlue),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedValue = tempValue;
                        widget.onUpdate.call(tempValue);
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: tempValue - widget.minValue,
                  ),
                  onSelectedItemChanged: (int value) {
                    setState(() {
                      tempValue = value + widget.minValue;
                    });
                  },
                  children: List<Widget>.generate(
                    widget.maxValue - widget.minValue + 1,
                    (int index) {
                      return Center(
                        child: Text((widget.minValue + index).toString()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      trailing: Chip(
        label: Text(_selectedValue.toString()),
      ),
      onTap: () => _showNumberPicker(context),
    );
  }
}

class TextPickerListTile<T> extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<TextItem<T>> textOptions;
  final TextItem<T> selected;
  final Function(TextItem<T>) onUpdate;

  const TextPickerListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.textOptions,
    required this.selected,
    required this.onUpdate,
  });

  @override
  State<TextPickerListTile<T>> createState() => _TextPickerListTileState<T>();
}

class _TextPickerListTileState<T> extends State<TextPickerListTile<T>> {
  late TextItem<T> _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selected;
  }

  void _showPicker(BuildContext context) {
    TextItem<T> tempValue = _selectedItem;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoButton(
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: CupertinoColors.activeBlue),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedItem = tempValue;
                        widget.onUpdate.call(tempValue);
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: widget.textOptions
                        .indexWhere((el) => el == _selectedItem),
                  ),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      tempValue = widget.textOptions[index];
                    });
                  },
                  children: List<Widget>.generate(
                    widget.textOptions.length,
                    (int index) {
                      return Center(
                        child: Text(widget.textOptions[index].text),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      onTap: () => _showPicker(context),
      trailing: Chip(
        label: Text(_selectedItem.text),
      ),
    );
  }
}

class TextItem<T> {
  final T value;
  final String text;
  const TextItem({
    required this.value,
    required this.text,
  });
}
