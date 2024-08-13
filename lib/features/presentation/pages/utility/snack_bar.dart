import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SnackBars {
  // Method to show a generic SnackBar
  static void showSnackBar(
      BuildContext context, String title, String message,
      {required ContentType contentType}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      ),
    );
  }

  // Convenience method for showing a Success SnackBar
  static void showSnackBarSuccess(
      BuildContext context, String title, String message) {
    showSnackBar(context, title, message, contentType: ContentType.success);
  }

  // Convenience method for showing a warning SnackBar
  static void showSnackBarWarning(
      BuildContext context, String title, String message) {
    showSnackBar(context, title, message, contentType: ContentType.warning);
  }

  // Convenience method for showing an error SnackBar
  static void showSnackBarError(
      BuildContext context, String title, String message) {
    showSnackBar(context, title, message, contentType: ContentType.failure);
  }
}
