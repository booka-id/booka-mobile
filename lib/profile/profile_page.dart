import 'package:booka_mobile/profile/tambah_buku_profil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booka_mobile/models/user.dart';
import '../landing_page/bottom_nav_bar.dart';
import '../landing_page/left_drawer.dart';
import 'book_list.dart';
import 'edit_profile_picture.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    String? userName = user.username;
    String? email = user.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: BotNavBar(4),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.indigo,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    labelText: 'Profile Photo',
                    labelStyle: TextStyle(
                      color: Colors.indigo,
                      backgroundColor: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  child:
                      Consumer<UserProvider>(builder: (context, user, child) {
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.indigo,
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(user.profile_picture),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.indigo,
                                      width: 4,
                                    ),
                                    shape: BoxShape.circle,
                                    color: Colors.indigo,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const EditProfilePic();
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit_rounded,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.indigo),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.indigo,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: Colors.indigo,
                      backgroundColor: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  child: Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.indigo),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.indigo,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.indigo,
                      backgroundColor: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  child: Text(
                    email,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const InputDecorator(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.indigo,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    labelText: 'Favorite Books',
                    labelStyle: TextStyle(
                      color: Colors.indigo,
                      backgroundColor: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  child: Column(
                    children: [
                      BookList('favorit'),
                      SizedBox(
                        height: 10,
                      ),
                      AddBookButton('favorit')
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const InputDecorator(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.indigo,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    labelText: 'Wishlist Books',
                    labelStyle: TextStyle(
                      color: Colors.indigo,
                      backgroundColor: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  child: Column(
                    children: [
                      BookList('wishlist'),
                      SizedBox(
                        height: 10,
                      ),
                      AddBookButton('wishlist')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
