import 'package:flutter/material.dart';

class ErrorScreen {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el popup
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
