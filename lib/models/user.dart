import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _username = '';
  String _profile_picture = '';
  String _email = '';
  Image? _image;


  String get username => _username;
  String get profile_picture => _profile_picture;
  String get email => _email;

  void setUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }
  void setProfilePicture(String newProfilePicture) {
    _profile_picture = newProfilePicture;
    _image = Image.network(_profile_picture);
    notifyListeners();
  }
  void setEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }
}

