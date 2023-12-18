import 'package:booka_mobile/landing_page/menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:booka_mobile/landing_page/register_form.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final userProvider = context.read<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25,),
              // Logo, Title, Subtitle
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Text(
                    "Booka.",
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                  ),
                  //Title
                  Text(
                    "Welcome, geeks!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  ),
                  //Subtitle
                  Text("Please sign in to your account first.")
                ],
              ),
              SizedBox(height: 30,),
              Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.mail_rounded, color: Colors.indigo),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Set border radius here
                        borderSide: BorderSide(color: Colors.indigo, width: 1.0), // Set border color and width
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Set border radius here
                        borderSide: BorderSide(color: Colors.indigo, width: 1.0), // Set border color and width
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.key_rounded, color: Colors.indigo),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Set border radius here
                        borderSide: BorderSide(color: Colors.indigo, width: 1.0), // Set border color and width
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Set border radius here
                        borderSide: BorderSide(color: Colors.indigo, width: 1.0), // Set border color and width
                      ),
                      suffixIcon: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.indigo,
                        ),
                      ),

                    ),
                    obscureText: _isObscure, // Hide entered text
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        String username = _usernameController.text;
                        String password = _passwordController.text;

                        // Cek kredensial
                        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                        // Untuk menyambungkan Android emulator dengan Django pada localhost,
                        // gunakan URL http://10.0.2.2/
                        runtimeType;
                        final response = await request.login(
                            //"http://10.0.2.2:8000/login_mobile/",
                            "https://deploytest-production-cf18.up.railway.app/login_mobile/",
                            {
                              'username': username,
                              'password': password,
                            });

                        if (request.loggedIn) {
                          String message = response['message'];
                          await userProvider.setUser(response['username'], response['image_url'] ?? "https://ui-avatars.com/api/?name=${response['username']}&background=0D8ABC&color=fff&size=128",
                          response['email'], response['id'], response['is_superuser']);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MyHomePage()),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content: Text("$message Selamat datang, ${response['username']}.")));
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Login Gagal'),
                              content: Text(response['message']),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo, // Change the button's background color here
                      ),
                      child: const Text('Login', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text("Don't have an account?"),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterFormPage()));
                      },
                      child: const Text('Create account'),
                    ),
                  ),
                  
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
