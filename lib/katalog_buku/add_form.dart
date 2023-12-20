// Impor http package
import 'dart:convert';

import 'package:booka_mobile/katalog_buku/catalogue.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBookFormPage extends StatefulWidget {
  const AddBookFormPage({Key? key}) : super(key: key);

  @override
  State<AddBookFormPage> createState() => _AddBookFormPageState();
}

class _AddBookFormPageState extends State<AddBookFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _isbn = "";
  String _title = "";
  String _author = "";
  int _year = 0;
  String _publisher = "";
  String _imageUrl = "";
  int _quantity = 0;
  int _price = 0;

  // Fungsi untuk mengirim data ke Django
  Future<void> addBook() async {
    final url = Uri.parse(
        'https://deploytest-production-cf18.up.railway.app/catalogue/add-book-flutter/'); // Ganti dengan URL API Django Anda
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "isbn": _isbn,
          "title": _title,
          "author": _author,
          "year": _year.toString(),
          "publisher": _publisher,
          "image_url_large": _imageUrl,
          "quantity": _quantity.toString(),
          "price": _price.toString(),
        }));

    if (response.statusCode == 200) {
      // Berhasil menyimpan buku
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Buku baru berhasil disimpan!")),
      );
      // Anda mungkin ingin navigasi ke halaman lain atau refresh state
      Future.delayed(const Duration(seconds: 2), () {
        // Atau, jika Anda ingin mengganti halaman saat ini dengan home, gunakan:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const CataloguePage()));
      });
    } else {
      // Terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terdapat kesalahan, silakan coba lagi.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ISBN',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ISBN is required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid ISBN';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _isbn = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Author is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _author = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Year is required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _year = int.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Publisher',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Publisher is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _publisher = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Image URL is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _imageUrl = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Quantity is required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _quantity = int.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _price = int.parse(value!);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), // fixed height
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      addBook();
                    }
                  },
                  child: const Text('Add Book'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
