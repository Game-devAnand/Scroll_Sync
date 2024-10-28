import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreServiceUserSpec {
  final CollectionReference userBooksCollection =
  FirebaseFirestore.instance.collection('UserBookData');

  // Future<void> addBorrowedBUser(/*BorrowedBUser user*/) async {
  //   try{
  //     final bookDocRef = userBooksCollection.doc(user.bookId);
  //
  //   }catch (e) {
  //     print('Error adding borrowed user: $e');
  //     // Handle the error accordingly
  //   }
  // }//fun end




}