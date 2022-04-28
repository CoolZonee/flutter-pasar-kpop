import 'package:flutter/material.dart';
import 'package:testing_app/pages/home_page.dart';

Future<void> onLoading(BuildContext context, String loadingText) async {
  showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text(loadingText),
              )
            ],
          ),
        ));
      });
}
