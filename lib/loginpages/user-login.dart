import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../admin-page/userView/user_list_view_page.dart';
import '../service_fb/requst.dart';
import '../user-pages/user-entry-page.dart';

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final String username = "User";
  final String password = "user123";
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isPasswordVisible = false;
  late User2 appUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 20,
            child: SizedBox(
              width: 300,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('User Login',style: TextStyle(fontSize: 28)),
                    const SizedBox(
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
                    ChangeNotifierProvider(
                      create:  (_) => UserProvider(),
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.to(await authenticateUser(name.text, pass.text)
                              ? UserEnteryPage()
                              : Get.snackbar('Error', 'Invalid userId or password'));
                        },
                        child: Text('Login'),
                      ),
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

  Future<bool> authenticateUser(String userId, String password) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: userId)
          .where('password', isEqualTo: password)
          .get();

      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      appUser = User2.fromSnapshot(documents.first);

      Provider.of<UserProvider>(context, listen: false).setAppUser(appUser);

      print(appUser.name);
      return documents.isNotEmpty; // Return true if the document exists, indicating successful authentication
    } catch (e) {
      print('Error authenticating user: $e');
      return false; // Return false if an error occurred during authentication
    }
  }
}

