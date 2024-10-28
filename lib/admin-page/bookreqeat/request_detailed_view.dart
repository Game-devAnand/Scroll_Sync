import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollsync/admin-page/bookreqeat/book_request_view_page.dart';
import '../userView/user_list_view_page.dart';
import 'bookBorrowedInfo.dart';

class RequestDetailCard extends StatefulWidget {
  final RequestBookModelView rbook;

  const RequestDetailCard({required this.rbook});

  @override
  State<RequestDetailCard> createState() => _RequestDetailCardState();
}

class _RequestDetailCardState extends State<RequestDetailCard> {
  late RequestBookModelView requestBook;

  @override
  void initState() {
    super.initState();
    requestBook = widget.rbook;
    if (int.parse(requestBook.borrowedBooksNO) > 5 ||
        (int.parse(requestBook.stocks) < 0)) {
      setState(() {
        color = Colors.grey;
      });
    }
    else{
      setState(() {
        granted(userId: requestBook.u_id, bookId: requestBook.bookId);
        color = Colors.blue;
      });
    }
  }

  var color = Colors.blue;


  // final CollectionReference booksCollection =
  // FirebaseFirestore.instance.collection('books');
  // final CollectionReference usersCollection =
  // FirebaseFirestore.instance.collection('users');
  //
  // Future<void> granted(Book book, User2 user) async {
  //   // Decrement stock in the books collection
  //   await booksCollection.doc(book.bookId).update({
  //     'stocks': (int.parse(book.stocks) - 1).toString(),
  //   });
  //
  //   // Add the book to the borrowedBooks list in the user's document
  //   await usersCollection.doc(user.userId).update({
  //     'borrowedBooks': FieldValue.arrayUnion([book.toMap()]),
  //   });
  // }



  final CollectionReference booksCollection =
  FirebaseFirestore.instance.collection('books');
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> granted({required String userId,required String bookId}) async {
    // Get the book document from the books collection
    DocumentSnapshot bookSnapshot = await booksCollection.doc(bookId).get();
    if (bookSnapshot.exists) {
      // Get the user document from the users collection
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
      if (userSnapshot.exists) {
        // Extract the stock and borrowedBooks fields from the documents
        String stock = bookSnapshot['stocks'];
        List<Map<String, dynamic>> borrowedBooks =
        List.from(userSnapshot['borrowedBooks'] ?? []);

        // Decrement stock in the books collection
        int updatedStock = int.parse(stock) - 1;
        await booksCollection.doc(bookId).update(
            {'stocks': updatedStock.toString()});

        // Add the book to the borrowedBooks list in the user's document
        borrowedBooks.add({'bookId': bookId});
        await usersCollection.doc(userId).update(
            {'borrowedBooks': borrowedBooks});
      } else {
        print('User document not found');
      }
    } else {
      print('Book document not found');
    }


  }
  BorrowedBookClassFb borrowedBookRef = BorrowedBookClassFb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Detail"),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Card(
              elevation: 30,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top:28.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User name : ${requestBook.u_name}'),
                            Text('User ID : ${requestBook.u_id}'),
                            Text('Book : ${requestBook.b_name}'),
                            //Text('Date : ${requestBook.issuedDate}'),
                            Text('item count : ${requestBook.stocks}'),
                            Text('Borrowed Books NO : ${requestBook.borrowedBooksNO}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    // FloatingActionButton(
                    //   onPressed: () {
                    //     if (int.parse(requestBook.borrowedBooksNO) > 5&&
                    //         (int.parse(requestBook.stocks) < 0)) {
                    //       setState(() {
                    //         color = Colors.grey;
                    //       });
                    //     }
                    //     else{
                    //       setState(() {
                    //         granted(userId: requestBook.u_id, bookId: requestBook.bookId);
                    //         color = Colors.blue;
                    //       });
                    //     }
                    //   },
                    //   backgroundColor: color,
                    //   child: const Icon(Icons.check_rounded),
                    // ),
                    Center(
                      child: SizedBox(
                        width: 120,
                        child: GestureDetector(
                          child: Card(
                            color: color,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: const [
                                  Text("  Approve   ",style: TextStyle(color: Colors.white),),
                                  Icon(Icons.check_rounded,color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                          onTap:() {
                            //TODO:ref
                            print("Approved : data");
                            DateTime currentDate = DateTime.now();
                            DateTime issuedDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
                            DateTime dueDate = issuedDate.add(Duration(days: 21));
                            BorrowedBUser newUser = BorrowedBUser(userId: requestBook.u_id, issuedDate: issuedDate, dueDate: dueDate, bookId:requestBook.bookId, book_name:requestBook.b_name ,user_name : requestBook
                            .u_name);
                            borrowedBookRef.addBorrowedBUser(newUser);
                            print(newUser.dueDate);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 220,
                    ),
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
