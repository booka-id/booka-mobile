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

import '../models/user.dart';

class EditProfilePic extends StatefulWidget {
  const EditProfilePic ({super.key});

@override
State<EditProfilePic> createState() => _EditProfilePic();
}

class _EditProfilePic extends State<EditProfilePic> {
  File? _imageFile;
  String? _imageUrl;
  String? _imagePath;

  String name = "";

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) _imageFile = File(pickedImage.path);
    });
  }

  Future<void> uploadImage() async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dtelcmaaw/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'p03rcnnf'
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      setState(() {
        final url = jsonMap['url'];
        _imageUrl = url;
      });
    }
  }
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return AlertDialog(
              title: const Text('Ubah Foto Profile'),
              content: Container(
                  height: 300,
                  width: 300,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Text(
                        "Upload Foto Profile",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              pickImage(ImageSource.camera);
                            },
                            child: const Text("Camera"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              pickImage(ImageSource.gallery);
                            },
                            child: const Text("Gallery"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _imageFile == null
                          ? const Text("No Image Selected")
                          : kIsWeb? Image.network(
                              _imageFile!.path,
                              height: 150,
                              width: 150,

                      ):
                          Image.file(
                              _imageFile!,
                              height: 150,
                              width: 150,
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await uploadImage();
                              userProvider.changeProfilePic(_imageUrl!);
                              Navigator.pop(context);
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
            );

  }
}
