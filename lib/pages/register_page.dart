import 'package:flutter/material.dart';
import 'package:todo_list_app/auth/auth_service.dart';
import 'package:todo_list_app/core/components/my_button.dart';
import 'package:todo_list_app/core/components/my_textfield.dart';
import 'package:todo_list_app/core/theme/app_palette.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});
  void register(BuildContext context) async {
//auth service
    final auth = AuthService();

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await auth.signUpWithEmailPassword(
            _emailController.text, _passwordController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()), // Ensure e is converted to a string
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text(
              'Passwords don\'t match'), // Ensure e is converted to a string
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppPalette.backgroundColor,
        body: SafeArea(
            child: Stack(
          children: [
            Positioned(
                top: 10,
                left: 230,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor,
                    shape: BoxShape.circle,
                  ),
                )),
            Positioned(
                top: 10,
                left: 270,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor,
                    shape: BoxShape.circle,
                  ),
                )),
            Positioned(
                bottom: 100,
                right: 280,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor,
                    shape: BoxShape.circle,
                  ),
                )),
            Positioned(
                bottom: 10,
                right: 320,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor,
                    shape: BoxShape.circle,
                  ),
                )),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CREATE ACCOUNT',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    MyTextField(
                      hintText: 'EMAIL',
                      icon: Icon(Icons.mail_outline),
                      controller: _emailController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      hintText: 'PASSWORD',
                      icon: Icon(Icons.lock_outline),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    MyTextField(
                      hintText: 'CONFIRM PASSWORD',
                      icon: Icon(Icons.lock_outline),
                      controller: _confirmPasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyButton(
                        text: 'REGISTER', onPressed: () => register(context)),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not a member?\t'),
                        GestureDetector(
                          onTap: onTap,
                          child: Text(
                            'Register now',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 149, 87, 133)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        )));
  }
}
