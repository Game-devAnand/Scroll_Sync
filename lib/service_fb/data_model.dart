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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'type': type,
      'password': password,
      'borrowedBooks': borrowedBooks.map((book) => book.toMap()).toList(),
    };
  }

  bool canBorrow() {
    return borrowedBooks.length < 5;
  }

  // void borrowBook(Book book) {
  //   if (canBorrow()) {
  //     borrowedBooks.add(book);
  //   } else {
  //     throw Exception('Cannot borrow more than 5 books!');
  //   }
  // }
  //
  // void returnBook(Book book) {
  //   borrowedBooks.remove(book);
  // }
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'authorName': authorName,
      'issuedDate': issuedDate,
      'bookId': bookId,
      'stocks': stocks,
    };
  }




}


