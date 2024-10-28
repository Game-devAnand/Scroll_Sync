import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class UserBorrowedBookView extends StatefulWidget {
//   final String id;
//
//   UserBorrowedBookView({required this.id, Key? key}) : super(key: key);
//
//   @override
//   State<UserBorrowedBookView> createState() => _UserBorrowedBookViewState();
// }
//
// class _UserBorrowedBookViewState extends State<UserBorrowedBookView> {
//   String id = "";
//
//   @override
//   void initState() {
//     id = widget.id;
//     super.initState();
//   }
//
//   Future<String> getBookStringIds(String bookId) async {
//     String bookName = "";
//
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('UserBookData')
//           .doc(id)
//           .collection('myBooks')
//           .doc(bookId)
//           .get();
//
//       if (snapshot.exists) {
//         Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//         bookName = data['book_name'] as String;
//       } else {
//         print('Document does not exist');
//       }
//     } catch (error) {
//       print('Error retrieving book data: $error');
//     }
//     return bookName;
//   }
//
//   Future<List<String>> getBookNames(List<String> bookIds) async {
//     List<String> bookNames = [];
//
//     for (String bookId in bookIds) {
//       String bookName = await getBookStringIds(bookId);
//       bookNames.add(bookName);
//     }
//
//     return bookNames;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Head"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('UserBookData')
//             .doc(id)
//             .collection('myBooks')
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }
//
//           List<QueryDocumentSnapshot> books = snapshot.data!.docs;
//           List<String> bookIds = books.map((book) => book.id).toList();
//           print(bookIds.length);
//           print(bookIds[0]);
//
//           getBookNames(bookIds).then((bookName) {
//             // print('Book Name as names: $bookName');
//             for(int i =0 ; i<bookName.length;i++){
//               print("name is : ${bookName[i]}");
//             }
//           });
//
//           return Center();
//
//           // return FutureBuilder<QuerySnapshot>(
//           //   future: FirebaseFirestore.instance
//           //       .collection('UserBookData')
//           //       .doc(id)
//           //       .collection('myBook')
//           //       .where(FieldPath.documentId, whereIn: bookIds)
//           //       .get(),
//           //   builder:
//           //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           //     if (snapshot.hasError) {
//           //       return Text('Error: ${snapshot.error}');
//           //     }
//           //     print('>>>>${snapshot.data}');
//           //     print('>>>>${snapshot}');
//           //
//           //     if (snapshot.connectionState == ConnectionState.waiting) {
//           //       return CircularProgressIndicator();
//           //     }
//           //
//           //     List<DocumentSnapshot> bookData = snapshot.data!.docs;
//           //
//           //     return ListView.builder(
//           //       itemCount: bookData.length,
//           //       itemBuilder: (BuildContext context, int index) {
//           //         final book = bookData[index].data();
//           //         if (book == null || book is! Map<String, dynamic>) {
//           //           return Container(); // Handle the null or invalid data case
//           //         }
//           //
//           //         final bookMap = book as Map<String, dynamic>;
//           //
//           //         return ListTile(
//           //           title: Text("{}"),
//           //           subtitle: Text(bookMap['author'] as String),
//           //           // Add more widgets to display additional book data
//           //         );
//           //       },
//           //     );
//           //   },
//           // );
//         },
//       ),
//     );
//   }
// }

//============================


class UserBorrowedBookView extends StatefulWidget {
  final String id;

  UserBorrowedBookView({required this.id, Key? key}) : super(key: key);

  @override
  State<UserBorrowedBookView> createState() => _UserBorrowedBookViewState();
}

class _UserBorrowedBookViewState extends State<UserBorrowedBookView> {
  String id = "";

  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  Future<String> getBookStringIds(String bookId) async {
    String bookName = "";

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('UserBookData')
          .doc(id)
          .collection('myBooks')
          .doc(bookId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        bookName = data['book_name'] as String;
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error retrieving book data: $error');
    }
    return bookName;
  }

  Future<List<String>> getBookNames(List<String> bookIds) async {
    List<String> bookNames = [];

    for (String bookId in bookIds) {
      String bookName = await getBookStringIds(bookId);
      bookNames.add(bookName);
    }

    return bookNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Books"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('UserBookData')
            .doc(id)
            .collection('myBooks')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> books = snapshot.data!.docs;
          List<String> bookIds = books.map((book) => book.id).toList();

          return FutureBuilder<List<String>>(
            future: getBookNames(bookIds),
            builder: (BuildContext context, AsyncSnapshot<List<String>> bookNamesSnapshot) {
              if (bookNamesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (bookNamesSnapshot.hasError) {
                return Text('Error: ${bookNamesSnapshot.error}');
              }

              List<String> bookNames = bookNamesSnapshot.data ?? [];

              return ListView.builder(
                itemCount: bookNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(bookNames[index]),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
