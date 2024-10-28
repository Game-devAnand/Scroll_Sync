import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_book.dart';



class AdminBookViewPage extends StatefulWidget {
  const AdminBookViewPage({Key? key}) : super(key: key);

  @override
  State<AdminBookViewPage> createState() => _AdminBookViewPageState();
}

class _AdminBookViewPageState extends State<AdminBookViewPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child:ValueListenableBuilder(
              valueListenable: searchController,
              builder: (context, value, _) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {}); // Trigger a rebuild when the search term changes
                    },
                  ),
                );
              },
            ),

          ),
          Expanded(
            child:BookListBuilder(searchController: searchController),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const <Widget>[
              SizedBox(height: 20,)
            ],
          ),
        ],
      ),
    );
  }
}

//book
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

  // Optional: Add a factory method to create a Book object from a Firestore document snapshot
  factory Book.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Book(
      name: data['name'],
      authorName: data['authorName'],
      issuedDate: data['issuedDate'].toDate(),
      bookId: data['bookId'],
      stocks: data['stocks'],
    );
  }
}


//load data and return list
Stream<List<Book>> fetchBooks(String searchTerm) {
  return FirebaseFirestore.instance
      .collection('books')
      .where('name', isGreaterThanOrEqualTo: searchTerm)
      .snapshots()
      .map((QuerySnapshot querySnapshot) {
    List<Book> bookList = [];

    querySnapshot.docs.forEach((doc) {
      Book book = Book.fromSnapshot(doc);
      bookList.add(book);
    });

    return bookList;
  });
}



//



//BookListBuilder
class BookListBuilder extends StatelessWidget {
  final TextEditingController searchController;

  const BookListBuilder({required this.searchController});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Book>>(
      stream: fetchBooks(searchController.text),
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No books found');
        }

        List<Book> bookList = snapshot.data!;

        return ListView.builder(
          itemCount: bookList.length,
          itemBuilder: (context, index) {
            Book book = bookList[index];
            return ListTile(
              title: Text(book.name),
              subtitle: Text('by : ${book.authorName}'),
              trailing: ElevatedButton(
                onPressed: () {
                  Get.to(EditBookForm(book: book,));
                },
                child: Text('Edit'),
              ),
              // Display other book properties as needed
            );
          },
        );
      },
    );
  }
}
