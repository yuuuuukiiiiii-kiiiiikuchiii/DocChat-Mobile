import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_faq_document/models/error/custom_error.dart';

void errorDialog(
  BuildContext context,
  String errorMessage,
  CustomError e,
  String? goName,
) {
  final userMessage = e.userMessage;
  final goRouter = GoRouter.of(context);
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(errorMessage),
          content: Text(userMessage),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                if (goName != null) goRouter.goNamed(goName);
              },
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(errorMessage),
          content: Text(userMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (goName != null) goRouter.goNamed(goName);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
