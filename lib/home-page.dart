import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loginpages/adminlogin.dart';
import 'loginpages/user-login.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Card(
            elevation: 20,
            child: SizedBox(
              width: 300,
              height: 500,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ScrollSync',
                      style: TextStyle(fontSize: 34),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.menu_book,
                      color: Colors.blue,
                      size: 150,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 28),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => UserLoginPage());
                      },
                      child: Text(' User '),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AdminLoginPage());
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Admin'),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.blue,
                            style: BorderStyle.solid,
                            width: 2.0,
                          ),
                        ),
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
}
