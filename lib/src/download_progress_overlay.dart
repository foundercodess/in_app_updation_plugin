import 'package:flutter/material.dart';

/// Lightweight overlay showing download progress. Uses SnackBar to avoid
/// heavy overlays that can crash on low-memory devices.
class DownloadProgressOverlay {
  static OverlayEntry? _entry;
  static ValueNotifier<double>? _progressNotifier;

  static void show(BuildContext context) {
    _progressNotifier = ValueNotifier<double>(0.0);
    _entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 16,
        right: 16,
        bottom: 80,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ValueListenableBuilder<double>(
              valueListenable: _progressNotifier!,
              builder: (_, progress, __) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Downloading update... ${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: progress > 0 ? progress : null),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_entry!);
  }

  static void updateProgress(double progress) {
    _progressNotifier?.value = progress;
  }

  static void dismiss(BuildContext context) {
    _entry?.remove();
    _entry = null;
    _progressNotifier?.dispose();
    _progressNotifier = null;
  }
}
