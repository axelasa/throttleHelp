import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppToast {
  showSnackBar(
      {required BuildContext context,
      required String title,
      required String message,
      required Color color,
      required ContentType type}) {
    var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
