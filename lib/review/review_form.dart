import 'dart:convert';

import 'package:booka_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewFormPage extends StatefulWidget {
  final int bookID;
  const ReviewFormPage({Key? key, required this.bookID}) : super(key: key);

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState(bookID: bookID);
}

class _ReviewFormPageState extends State<ReviewFormPage> {
    final _formKey = GlobalKey<FormState>();
    final int bookID;
    int _rating = 0;
    String _content = "";
    bool isButtonEnabled = false;

  _ReviewFormPageState({required this.bookID});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final user = context.read<UserProvider>();

        return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  Center(
                    child: RatingBar.builder(
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _rating = rating.toInt();
                        setState(() {
                          isButtonEnabled = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Comment",
                        labelText: "Comment",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _content = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Comment tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: isButtonEnabled ?
                              MaterialStateProperty.all(Colors.black) : MaterialStateProperty.all(Colors.grey) ,
                        ),
                        onPressed: isButtonEnabled ? () async {
                        if (_formKey.currentState!.validate()) {
                          // Kirim ke Django dan tunggu respons
                          // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                          final response = await request.postJson(
                              // "http://127.0.0.1:8000/review/post-flutter/$bookID",
                              "http://10.0.2.2:8000/review/post-flutter/$bookID",
                              // "https://deploytest-production-cf18.up.railway.app/review/post-flutter/${bookID}",
                              jsonEncode(<String, String>{
                                'title': '',
                                'rating': _rating.toString(),
                                'content': _content,
                                //TODO: FIGURE OUT HOW TO GET THE LOGGED IN USER'S EMAIL
                                'email': user.email //MASIH HARDCODE,
                              }));
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Review Anda berhasil disimpan!"),
                            ));
                            Navigator.pop(context); //close the modalbottomsheet
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => BookDetailPage(bookID: bookID,)),
                            // );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "Terdapat kesalahan, silakan coba lagi."),
                            ));
                          }
                        }
                      }
                    : null,
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
