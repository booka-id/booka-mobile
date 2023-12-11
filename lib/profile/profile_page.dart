import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/asset/cld_image.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:booka_mobile/landing_page/login.dart';
import 'package:provider/provider.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:booka_mobile/profile/book_list_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final user = context.read<UserProvider>();
    final userName = user.username;
    final profilePicture = user.profile_picture;
    final email = user.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 100, backgroundImage: NetworkImage(profilePicture)),
            const SizedBox(height: 12.0),
            Text(
              userName,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12.0),
            Text(
              email,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12.0),
            Text('Buku Favorit'),
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: BookListWidget('favorite'),
            ),
            Text('Buku Wishlist'),
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: BookListWidget('wishlist'),
            ),
          ],
        ),
      ),
    );
  }
}
