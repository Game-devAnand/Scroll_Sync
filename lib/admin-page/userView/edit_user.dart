import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_list_view_page.dart';

class EditUserForm extends StatefulWidget {
  final User2 user;

  const EditUserForm({required this.user});

  @override
  _EditUserFormState createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set initial values for the text fields
    nameController.text = widget.user.name;
    userIdController.text = widget.user.userId;
    typeController.text = widget.user.type;
    passwordController.text = widget.user.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: userIdController,
              decoration: InputDecoration(
                labelText: 'User ID',
              ),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                labelText: 'Type',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Save the edited data and update the Firestore document
                updateUser();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void updateUser() {
    String newName = nameController.text;
    String newUserId = userIdController.text;
    String newType = typeController.text;
    String newPassword = passwordController.text;

    // Update the user data in Firestore
    FirebaseFirestore.instance.collection('users').doc(widget.user.userId).update({
      'name': newName,
      'userId': newUserId,
      'type': newType,
      'password': newPassword,
    }).then((_) {
      // Show a success message or navigate back to the previous page
      Get.snackbar('Success', 'User data updated');
      Navigator.pop(context);
    }).catchError((error) {
      // Show an error message
      Get.snackbar('Error', 'Failed to update user data');
    });
  }
}