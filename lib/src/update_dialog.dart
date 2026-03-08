import 'package:flutter/material.dart';

import 'update_model.dart';

/// Shows update dialog by inserting directly into the root overlay.
/// Bypasses Navigator - ensures dialog displays regardless of call site.
void showUpdateDialogViaOverlay({
  required BuildContext context,
  required UpdateModel update,
  required VoidCallback onUpdate,
  VoidCallback? onLater,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;

  void dismiss() {
    entry.remove();
  }

  entry = OverlayEntry(
    builder: (ctx) => Stack(
      children: [
        Positioned.fill(
          child: ModalBarrier(
            dismissible: !update.forceUpdate,
            onDismiss: update.forceUpdate
                ? null
                : () {
                    dismiss();
                    onLater?.call();
                  },
          ),
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: AlertDialog(
              title: const Text('Update Available'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(update.message.isNotEmpty
                      ? update.message
                      : 'New version available'),
                  if (update.version.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Version ${update.version}',
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              actions: [
                if (!update.forceUpdate && onLater != null)
                  TextButton(
                    onPressed: () {
                      dismiss();
                      onLater();
                    },
                    child: const Text('Later'),
                  ),
                FilledButton(
                  onPressed: () {
                    dismiss();
                    onUpdate();
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  overlay.insert(entry);
}

/// Shows a dialog prompting the user to update the app.
/// Uses [showUpdateDialogViaOverlay] for reliable display.
void showUpdateDialog({
  required BuildContext context,
  required UpdateModel update,
  required VoidCallback onUpdate,
  VoidCallback? onLater,
}) {
  showUpdateDialogViaOverlay(
    context: context,
    update: update,
    onUpdate: onUpdate,
    onLater: onLater,
  );
}
