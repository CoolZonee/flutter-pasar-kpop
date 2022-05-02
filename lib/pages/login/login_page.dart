import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:testing_app/api/auth_api.dart';
import 'package:testing_app/components/post/loading_spinner.dart';
import 'package:testing_app/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  final String route = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthAPI authAPI = AuthAPI();
  final _db = Localstore.instance;
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
    void handleLogin() {
      errorMsg = "";
      onLoading(context, "Logging in...");
      authAPI
          .login(_usernameController.text, _passwordController.text)
          .then((user) {
        Navigator.of(context).pop();
        Navigator.pushNamedAndRemoveUntil(context, const HomePage().route,
            ModalRoute.withName(const HomePage().route));
      }).catchError((error) {
        _db.collection('isLoggedIn').doc('status').set({"isLoggedIn": false});
        setState(() {
          errorMsg = error.message.toString();
        });

        Navigator.of(context).pop();
        _passwordController.clear();
        _passwordFocusNode.unfocus();
        _usernameFocusNode.requestFocus();
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.pink),
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
