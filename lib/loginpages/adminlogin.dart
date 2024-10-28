import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../admin-page/admin-entry-page.dart';


class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final String username = "Admin";
  final String password = "admin123";
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isPasswordVisible = false;


  Future<bool> authenticateUser(String userId, String password) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where('adminId', isEqualTo: userId)
          .where('password', isEqualTo: password)
          .get();

      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      return documents.isNotEmpty; // Return true if the document exists, indicating successful authentication
    } catch (e) {
      print('Error authenticating user: $e');
      return false; // Return false if an error occurred during authentication
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 20,
            child: SizedBox(
              height: 500,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Admin Login',style: TextStyle(fontSize: 28)),
                    SizedBox(
                      height: 50,
                    ),
                    TextField(
                      controller: name,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: pass,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: () async {
                          Get.to(await authenticateUser(name.text,pass.text)?const AdminEntryPage():Get.snackbar('Error', 'Invalid Admin Id or password'));
                          print("Login successful");
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
