import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrollsync/service_fb/data_model.dart';
import 'package:scrollsync/service_fb/requst.dart';
import 'package:provider/provider.dart';

import '../admin-page/userView/user_list_view_page.dart';
import '../user_specific_borrowed_book_data/usreSpesificBookView.dart';

class UserEnteryPage extends StatefulWidget {
  UserEnteryPage({Key? key}) : super(key: key);

  @override
  State<UserEnteryPage> createState() => _UserEnteryPageState();
}

class _UserEnteryPageState extends State<UserEnteryPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library App'),
      ),
      drawer: Sidebar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ValueListenableBuilder(
              valueListenable: searchController,
              builder: (context, value, _) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(
                          () {}); // Trigger a rebuild when the search term changes
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: BookListBuilder(searchController: searchController),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
    );
  }
}

//side bar
class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<UserProvider>(
                  builder: (contex, value, child) => Text(
                    '${value.appUser?.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer<UserProvider>(
            builder: (context, value, child) => ListTile(
              title: Text('My Books'),
              onTap: () {
                Get.to(UserBorrowedBookView(
                  id: '${value.appUser?.userId}',
                ));
              },
            ),
          ),
          ListTile(
            title: Text('Alerts'),
            onTap: () {
              // Handle Alerts item tap
            },
          ),
          ListTile(
            title: Text('Account'),
            onTap: () {
              // Handle Account item tap
            },
          ),
        ],
      ),
    );
  }
}

//book
class BookNew {
  String name;
  String authorName;
  DateTime issuedDate;
  String bookId;
  String stocks;

  BookNew({
    required this.name,
    required this.authorName,
    required this.issuedDate,
    required this.bookId,
    required this.stocks,
  });

  // Optional: Add a factory method to create a Book object from a Firestore document snapshot
  factory BookNew.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return BookNew(
      name: data['name'],
      authorName: data['authorName'],
      issuedDate: data['issuedDate'].toDate(),
      bookId: data['bookId'],
      stocks: data['stocks'],
    );
  }
}

//load data and return list
Stream<List<BookNew>> fetchBooks(String searchTerm) {
  return FirebaseFirestore.instance
      .collection('books')
      .where('name', isGreaterThanOrEqualTo: searchTerm)
      .snapshots()
      .map((QuerySnapshot querySnapshot) {
    List<BookNew> bookList = [];

    querySnapshot.docs.forEach((doc) {
      BookNew book = BookNew.fromSnapshot(doc);
      bookList.add(book);
    });

    return bookList;
  });
}

//

//BookListBuilder
class BookListBuilder extends StatefulWidget {
  final TextEditingController searchController;

  const BookListBuilder({required this.searchController});

  @override
  _BookListBuilderState createState() => _BookListBuilderState();
}

class _BookListBuilderState extends State<BookListBuilder> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BookNew>>(
      stream: fetchBooks(widget.searchController.text),
      builder: (BuildContext context, AsyncSnapshot<List<BookNew>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No books found');
        }

        List<BookNew> bookList = snapshot.data!;

        return ListView.builder(
          itemCount: bookList.length,
          itemBuilder: (context, index) {
            BookNew book = bookList[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RequestBook(book: book);
                  },
                );
              },
              child: ListTile(
                tileColor: _selectedIndex == index ? Colors.grey[400] : null,
                selectedTileColor: Colors.green,
                title: Text(book.name),
                subtitle: Text('by: ${book.authorName}'),
                // Display other book properties as needed
              ),
            );
          },
        );
      },
    );
  }
}

//RequestBook
class RequestBook extends StatefulWidget {
  final BookNew book;

  RequestBook({required this.book, Key? key}) : super(key: key);

  @override
  State<RequestBook> createState() => _RequestBookState(subBook: book);
}

class _RequestBookState extends State<RequestBook> {
  late BookNew subBook;

  RequestClass requestBook = RequestClass();

  _RequestBookState({required BookNew subBook}) {
    this.subBook = subBook;
  }

  @override
  void initState() {
    super.initState();
    subBook = widget.book;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Request"),
      content: const Text("Do you want to request this book?"),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            User2? appUser =
                Provider.of<UserProvider>(context, listen: false).appUser;
            requestBook.addBook(nbook: subBook, appUser: appUser);
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
