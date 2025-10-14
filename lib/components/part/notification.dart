import "package:flutter/material.dart";

Future<bool> showConfirmDialog(BuildContext context, String message) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                'Tampaknya',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            content: Text(message, style: TextStyle(fontSize: 16)),
            actions: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Tidak'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Ya'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ) ??
      false;
}
