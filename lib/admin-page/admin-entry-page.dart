import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollsync/admin-page/userView/user_list_view_page.dart';

import 'addbookpage.dart';
import 'adduserpage.dart';
import 'bookreqeat/book_request_view_page.dart';
import 'booksView/book_list_view_page.dart';
import 'issuedBookPageListView/issuedBookList.dart';

class AdminEntryPage extends StatefulWidget {
  const AdminEntryPage({Key? key}) : super(key: key);

  @override
  State<AdminEntryPage> createState() => _AdminEntryPageState();
}

class _AdminEntryPageState extends State<AdminEntryPage> {
  @override
  Widget build(BuildContext context) {
    return AdminPage();
  }
}

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Management'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 27),
          child: Card(
            elevation: 12,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: SizedBox(
                            height: 180,
                            width: 320,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "View Details",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            Get.to(const AdminBookViewPage()),
                                        child: const SizedBox(
                                          height: 80,
                                          width: 100,
                                          child: Center(
                                            child: Text(
                                              'Books',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Get.to(const AdminUserViewPage()),
                                        child: const SizedBox(
                                          height: 120,
                                          width: 80,
                                          child: Center(
                                            child: Text(
                                              'Users',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    const Text(
                      "Operations",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Get.to(StudentAddPage()),
                          child: const SizedBox(
                            height: 120,
                            width: 100,
                            child: Center(
                              child: const Text(
                                'Add User',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Get.to(BookAddPage()),
                          child: const SizedBox(
                            height: 120,
                            width: 100,
                            child: Center(
                              child: const Text(
                                'Add Books',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Get.to(const AdminRequestBookViewPage()),
                          child: const SizedBox(
                            height: 120,
                            width: 100,
                            child: Center(
                              child: const Text(
                                'Requests',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),ElevatedButton(
                          onPressed: () {
                            Get.to(BorrowedBooksWidget());
                          },
                          child: const SizedBox(
                            height: 120,
                            width: 100,
                            child: Center(
                              child: Text(
                                'Issued Books',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
