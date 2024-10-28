import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'functionsIssueBooks.dart';
import 'package:intl/intl.dart';

class BorrowedBUser {
  String userId;
  String bookId;
  DateTime issuedDate;
  DateTime dueDate;

  BorrowedBUser({
    required this.userId,
    required this.bookId,
    required this.issuedDate,
    required this.dueDate,
  });
}



Future<DocumentSnapshot<Map<String, dynamic>>?> getBorrowedUserData(String bookId, String userId) async {
  final DocumentReference documentRef = FirebaseFirestore.instance
      .collection('BorrowedBook')
      .doc(bookId)
      .collection('Users')
      .doc(userId);

  try {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await documentRef.get() as DocumentSnapshot<Map<String, dynamic>>;
    if (snapshot.exists) {
      return snapshot;
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching borrowed user data: $e');
    throw e; // Rethrow the error or handle it as per your requirement
  }
}





class BorrowedBooksWidget extends StatefulWidget {
  const BorrowedBooksWidget({Key? key}) : super(key: key);

  @override
  State<BorrowedBooksWidget> createState() => _BorrowedBooksWidgetState();
}

class _BorrowedBooksWidgetState extends State<BorrowedBooksWidget> {
  @override
  Widget build(BuildContext context) {
    return BorrowedBooksListWidget();
  }
}


class BorrowedUsersWidget extends StatelessWidget {
  final String bookId;
  final String userId;

  const BorrowedUsersWidget({
    required this.bookId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowed User Data'),
      ),
      body:FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
        future: getBorrowedUserData(bookId, userId),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Text('No borrowed user data found.');
          }

          final borrowedUserData = snapshot.data!.data();

          final String userId = borrowedUserData!['userId'];
          final String bookId = borrowedUserData['bookId'];
          final DateTime issuedDate = borrowedUserData['issuedDate'].toDate();
          final DateTime dueDate = borrowedUserData['dueDate'].toDate();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User ID: $userId'),
              Text('Book ID: $bookId'),
              Text('Issued Date: $issuedDate'),
              Text('Due Date: $dueDate'),
            ],
          );
        },
      ),
    );
  }
}

//===================


Future<List<DocumentSnapshot<Map<String, dynamic>>>> getAllBorrowedBooks() async {
  final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
      .collection('BorrowedBook')
      .get();

  return querySnapshot.docs;
}


Future<List<DocumentSnapshot<Map<String, dynamic>>>> getAllBorrowedUsers(String bookId) async {
  final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
      .collection('BorrowedBook')
      .doc(bookId)
      .collection('Users')
      .get();

  return querySnapshot.docs;
}





class BorrowedBooksListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowed Books'),
      ),
      body: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: getAllBorrowedBooks(),
        builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot<Map<String, dynamic>>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final List<DocumentSnapshot<Map<String, dynamic>>> borrowedBooks = snapshot.data ?? [];

          if (borrowedBooks.isEmpty) {
            return Text('No borrowed books found.');
          }

          return ListView.builder(
            itemCount: borrowedBooks.length,
            itemBuilder: (BuildContext context, int index) {
              final bookDoc = borrowedBooks[index];
              // print(bookDoc.data().toString());
              final String bookId = bookDoc.id;
              final String bookName = bookDoc.data()!['book_Name'];
              //TODO:STRING maker
              dynamic name = bookStringFinder(bookName);
              print("name of book : ${name}");

              return Card(
                child: ListTile(
                  title: Text("${bookName}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BorrowedUsersListWidget(bookId: bookId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BorrowedUsersListWidget extends StatelessWidget {
  final String bookId;

  const BorrowedUsersListWidget({
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowed Users'),
      ),
      body: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: getAllBorrowedUsers(bookId),
        builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot<Map<String, dynamic>>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final List<DocumentSnapshot<Map<String, dynamic>>> borrowedUsers = snapshot.data ?? [];

          if (borrowedUsers.isEmpty) {
            return Text('No borrowed users found.');
          }

          return ListView.builder(
            itemCount: borrowedUsers.length,
            itemBuilder: (BuildContext context, int index) {
              final userDoc = borrowedUsers[index];
              final String userId = userDoc.id;
              final String userIName = userDoc.data()!['user_name'];
              final DateTime issuedDate = userDoc.data()!['issuedDate'].toDate();
              final DateTime dueDate = userDoc.data()!['dueDate'].toDate();
              final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
              final String formattedIssuDate = dateFormat.format(issuedDate);
              final String formattedDueDate = dateFormat.format(dueDate);

              return Card(
                elevation: 4, // Adjust the elevation as needed
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust the margins as needed
                child: ListTile(
                  title: Text(
                      'Name: $userIName',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User ID: $userId'),
                      Text('Issued Date: $formattedIssuDate'),
                      Text('Due Date: $formattedDueDate'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
