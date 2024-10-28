import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'book_list_view_page.dart';

class EditBookForm extends StatefulWidget {
  final Book book;

  const EditBookForm({required this.book});

  @override
  _EditBookFormState createState() => _EditBookFormState();
}

class _EditBookFormState extends State<EditBookForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController issuedDateController = TextEditingController();
  TextEditingController bookIdController = TextEditingController();
  TextEditingController stocksController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set initial values for the text fields
    nameController.text = widget.book.name;
    authorNameController.text = widget.book.authorName;
    issuedDateController.text = widget.book.issuedDate.toString();
    bookIdController.text = widget.book.bookId;
    stocksController.text = widget.book.stocks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Book'),
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
              controller: authorNameController,
              decoration: InputDecoration(
                labelText: 'Author Name',
              ),
            ),
            TextField(
              controller: issuedDateController,
              decoration: InputDecoration(
                labelText: 'Issued Date',
              ),
            ),
            TextField(
              controller: bookIdController,
              decoration: InputDecoration(
                labelText: 'Book ID',
              ),
            ),
            TextField(
              controller: stocksController,
              decoration: InputDecoration(
                labelText: 'Stocks',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Save the edited data and update the Firestore document
                updateBook();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void updateBook() {
    String newName = nameController.text;
    String newAuthorName = authorNameController.text;
    DateTime newIssuedDate = DateTime.parse(issuedDateController.text);
    String newBookId = bookIdController.text;
    String newStocks = stocksController.text;

    // Update the book data in Firestore
    FirebaseFirestore.instance.collection('books').doc(widget.book.bookId).update({
      'name': newName,
      'authorName': newAuthorName,
      'issuedDate': newIssuedDate,
      'bookId': newBookId,
      'stocks': newStocks,
    }).then((_) {
      // Show a success message or navigate back to the previous page
      Get.snackbar('Success', 'Book data updated');
      Navigator.pop(context);
    }).catchError((error) {
      // Show an error message
      Get.snackbar('Error', 'Failed to update book data');
    });
  }
}