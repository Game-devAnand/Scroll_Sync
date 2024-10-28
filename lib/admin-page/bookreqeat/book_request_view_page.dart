import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scrollsync/admin-page/bookreqeat/request_detailed_view.dart';
import 'package:scrollsync/service_fb/requst.dart';

class AdminRequestBookViewPage extends StatefulWidget {
  const AdminRequestBookViewPage({Key? key}) : super(key: key);

  @override
  State<AdminRequestBookViewPage> createState() => _AdminRequestBookViewPageState();
}

class _AdminRequestBookViewPageState extends State<AdminRequestBookViewPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
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
class RequestBookModelView{
  String u_name;
  String b_name;
  String u_id;
  String borrowedBooksNO;
  String authorName;
  DateTime issuedDate;
  String bookId;
  String stocks;

  RequestBookModelView({
    required this.b_name,
    required this.u_name,
    required this.u_id,
    required this.borrowedBooksNO,
    required this.authorName,
    required this.issuedDate,
    required this.bookId,
    required this.stocks,
  });
  // Optional: Add a factory method to create a Book object from a Firestore document snapshot
  factory RequestBookModelView.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return RequestBookModelView(
      authorName: data['authorName'],
      issuedDate: data['issuedDate'].toDate(),
      bookId: data['bookId'],
      stocks: data['stocks'],
      b_name: data['b_name'],
      u_name: data['u_name'],
      u_id: data['u_id'],
      borrowedBooksNO: data['borrowedBooks'],
    );
  }
}


//load data and return list
Stream<List<RequestBookModelView>> fetchBooks(String searchTerm) {
  return FirebaseFirestore.instance
      .collection('request')
      .where('b_name', isGreaterThanOrEqualTo: searchTerm)
      .snapshots()
      .map((QuerySnapshot querySnapshot) {
    List<RequestBookModelView> requestbookList = [];

    querySnapshot.docs.forEach((doc) {
      RequestBookModelView book = RequestBookModelView.fromSnapshot(doc);
      requestbookList.add(book);
    });
    print(requestbookList[0].u_name);
    print(requestbookList[0].u_name);
    print(requestbookList[0].u_name);
    print(requestbookList[0].u_name);
    return requestbookList;
  });
}



//



//BookListBuilder
class BookListBuilder extends StatelessWidget {
  final TextEditingController searchController;

  const BookListBuilder({required this.searchController});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RequestBookModelView>>(
      stream: fetchBooks(searchController.text),
      builder: (BuildContext context, AsyncSnapshot<List<RequestBookModelView>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No books found');
        }

        List<RequestBookModelView> bookList = snapshot.data!;

        return ListView.builder(
          itemCount: bookList.length,
          itemBuilder: (context, index) {
            RequestBookModelView rbook = bookList[index];
            print('>>>>> name ${rbook.b_name}');
            return ListTile(
              title: Text(rbook.b_name),
              subtitle: Text('requested by : ${rbook.u_id}'),
              trailing: ElevatedButton(
                onPressed: () {
                  print('>>>>> name ${rbook.b_name}');
                  Get.to(() => RequestDetailCard(rbook: rbook));

                },
                child: const Text('View'),
              ),
              // Display other rbook properties as needed
            );
          },
        );
      },
    );
  }
}
