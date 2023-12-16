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
  File? _imageFile;
  String? _imageUrl;
  String? _imagePath;

  final _formKey = GlobalKey<FormState>();
  String name = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Pendaftaran Akun',
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Email tidak boleh kosong!";
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              validator: (String? value) {
                if (value!.length < 8 || value.isEmpty) {
                  return "Password minimal terdiri dari 8 karakter!";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Username tidak boleh kosong!";
                }
                return null;
              },
            ),
            //Image form for profile picture
            //   Container(
            //     margin: const EdgeInsets.all(10),
            //     child: Column(
            //       children: [
            //         const Text(
            //           "Upload Profile Picture",
            //           style: TextStyle(fontSize: 20),
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             ElevatedButton(
            //               onPressed: () {
            //                 pickImage(ImageSource.camera);
            //               },
            //               child: const Text("Camera"),
            //             ),
            //             ElevatedButton(
            //               onPressed: () {
            //                 pickImage(ImageSource.gallery);
            //               },
            //               child: const Text("Gallery"),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         _imageFile == null
            //             ? const Text("No Image Selected")
            //             : kIsWeb? Image.network(
            //                 _imageFile!.path,
            //                 height: 150,
            //                 width: 150,
            //
            //         ):
            //             Image.file(
            //                 _imageFile!,
            //                 height: 150,
            //                 width: 150,
            //             ),
            //       ],
            //     ),
            //   ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Handle the first button press
                      },
                      child: const Text('Back'),
                    ),
                    const SizedBox(
                        width: 8.0), // Adjust the width as needed for spacing
                    ElevatedButton(
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

                          //try to upload image
                          // if (_imageFile != null) {
                          //   await uploadImage();
                          //
                          // }else{
                          //   String bgColor = Random().nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
                          //
                          // }

                          // Kirim ke Django dan tunggu respons
                          // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                          final response = await request.postJson(
                              "http://10.0.2.2:8000/register_mobile/",
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
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
