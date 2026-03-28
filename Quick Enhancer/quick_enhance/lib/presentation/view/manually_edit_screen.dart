import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/manual_edit_view_model.dart';
import 'dart:typed_data';

class ManualEditPage extends ConsumerStatefulWidget {
  const ManualEditPage({super.key});

  @override
  ConsumerState<ManualEditPage> createState() => _ManualEditPageState();
}

class _ManualEditPageState extends ConsumerState<ManualEditPage> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifier();
    });
  }

  void _initializeNotifier() {
    if (!_isInitialized) {
      try {
        final notifier = ref.read(manualEditProvider.notifier);
        notifier.initFromImageState();
        _isInitialized = true;
      } catch (e) {
        print('Failed to initialize manual edit: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final manualState = ref.watch(manualEditProvider);
    final notifier = ref.read(manualEditProvider.notifier);

    // Show loading if temp image not yet initialized
    Uint8List? tempImageBytes;
    try {
      tempImageBytes = notifier.tempImageBytes;
    } catch (_) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 16),
              Text(
                'Loading editor...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manual Edit',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
              ],
            ),
          ),
        ),
        actions: [
          // Reset temp image
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                notifier.resetTempImage();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All adjustments reset'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              tooltip: 'Reset all adjustments',
            ),
          ),
          // Apply temp image to enhancedBytes
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                notifier.applyEdits();
                Navigator.pop(context);
              },
              tooltip: 'Apply changes',
            ),
          ),
          // Cancel -> just pop
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'Cancel',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ---------------- IMAGE PREVIEW ----------------
          Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade900,
                    Colors.black,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.memory(
                      tempImageBytes,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                    ),
                  ),
                  // Info overlay
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tune,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Adjust sliders below',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------- EDITOR PANEL ----------------
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Adjust Parameters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Live Preview',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Sliders
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _slider(
                            label: 'Brightness',
                            value: manualState.params.brightness,
                            icon: Icons.brightness_6,
                            color: Colors.amber,
                            min: -1,
                            max: 1,
                            onDrag: (v) => notifier.onSliderDrag(
                              manualState.params.copyWith(brightness: v),
                            ),
                            onEnd: (v) => notifier.onSliderEnd(
                              manualState.params.copyWith(brightness: v),
                            ),
                          ),
                          _slider(
                            label: 'Contrast',
                            value: manualState.params.contrast,
                            icon: Icons.contrast,
                            color: Colors.blue,
                            min: -1,
                            max: 1,
                            onDrag: (v) => notifier.onSliderDrag(
                              manualState.params.copyWith(contrast: v),
                            ),
                            onEnd: (v) => notifier.onSliderEnd(
                              manualState.params.copyWith(contrast: v),
                            ),
                          ),
                          _slider(
                            label: 'Saturation',
                            value: manualState.params.saturation,
                            icon: Icons.invert_colors,
                            color: Colors.purple,
                            min: -1,
                            max: 1,
                            onDrag: (v) => notifier.onSliderDrag(
                              manualState.params.copyWith(saturation: v),
                            ),
                            onEnd: (v) => notifier.onSliderEnd(
                              manualState.params.copyWith(saturation: v),
                            ),
                          ),
                          _slider(
                            label: 'Highlights',
                            value: manualState.params.highlights,
                            icon: Icons.wb_sunny,
                            color: Colors.orange,
                            min: -1,
                            max: 1,
                            onDrag: (v) => notifier.onSliderDrag(
                              manualState.params.copyWith(highlights: v),
                            ),
                            onEnd: (v) => notifier.onSliderEnd(
                              manualState.params.copyWith(highlights: v),
                            ),
                          ),
                          _slider(
                            label: 'Shadows',
                            value: manualState.params.shadows,
                            icon: Icons.cloud,
                            color: Colors.indigo,
                            min: -1,
                            max: 1,
                            onDrag: (v) => notifier.onSliderDrag(
                              manualState.params.copyWith(shadows: v),
                            ),
                            onEnd: (v) => notifier.onSliderEnd(
                              manualState.params.copyWith(shadows: v),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _slider({
    required String label,
    required IconData icon,
    required double value,
    required Color color,
    required double min,
    required double max,
    required ValueChanged<double> onDrag,
    required ValueChanged<double> onEnd,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: 200,
              onChanged: onDrag,
              onChangeEnd: onEnd,
            ),
          ),
          // Value indicator line
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  min.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  '0',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  max.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}