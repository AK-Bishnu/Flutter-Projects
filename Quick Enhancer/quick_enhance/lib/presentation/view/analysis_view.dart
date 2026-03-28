import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/image_view_model.dart';
import '../../../domain/enums/param_status.dart';

class AnalysisView extends ConsumerWidget {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageViewModelProvider);

    if (state.isAnalyzing) {
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
                'Analyzing your image...',
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

    final result = state.showEnhanced
        ? state.enhancedAnalysis
        : state.originalAnalysis;
    if (result == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No analysis result yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please run analysis from home screen',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
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
          'Image Analysis',
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Status Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: result.analysis.isPerfect
                          ? [Colors.green.shade50, Colors.green.shade100]
                          : [Colors.orange.shade50, Colors.orange.shade100],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        result.analysis.isPerfect
                            ? Icons.check_circle
                            : Icons.tune,
                        size: 48,
                        color: result.analysis.isPerfect
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        result.analysis.isPerfect ? 'PERFECT!' : 'NEEDS IMPROVEMENT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: result.analysis.isPerfect
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.analysis.isPerfect
                            ? 'Your image parameters are optimally balanced'
                            : 'Adjust parameters for better image quality',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: result.analysis.isPerfect
                              ? Colors.green.shade600
                              : Colors.orange.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Analysis Parameters Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.analytics,
                              color: Theme.of(context).primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Parameter Analysis',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                state.showEnhanced ? 'ENHANCED' : 'ORIGINAL',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Parameters List
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildParameterCard(
                              name: 'Brightness',
                              value: result.analysis.brightness.value,
                              status: result.analysis.brightness.status,
                              icon: Icons.brightness_6,
                              color: Colors.amber,
                            ),
                            const SizedBox(height: 12),
                            _buildParameterCard(
                              name: 'Contrast',
                              value: result.analysis.contrast.value,
                              status: result.analysis.contrast.status,
                              icon: Icons.contrast,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 12),
                            _buildParameterCard(
                              name: 'Saturation',
                              value: result.analysis.saturation.value,
                              status: result.analysis.saturation.status,
                              icon: Icons.invert_colors,
                              color: Colors.purple,
                            ),
                            const SizedBox(height: 12),
                            _buildParameterCard(
                              name: 'Highlights',
                              value: result.analysis.highlights.value,
                              status: result.analysis.highlights.status,
                              icon: Icons.wb_sunny,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 12),
                            _buildParameterCard(
                              name: 'Shadows',
                              value: result.analysis.shadows.value,
                              status: result.analysis.shadows.status,
                              icon: Icons.cloud,
                              color: Colors.indigo,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Recommendation Note
                if (!result.analysis.isPerfect)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tip: Use "Auto Enhance" or "Manual Edit" to improve these parameters',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParameterCard({
    required String name,
    required double value,
    required ParamStatus status,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusLabel(status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Value',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value.toStringAsFixed(3),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildStatusIndicator(status),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(ParamStatus status) {
    String rangeText = '';
    Color rangeColor = Colors.grey;

    switch (status) {
      case ParamStatus.extremeLow:
        rangeText = '0-0.2';
        rangeColor = Colors.red;
        break;
      case ParamStatus.veryLow:
        rangeText = '0.2-0.4';
        rangeColor = Colors.red.shade300;
        break;
      case ParamStatus.low:
        rangeText = '0.4-0.6';
        rangeColor = Colors.orange;
        break;
      case ParamStatus.slightlyLow:
        rangeText = '0.6-0.8';
        rangeColor = Colors.orange.shade300;
        break;
      case ParamStatus.perfect:
        rangeText = '0.8-1.2';
        rangeColor = Colors.green;
        break;
      case ParamStatus.slightlyHigh:
        rangeText = '1.2-1.4';
        rangeColor = Colors.orange.shade300;
        break;
      case ParamStatus.high:
        rangeText = '1.4-1.6';
        rangeColor = Colors.orange;
        break;
      case ParamStatus.veryHigh:
        rangeText = '1.6-1.8';
        rangeColor = Colors.red.shade300;
        break;
      case ParamStatus.extremeHigh:
        rangeText = '1.8-2.0';
        rangeColor = Colors.red;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Ideal Range',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: rangeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            rangeText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: rangeColor,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ParamStatus status) {
    switch (status) {
      case ParamStatus.extremeLow:
        return Colors.red;
      case ParamStatus.veryLow:
        return Colors.red.shade300;
      case ParamStatus.low:
        return Colors.orange;
      case ParamStatus.slightlyLow:
        return Colors.orange.shade300;
      case ParamStatus.perfect:
        return Colors.green;
      case ParamStatus.slightlyHigh:
        return Colors.orange.shade300;
      case ParamStatus.high:
        return Colors.orange;
      case ParamStatus.veryHigh:
        return Colors.red.shade300;
      case ParamStatus.extremeHigh:
        return Colors.red;
    }
  }

  String _getStatusLabel(ParamStatus status) {
    switch (status) {
      case ParamStatus.extremeLow:
        return 'Extreme Low';
      case ParamStatus.veryLow:
        return 'Very Low';
      case ParamStatus.low:
        return 'Low';
      case ParamStatus.slightlyLow:
        return 'Slightly Low';
      case ParamStatus.perfect:
        return 'Perfect ✓';
      case ParamStatus.slightlyHigh:
        return 'Slightly High';
      case ParamStatus.high:
        return 'High';
      case ParamStatus.veryHigh:
        return 'Very High';
      case ParamStatus.extremeHigh:
        return 'Extreme High';
    }
  }
}