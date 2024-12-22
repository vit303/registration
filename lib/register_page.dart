import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode
import 'package:registration/components/login_text_field.dart';
import 'components/login_button.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();
  bool _isAdmin = false;

  Future<void> register(BuildContext context) async {
    final String username = _emailController.text;
    final String password = _pwController.text;
    final String role = _isAdmin ? 'admin' : 'user';

    final response = await http.post(
      Uri.parse('http://217.12.40.218:8080/register'), // Change localhost to your server address
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      // Registration successful
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      );
    } else {
      // Registration failed
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
            Text("Welcome! Please register.", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16)),
            const SizedBox(height: 25),

            // Email text field
            LoginTextField(
              hintText: "Login",
              obscureText: false,
              controller: _emailController,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),

            // Password text field
            LoginTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(height: 10),

            // Password confirmation text field
            LoginTextField(
              hintText: "Confirm the password",
              obscureText: true,
              controller: _pwConfirmController,
            ),
            const SizedBox(height: 10),

            // Admin checkbox
            CheckboxListTile(
              title: Text("Register as Admin"),
              value: _isAdmin,
              onChanged: (bool? value) {
                setState(() {
                  _isAdmin = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 25),

            // Register button
            LoginButton(
              text: "Register",
              onTap: () => register(context),
            ),
            const SizedBox(height: 25),

            // Already have an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text("Login now", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
