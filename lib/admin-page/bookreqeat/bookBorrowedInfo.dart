import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowedBUser {
  String userId;
  String bookId;
  String book_name;
  String user_name;
  DateTime issuedDate;
  DateTime dueDate;

  BorrowedBUser({
    required this.userId,
    required this.bookId,
    required this.issuedDate,
    required this.dueDate,
    required this.book_name,
    required this.user_name,
  });
}


class BorrowedBookClassFb {
  final CollectionReference borrowedBookCollection =
  FirebaseFirestore.instance.collection('BorrowedBook');
  final CollectionReference userBooksCollection =
  FirebaseFirestore.instance.collection('UserBookData');


  // TODO:working fun
  // Future<void> addBorrowedBUser(BorrowedBUser user) async {
  //   try {
  //     // Create a reference to the book document
  //     final bookDocRef = borrowedBookCollection.doc(user.bookId);
  //
  //     // Check if the book document exists
  //     final bookDocSnapshot = await bookDocRef.get();
  //     if (!bookDocSnapshot.exists) {
  //       // If the book document doesn't exist, create it with the bookId field
  //       await bookDocRef.set({
  //         'bookId': user.bookId,
  //         'book_Name':user.book_name,
  //       });
  //     }
  //
  //     // Add the user document to the nested collection under the book document
  //     await bookDocRef.collection('Users').doc(user.userId).set({
  //       'userId': user.userId,
  //       'user_name': user.user_name,
  //       'bookId': user.bookId,
  //       'issuedDate': user.issuedDate,
  //       'dueDate': user.dueDate,
  //     });
  //   } catch (e) {
  //     print('Error adding borrowed user: $e');
  //     // Handle the error accordingly
  //   }
  // }//fun end


  // working test
  Future<void> addBorrowedBUser(BorrowedBUser user) async {
    try {
      // Create a reference to the book document
      final bookDocRef = borrowedBookCollection.doc(user.bookId);
      final userBookDocRef = userBooksCollection.doc(user.userId);

      // [book]Check if the book document exists
      final bookDocSnapshot = await bookDocRef.get();
      if (!bookDocSnapshot.exists) {
        // If the book document doesn't exist, create it with the bookId field
        await bookDocRef.set({
          'bookId': user.bookId,
          'book_Name':user.book_name,
        });
      }

      //[Book] Add the user document to the nested collection under the book document
      await bookDocRef.collection('Users').doc(user.userId).set({
        'userId': user.userId,
        'user_name': user.user_name,
        'bookId': user.bookId,
        'issuedDate': user.issuedDate,
        'dueDate': user.dueDate,
      });

      //Users book adding

      // [User]Check if the user book document exists
      final userBookDocSnapshot = await userBookDocRef.get();
      if (!userBookDocSnapshot.exists) {
        // If the book document doesn't exist, create it with the userID field
        await userBookDocRef.set({
          'userId': user.userId,
        });
      }

      //[User] Add the user document to the nested collection under the book document
      await userBookDocRef.collection('myBooks').doc(user.bookId).set({
        'bookId': user.bookId,
        'book_name': user.book_name,
        'dueDate': user.dueDate,
      });


    } catch (e) {
      print('Error adding borrowed user: $e');
      // Handle the error accordingly
    }
  }//fun end
}



//TODO:WORKINMG
// class BorrowedBookClassFb {
//   final CollectionReference borrowedBookCollection =
//   FirebaseFirestore.instance.collection('BorrowedBook');
//
//   Future<void> addBorrowedBUser(BorrowedBUser user) async {
//     try {
//       // Create a reference to the book document
//       final bookDocRef = borrowedBookCollection.doc(user.bookId);
//
//       // Add the user document to the nested collection under the book document
//       await bookDocRef.collection('Users').doc(user.userId).set({
//         'userId': user.userId,
//         'bookId': user.bookId,
//         'issuedDate': user.issuedDate,
//         'dueDate': user.dueDate,
//       });
//     } catch (e) {
//       print('Error adding borrowed user: $e');
//       // Handle the error accordingly
//     }
//   }
// }
