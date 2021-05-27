import 'package:flutter/material.dart';

//dialog alert jika belum scan QR
createAlertDialog(BuildContext context, String messages) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Peringatan!!!", style: TextStyle(color: Colors.red)),
          content: Text(messages),
        );
      });
}