import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future<String> bookStringFinder(String bookId) async {
  final CollectionReference booksCollection =
  FirebaseFirestore.instance.collection('books');

  try {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await booksCollection.doc(bookId).get() as DocumentSnapshot<Map<String, dynamic>>;

    if (snapshot.exists) {
      final bookData = snapshot.data();
      final String bookName = bookData?['name'] ?? 'Unknown Book';
      final String author = bookData?['author'] ?? 'Unknown Author';

      return 'Book: $bookName\nAuthor: $author';
    } else {
      return 'Book not found.';
    }
  } catch (e) {
    print('Error searching for book: $e');
    return 'Error occurred while searching for book.';
  }
}
