import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../admin-page/userView/user_list_view_page.dart';
import '../user-pages/user-entry-page.dart';
import 'data_model.dart';

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

class RequestClass {
  final CollectionReference requestCollection =
      FirebaseFirestore.instance.collection('request');

  Future<void> addBook({required BookNew nbook, required User2? appUser}) async {
    RequestBookModel book = RequestBookModel(
        b_name: nbook.name,
        authorName: nbook.authorName,
        issuedDate: nbook.issuedDate,
        bookId: nbook.bookId,
        stocks: nbook.stocks,
        u_name: '${appUser?.name}',
        u_id: '${appUser?.userId}',
        borrowedBooksNO: '${appUser?.borrowedBooks.length}',
        b_id: nbook.bookId);
    await requestCollection.doc(book.bookId).set(book.toMap());
  }
  //end
}


class RequestBookModel{
  String u_name;
  String u_id;
  String b_id;
  String b_name;
  String authorName;
  DateTime issuedDate;
  String bookId;
  String stocks;
  String borrowedBooksNO;

  RequestBookModel({
    required this.b_name,
    required this.u_name,
    required this.u_id,
    required this.b_id,
    required this.borrowedBooksNO,
    required this.authorName,
    required this.issuedDate,
    required this.bookId,
    required this.stocks,


  });

  Map<String, dynamic> toMap() {
    return {
      'u_name': u_name,
      'u_id': u_id,
      'b_id': b_id,
      'b_name': b_name,
      'authorName': authorName,
      'issuedDate': issuedDate,
      'bookId': bookId,
      'stocks': stocks,
      'borrowedBooks': borrowedBooksNO
    };
  }

  // factory RequestBookModel.fromSnapshot(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   return RequestBookModel(
  //     authorName: data['authorName'],
  //     issuedDate: data['issuedDate'].toDate(),
  //     bookId: data['bookId'],
  //     stocks: data['stocks'],
  //     b_name: data['b_name'],
  //     u_name: data['u_name'],
  //   );
  // }
}




class UserProvider with ChangeNotifier {
  User2? appUser;

  User2? get _appUser => appUser;

  void setAppUser(User2 user) {
    appUser = user;
    notifyListeners();
  }
}
