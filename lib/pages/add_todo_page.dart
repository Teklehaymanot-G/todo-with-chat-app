import 'package:flutter/material.dart';
import 'package:todo_with_chat_app/components/my_button.dart';
import 'package:todo_with_chat_app/components/my_textfield.dart';
import 'package:todo_with_chat_app/components/warning_message.dart';
import 'package:todo_with_chat_app/services/auth/auth_service.dart';

class AddTodoPage extends StatelessWidget {
  AddTodoPage({super.key});

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void loginFun(BuildContext context) async {
    final authService = AuthService();

    // Retrieve the text values from the controllers
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validate email and password
    if (email.isEmpty) {
      showWarningDialog(context, "Email cannot be empty.");
      return;
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email)) {
      showWarningDialog(context, "Please enter a valid email address.");
      return;
    }
    if (password.isEmpty) {
      showWarningDialog(context, "Password cannot be empty.");
      return;
    }
    if (password.length < 6) {
      showWarningDialog(context, "Password must be at least 6 characters long.");
      return;
    }

    // Try to sign in if validation passes
    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      showWarningDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(75.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.today_outlined,
                          size: 60,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Icon(
                          Icons.chat,
                          size: 60,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Welcome back, it’s great to have you",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                MyTextField(labelText: "Email *", controller: _emailController),
                const SizedBox(
                  height: 16,
                ),
                MyTextField(
                    labelText: "Password *",
                    controller: _passwordController,
                    obscureText: true),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: MyButton(
                    label: "Login",
                    onTap: () => loginFun(context),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 3),
                GestureDetector(
                  onTap: (){},
                  child: const Text(
                    "Register now",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
