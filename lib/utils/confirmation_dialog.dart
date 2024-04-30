import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {

  final String title;
  final String content;
  final Function onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({super.key, required this.title, required this.content, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(content),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('No'),
          onPressed: () {
            onCancel();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}