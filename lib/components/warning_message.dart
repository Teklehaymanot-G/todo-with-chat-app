import 'package:flutter/material.dart';

void showWarningDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.yellow.shade700, // Warning icon color
            ),
            const SizedBox(width: 10), // Space between icon and text
            Text(
              'Warning',
              style: TextStyle(
                color: Colors.yellow.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Closes the dialog
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
        backgroundColor: Colors.yellow.shade100, // Dialog background color
      );
    },
  );
}
