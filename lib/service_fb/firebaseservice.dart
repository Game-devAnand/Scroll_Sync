import 'package:cloud_firestore/cloud_firestore.dart';

import '../user-pages/user-entry-page.dart';
import 'data_model.dart';

class FirestoreService {
  final CollectionReference booksCollection =
  FirebaseFirestore.instance.collection('books');

  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  final DocumentReference appConfigsDoc =
  FirebaseFirestore.instance.doc('appConfigs/appConfigs');

  // Add a new user to the users collection
  Future<void> addUser(User user) async {
    await usersCollection.doc(user.userId).set(user.toMap());
  }

  Future<void> addBook(Book book) async {
    await booksCollection.doc(book.bookId).set(book.toMap());
  }
}

class RequestClassFb {
  final CollectionReference requestCollection =
  FirebaseFirestore.instance.collection('request');

  Future<void> addBook(BookNew nbook) async {
    Book book = Book(name: nbook.name, authorName: nbook.authorName, issuedDate: nbook.issuedDate, bookId: nbook.bookId, stocks: nbook.stocks);
    await requestCollection.doc(book.bookId).set(book.toMap());
  }
}