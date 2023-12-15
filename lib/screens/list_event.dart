import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booka_mobile/models/event.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:booka_mobile/screens/create_event_form.dart';
import 'package:booka_mobile/screens/edit_event.dart';
import 'package:booka_mobile/screens/register_event.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Future<List<Event>> fetchProduct() async {
    var url = Uri.parse('http://127.0.0.1:8000/event/get-event/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Event> list_event = [];
    for (var d in data) {
      if (d != null) {
        list_event.add(Event.fromJson(d));
      }
    }
    return list_event;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada data event.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200, 
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          "${snapshot.data![index].fields.photo}",
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
                            "${snapshot.data![index].fields.name}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("Featuring: ${snapshot.data![index].fields.featuredBook}"),
                          const SizedBox(height: 10),
                          Text("${snapshot.data![index].fields.date.toString().split(' ')[0]}"),
                          const SizedBox(height: 10),
                          Text("${snapshot.data![index].fields.description}"),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterEventPage() 
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
                              ElevatedButton(
                                onPressed: () async {
                                    final deleteUrl = Uri.parse('http://127.0.0.1:8000/event/delete-event-flutter/${snapshot.data![index].pk}/');
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EventFormPage() 
                  ));
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.indigo,
        elevation: 4, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), 
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
