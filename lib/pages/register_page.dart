import 'package:flutter/material.dart';
import 'package:todo_with_chat_app/components/my_button.dart';
import 'package:todo_with_chat_app/components/my_textfield.dart';
import 'package:todo_with_chat_app/components/warning_message.dart';
import 'package:todo_with_chat_app/services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmController = TextEditingController();

    void registerFun(BuildContext context) async {
      final authService = AuthService();

      String name = _nameController.text.trim();
      String phone = _phoneController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmController.text.trim();

      if (name.isEmpty) {
        showWarningDialog(context, "Name cannot be empty.");
        return;
      }
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
      if (password != confirmPassword) {
        showWarningDialog(context, "Password is not much.");
        return;
      }
      if (password.length < 6) {
        showWarningDialog(context, "Password must be at least 6 characters long.");
        return;
      }

      // Try to sign in if validation passes
      try {
        await authService.createUserWithEmailAndPassword(name, phone, email, password);
      } catch (e) {
        showWarningDialog(context, e.toString());
      }
    }


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
                MyTextField(labelText: "Name *", controller: _nameController),
                const SizedBox(
                  height: 30,
                ),
                MyTextField(labelText: "Phone", controller: _phoneController),
                const SizedBox(
                  height: 30,
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
                MyTextField(
                    labelText: "Confirm Password *",
                    controller: _confirmController,
                    obscureText: true),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: MyButton(
                    label: "Register",
                    onTap: () => registerFun(context),
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
                  "Already have an account?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 3),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    "Login now",
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
