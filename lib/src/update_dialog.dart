import 'package:flutter/material.dart';

import 'update_model.dart';

/// Shows a dialog prompting the user to update the app.
///
/// [onUpdate] is called when the user taps "Update".
/// [onLater] is called when the user taps "Later" (only shown if not force update).
void showUpdateDialog({
  required BuildContext context,
  required UpdateModel update,
  required VoidCallback onUpdate,
  VoidCallback? onLater,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: !update.forceUpdate,
    builder: (context) => PopScope(
      canPop: !update.forceUpdate,
      child: AlertDialog(
        title: const Text('Update Available'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(update.message.isNotEmpty ? update.message : 'New version available'),
            if (update.version.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Version ${update.version}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        actions: [
          if (!update.forceUpdate && onLater != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onLater();
              },
              child: const Text('Later'),
            ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onUpdate();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    ),
  );
}
