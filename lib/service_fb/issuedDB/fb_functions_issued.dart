// import 'package:cloud_firestore/cloud_firestore.dart';
//
// // Function to add data to Firestore collection
// Future<void> addDataToFirestore(String id, DateTime date, String book, List<String> userList) async {
//   try {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//     // Create a new document in the "issuedBook" collection with the provided data
//     await firestore.collection('issuedBook').add({
//       'ID': id,
//       'date': date,
//       'book': book,
//       'usersList': userList,
//     });
//
//     print('Data added successfully!');
//   } catch (error) {
//     print('Error adding data to Firestore: $error');
//   }
// }
//
// // Function to retrieve data from Firestore collection
// Future<List<Map<String, dynamic>>> retrieveDataFromFirestore() async {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   try {
//     // Get all documents from the "issuedBook" collection
//     QuerySnapshot querySnapshot = await firestore.collection('issuedBook').get();
//
//     // Convert each document into a map and store them in a list
//     List<Map<String, dynamic>> dataList = querySnapshot.docs.map((doc) => doc.data()).toList();
//
//     return dataList;
//   } catch (error) {
//     print('Error retrieving data from Firestore: $error');
//     return [];
//   }
// }
