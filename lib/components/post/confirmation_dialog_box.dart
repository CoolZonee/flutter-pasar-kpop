import 'package:flutter/material.dart';

Future<void> showConfirmationDialogBox(BuildContext context,
    {required String cancelText,
    required String continueText,
    required String alertBoxTitle,
    required String alertBoxContent,
    required void Function() cancelFunc,
    required void Function() continueFunc}) async {
  Widget cancelButton =
      TextButton(onPressed: cancelFunc, child: Text(cancelText));
  Widget continueButton =
      TextButton(onPressed: continueFunc, child: Text(continueText));

  AlertDialog alert = AlertDialog(
    title: Text(alertBoxTitle),
    content: Text(alertBoxContent),
    actions: [continueButton, cancelButton],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
