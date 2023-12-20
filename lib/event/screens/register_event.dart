import 'package:flutter/material.dart';
import 'package:booka_mobile/event/screens/list_event.dart';

class RegisterEventPage extends StatefulWidget {
  const RegisterEventPage({super.key});

  @override
  _RegisterEventPageState createState() => _RegisterEventPageState();
}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Event'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: TextStyle(fontFamily: 'Poppins'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontFamily: 'Poppins'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontFamily: 'Poppins'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty!';
                    } else if (!value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _showRegistrationSuccessDialog();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRegistrationSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Success!'),
          content: const Text('You sucessfully registered to the event. See you!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const EventPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
