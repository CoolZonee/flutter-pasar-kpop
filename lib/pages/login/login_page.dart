import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/api/auth_api.dart';
import 'package:testing_app/class/user_class.dart';
import 'package:testing_app/components/post/loading_spinner.dart';
import 'package:testing_app/models/auth_model.dart';
import 'package:testing_app/pages/home_page/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String route = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthAPI authAPI = AuthAPI();
  final storage = const FlutterSecureStorage();
  late String errorMsg = "";
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _usernameController.text = "";
    _passwordController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    void handleLogin() async {
      errorMsg = "";
      onLoading(context, "Logging in...");
      try {
        User user = await authAPI.login(
            _usernameController.text, _passwordController.text);
        Provider.of<AuthModel>(context, listen: false).login(user);
        Navigator.of(context).pop();

        await Navigator.of(context).pushReplacementNamed(HomePage.route);
      } catch (error) {
        setState(() {
          errorMsg = error.toString().split("Exception: ")[1];
        });

        Navigator.of(context).pop();
        _passwordController.clear();
        _passwordFocusNode.unfocus();
        _usernameFocusNode.requestFocus();
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 190,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(200)),
              child: Center(child: Image.asset('assets/logo/logo.png')),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                focusNode: _usernameFocusNode,
                controller: _usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid mail id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your secure password'),
              ),
            ),
            Text(
              errorMsg,
              style: const TextStyle(color: Colors.red),
            ),
            TextButton(onPressed: () {}, child: const Text("Forgot Password")),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: handleLogin,
                    child: const Text("Login"),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(50.0)))),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
