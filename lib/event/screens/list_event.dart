import 'package:booka_mobile/landing_page/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booka_mobile/models/event.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:booka_mobile/event/screens/create_event_form.dart';
import 'package:booka_mobile/event/screens/edit_event.dart';
import 'package:booka_mobile/event/screens/register_event.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:booka_mobile/landing_page/bottom_nav_bar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Future<List<Event>> fetchProduct() async {
    var url = Uri.parse(
        'https://deploytest-production-cf18.up.railway.app/event/get-event/');
    //  var url = Uri.parse('http://127.0.0.1:8000/event/get-event/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Event> listEvent = [];
    for (var d in data) {
      if (d != null) {
        listEvent.add(Event.fromJson(d));
      }
    }
    return listEvent;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
      ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: BotNavBar(3),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No Event.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          snapshot.data![index].fields.photo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data![index].fields.name,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                              "Featuring: ${snapshot.data![index].fields.featuredBook}"),
                          const SizedBox(height: 10),
                          Text(snapshot.data![index].fields.date
                              .toString()
                              .split(' ')[0]),
                          const SizedBox(height: 10),
                          Text(snapshot.data![index].fields.description),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!user.is_superuser)
                                ElevatedButton(
                                  onPressed: () {
                                    if (request.loggedIn)
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterEventPage() 
                                              ));
                                    if (!request.loggedIn)
                                       Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage() 
                                              ));
                                    }, 
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                                  ),
                                  child: const Text("Register", 
                                  style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (user.is_superuser)
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditEventPage(event:snapshot.data![index]) 
                                              ));
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.grey[400]),
                                    ),
                                    child: const Text("Edit", 
                                    style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                              if (user.is_superuser)
                                ElevatedButton(
                                  onPressed: () async {
                                      final deleteUrl = Uri.parse('https://deploytest-production-cf18.up.railway.app/event/delete-event-flutter/${snapshot.data![index].pk}/');
                                      // final deleteUrl = Uri.parse('http://127.0.0.1:8000/event/delete-event-flutter/${snapshot.data![index].pk}/');
                                      final response = await http.delete(deleteUrl);
                                      setState(() {
                                        if (response.statusCode == 200) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("Event deleted successfully!"),
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("Failed to delete the event. Please try again."),
                                          ));
                                        }
                                      });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red),
                                  ),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: user.is_superuser
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EventFormPage(),
                  ),
                );
              },
              backgroundColor: Colors.indigo,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
