import 'dart:convert';
import 'dart:io'show File;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:booka_mobile/landing_page/login.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordValidator = TextEditingController();
  String? _imageUrl;

  final _formKey = GlobalKey<FormState>();
  String name = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                SizedBox(height: 25,),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hello, there!",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    //Subtitle
                    Text("We're so glad to have you on board.")
                  ],
                ),
                SizedBox(height: 30,),
                // Register Form
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child:
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
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
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Email tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15.0),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person, color: Colors.indigo),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Set border radius here
                                borderSide: BorderSide(color: Colors.indigo, width: 1.0), // Set border color and width
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Set border radius here
                                borderSide: BorderSide(color: Colors.indigo, width: 1.0), // Set border color and width
                              ),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Username tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15.0),
                          TextFormField(
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
                            ),
                            obscureText: true,
                            validator: (String? value) {
                              if (value!.length < 8 || value.isEmpty) {
                                return "Password minimal terdiri dari 8 karakter!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15.0),
                          TextFormField(
                            controller: _passwordValidator,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.check, color: Colors.indigo),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Set border radius here
                                borderSide: BorderSide(color: Colors.indigo, width: 1.0), // Set border color and width
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Set border radius here
                                borderSide: BorderSide(color: Colors.indigo, width: 1.0), // Set border color and width
                              ),
                            ),
                            obscureText: true,
                            validator: (String? value) {
                              if (value!.length < 8 || value.isEmpty) {
                                return "Password minimal terdiri dari 8 karakter!";
                              }else if(value != _passwordController.text){
                                return "Password tidak sama!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.indigo),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String username = _usernameController.text;
                                  String password = _passwordController.text;
                                  String email = _emailController.text;
                                  String bgColor = Random().nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
                                  _imageUrl = "https://ui-avatars.com/api/?name=$username&background=$bgColor&color=fff&size=128";

                                  // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                                  final response = await request.postJson(
                                      "https://deploytest-production-cf18.up.railway.app/register_mobile/",
                                      jsonEncode(<String, String>{
                                        'username': email,
                                        'password': password,
                                        'name': username,
                                        'imageUrl': _imageUrl!,
                                        // TODO: Sesuaikan field data sesuai dengan aplikasimu
                                      }));
                                  if (response['status'] == 'success') {
                                    name = response['username'];
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content:
                                      Text("Akun $name berhasil  didaftarkan!"),
                                    ));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const LoginPage()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Terdapat kesalahan, silakan coba lagi."),
                                    ));
                                  }
                                }
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text("Already have an account?"),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()));
                              },
                              child: const Text('Login Now'),
                            ),
                          ),
                          //
                        ]),
                  ),
                ),
              ],
            )
        ),
      )
    );
  }
}
