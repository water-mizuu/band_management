import 'dart:async';

import 'package:flutter/material.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String body,
  FutureOr<void> Function()? onConfirm,
  FutureOr<void> Function()? onCancel,
}) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () async {
            await onCancel?.call();

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            await onConfirm?.call();

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Text("Confirm"),
        ),
      ],
    ),
  );
}
