import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String userId;
  String type;
  String password;
  List<Book> borrowedBooks;

  User({
    required this.name,
    required this.userId,
    required this.type,
    required this.password,
    required this.borrowedBooks,
  });

  // Optional: Add a factory method to create a User object from a Firestore document snapshot
  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
      name: data['name'],
      userId: data['userId'],
      type: data['type'],
      password: data['password'],
      borrowedBooks: List<Book>.from(
        data['borrowedBooks'].map((bookData) => Book.fromMap(bookData)),
      ),
    );
  }
}


class Book {
  String name;
  String authorName;
  DateTime issuedDate;
  String bookId;
  String stocks;

  Book({
    required this.name,
    required this.authorName,
    required this.issuedDate,
    required this.bookId,
    required this.stocks,
  });

  // Optional: Add a factory method to create a Book object from a map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      name: map['name'],
      authorName: map['authorName'],
      issuedDate: (map['issuedDate'] as Timestamp).toDate(),
      bookId: map['bookId'],
      stocks: map['stocks'],
    );
  }
}