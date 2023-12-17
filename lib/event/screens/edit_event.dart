import 'package:flutter/material.dart';
import 'package:booka_mobile/main.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:booka_mobile/landing_page/menu.dart';
import 'package:booka_mobile/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:booka_mobile/models/event.dart';

class EditEventPage extends StatefulWidget {
  final Event event; 

  const EditEventPage({required this.event, Key? key}) : super(key: key);

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _description = "";
  String _photo = "";
  String _featuredBook = "";
  String _date = "";
  List<String> featuredBookList = <String>[];
  String _selectedFeaturedBook = "None";

  Future<List<String>> fetchProduct() async {
    var url = Uri.parse('http://127.0.0.1:8000/event/get-books/');
    // var url = Uri.parse('https://deploytest-production-cf18.up.railway.app/event/get-books/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<String> list_string = [];
    list_string.add("None");

    for (var d in data) {
      if (d != null) {
        list_string.add(Book.fromJson(d).fields.title);
      }
    }

    featuredBookList = list_string;
    return list_string;
  }

  @override
  void initState() {
    super.initState();
    _name = widget.event.fields.name;
    _description = widget.event.fields.description;
    _photo = widget.event.fields.photo;
    _featuredBook = widget.event.fields.featuredBook;
    _date = widget.event.fields.date.toString().split(' ')[0];
    _selectedFeaturedBook = _featuredBook;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Edit Event',
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    "Tidak ada Buku disini",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _name, 
                          decoration: InputDecoration(
                            hintText: "Nama Event",
                            labelText: "Nama Event",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _name = value;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Nama tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Featured Book",
                            ),
                            SizedBox(height: 8.0),
                            DropdownButton<String>(
                              value: _selectedFeaturedBook,
                              items: featuredBookList
                                  .map((String featuredBookChosen) {
                                return DropdownMenuItem<String>(
                                  value: featuredBookChosen,
                                  child: Text(featuredBookChosen),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedFeaturedBook =
                                      newValue.toString();
                                  _featuredBook = newValue.toString();
                                });
                              },
                              isExpanded: true,
                              underline: Container(
                                height: 1,
                              ),
                              icon: Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _date,
                          decoration: InputDecoration(
                            hintText: "Tanggal (YYYY-MM-DD)",
                            labelText: "Tanggal",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _date = value;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Tanggal tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _description,
                          decoration: InputDecoration(
                            hintText: "Deskripsi",
                            labelText: "Deskripsi",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _description = value;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Deskripsi tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _photo,
                          decoration: InputDecoration(
                            hintText: "URL Foto",
                            labelText: "URL Foto",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _photo = value;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "URL Foto tidak boleh kosong!";
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
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.indigo),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final response = await request.postJson(
                                  // "https://deploytest-production-cf18.up.railway.app/${widget.event.pk}/",
                                  "http://127.0.0.1:8000/event/edit-event-flutter/${widget.event.pk}/", 
                                  jsonEncode({
                                    'name': _name,
                                    'featured_book': _featuredBook,
                                    'date': _date,
                                    'description': _description,
                                    'photo': _photo,
                                  }),
                                );
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Event berhasil diedit!"),
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Gagal. Silakan coba lagi."),
                                  ));
                                }
                              }
                            },
                            child: const Text(
                              "Edit Event",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
