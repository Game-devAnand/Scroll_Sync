import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../service_fb/data_model.dart';
import '../service_fb/firebaseservice.dart';

class BookAddPage extends StatefulWidget {
  @override
  _BookAddPageState createState() => _BookAddPageState();
}

class _BookAddPageState extends State<BookAddPage> {
  final _nameController = TextEditingController();
  final _authorController = TextEditingController();
  final _bookStoclController = TextEditingController();
  String BOOKID = '';
  FirestoreService firestorebook = FirestoreService();
  late Book? book;

  // void _submit() {
  //   // Do something with the input values
  //   print('Name: ${_nameController.text}');
  //   print('Author: ${_authorController.text}');
  //   print('Date: ${_dateController.text}');
  //   print('Barcode: ${_bookIDController.text}');
  // }
  //

  String generateUniqueBookId() {
    int timestamp = DateTime.now().microsecondsSinceEpoch;
    String bookId = timestamp.toString();
    return bookId;
  }

  void bookCollectionSubmitButton() {
    // Collect book details
    book = Book(
      name: _nameController.text,
      authorName: _authorController.text,
      issuedDate: DateTime.now(),
      bookId: BOOKID,
      stocks: _bookStoclController.text,
    );

    // Add the book to Firebase
    firestorebook.addBook(book!)
        .then((_) {
      // Book added successfully
      print('Book added to Firebase');
      Get.snackbar('Success', 'Book data added');      // Reset form values
      _nameController.clear();
      _authorController.clear();
      _bookStoclController.clear();
      setState(() {
        book = null;
        BOOKID = '';
      });
    })
        .catchError((error) {
      // Error occurred while adding the book
      print('Error adding book to Firebase: $error');
      // Handle the error or show an error message to the user
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("BookID"),
                Text(BOOKID),
                ElevatedButton(onPressed: (){
                  setState(() {
                    BOOKID = generateUniqueBookId();
                  });
                }, child: const Text("Generate"))
              ],
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Author Name',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _bookStoclController,
              decoration: const InputDecoration(
                labelText: 'Stock',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                if(BOOKID == ''){
                  Get.snackbar('Error', 'Book id value is null');
                  throw Exception("Book id value is null");
                }
                else{
                  bookCollectionSubmitButton();
                }
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }
}
