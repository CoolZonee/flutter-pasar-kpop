import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/auth_model.dart';
import 'package:testing_app/pages/login/login_page.dart';
import '../../api/auth_api.dart';
import '../../components/post/confirmation_dialog_box.dart';
import '../../components/post/loading_spinner.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final AuthAPI authAPI = AuthAPI();
    void _handleLogOut() async {
      showConfirmationDialogBox(context,
          cancelText: "Cancel",
          continueText: "Log Out",
          alertBoxTitle: "Log Out",
          alertBoxContent: "Would you like to log out?", cancelFunc: () {
        Navigator.of(context).pop();
      }, continueFunc: () async {
        onLoading(context, "Logging out...");
        try {
          await authAPI.logout();
          Provider.of<AuthModel>(context, listen: false).logout();
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
          await Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginPage.route, (route) => false);
        } catch (error) {
          Navigator.pop(context);
          log(error.toString());
        }
      });
    }

    return ListView(shrinkWrap: false, primary: false, children: [
      SizedBox(
          child: ListTile(
              title: Consumer<AuthModel>(builder: (context, auth, child) {
        return const Text("Logout");
      }), onTap: () {
        _handleLogOut();
      }))
    ]);
  }
}
