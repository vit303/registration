import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode
import 'package:registration/components/login_text_field.dart';
import 'package:registration/register_page.dart';
import 'components/login_button.dart';


class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final String username = _emailController.text;
    final String password = _pwController.text;

    final response = await http.post(
      Uri.parse('http://217.12.40.218:8080/login'), // Change localhost to your server address
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text(response.body),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to another page if needed
              },
            ),
          ],
        ),
      );
    } else {
      // Login failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(response.body),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message, size: 60, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 50),
            Text("Welcome back, you've been missed!", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16)),
            const SizedBox(height: 25),

            // Email text field
            LoginTextField(
              hintText: "Login",
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(height: 10),

            // Password text field
            LoginTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(height: 25),

            // Login button
            LoginButton(
              text: "Login",
              onTap: () => login(context),
            ),
            const SizedBox(height: 25),

            // Register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member? ", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                  },
                  child: Text("Register now", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
