import 'package:booka_mobile/models/book.dart';
import 'package:booka_mobile/models/stock.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditBookFormPage extends StatefulWidget {
  final int bookId;

  const EditBookFormPage({Key? key, required this.bookId,}) : super(key: key);

  @override
  _EditBookFormPageState createState() => _EditBookFormPageState();
}

class _EditBookFormPageState extends State<EditBookFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _isbnController;
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _yearController;
  late TextEditingController _publisherController;
  late TextEditingController _imageUrlController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  
  @override
  void initState() {
    super.initState();
    _isbnController = TextEditingController();
    _titleController = TextEditingController();
    _authorController = TextEditingController();
    _yearController = TextEditingController();
    _publisherController = TextEditingController();
    _imageUrlController = TextEditingController();
    _quantityController = TextEditingController();
    _priceController = TextEditingController();
    _fetchBookData();
  }

  Future<void> _fetchBookData() async {
    final bookUrl = Uri.parse('http://10.0.2.2:8000/catalogue/book-json/${widget.bookId}/');
    final bookstockUrl = Uri.parse('http://10.0.2.2:8000/catalogue/bookstock-json/${widget.bookId}/');
    
      var bookResponse = await http.get(
        bookUrl,
        headers: {"Content-Type": "application/json"},
      );
      var bookstockResponse = await http.get(
        bookstockUrl,
        headers: {"Content-Type": "application/json"},
      );

      var bookData = jsonDecode(utf8.decode(bookResponse.bodyBytes));
      var bookstockData = jsonDecode(utf8.decode(bookstockResponse.bodyBytes));
      Book book = Book.fromJson(bookData[0]);
      Stock bookstock = Stock.fromJson(bookstockData[0]);
      // Assuming the API returns the data in the expected format
      _isbnController.text = book.fields.isbn;
      _titleController.text = book.fields.title;
      _authorController.text = book.fields.author;
      _yearController.text = book.fields.year.toString();
      _publisherController.text = book.fields.publisher;
      _imageUrlController.text = book.fields.imageUrlLarge;
      _quantityController.text = bookstock.fields.quantity.toString();
      _priceController.text = bookstock.fields.price.toString();
  }

  // Contoh fungsi untuk mengupdate buku
Future<void> updateBook(Map<String, dynamic> bookData) async {
  final url = Uri.parse('http://10.0.2.2:8000/catalogue/edit-book-flutter/${widget.bookId}/');
  final response = await http.post(url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(bookData),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Buku berhasil diperbarui!")),
    );
    Navigator.pop(context, 'updated'); // Kembali ke halaman sebelumnya
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Terjadi kesalahan: ${response.body}")),
    );
  }
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Edit Book"),
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
                controller: _isbnController,
                decoration: const InputDecoration(labelText: 'ISBN'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ISBN';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter author';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _publisherController,
                decoration: const InputDecoration(labelText: 'Publisher'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter publisher';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Collect data from the form
                    Map<String, dynamic> bookData = {
                      'isbn': _isbnController.text,
                      'title': _titleController.text,
                      'author': _authorController.text,
                      'year': _yearController.text,
                      'publisher': _publisherController.text,
                      'image_url': _imageUrlController.text,
                      'quantity': _quantityController.text,
                      'price': _priceController.text,
                    };
                    print(bookData);
                    // Call the function to update the book
                    updateBook(bookData);
                  }
                },
                child: const Text('Update Book'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  // Remember to dispose controllers
  @override
  void dispose() {
    _isbnController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _publisherController.dispose();
    _imageUrlController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
