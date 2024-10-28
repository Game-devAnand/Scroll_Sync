import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_user.dart';

class AdminUserViewPage extends StatefulWidget {
  const AdminUserViewPage({Key? key}) : super(key: key);

  @override
  State<AdminUserViewPage> createState() => _AdminUserViewPageState();
}

class _AdminUserViewPageState extends State<AdminUserViewPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    print("Admin user view");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder(
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
            //child: UserListBuilder(searchController: searchController),
            child: UserListBuilder(searchController: searchController,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(height: 20,)
            ],
          ),
        ],
      ),
    );
  }
}

// User class
class User2 {
  String name;
  String userId;
  String type;
  String password;
  //TODO Book to string
  List<Book> borrowedBooks;

  User2({
    required this.name,
    required this.userId,
    required this.type,
    required this.password,
    required this.borrowedBooks,
  });

  // Optional: Add a factory method to create a User object from a Firestore document snapshot
  // factory User2.fromSnapshot(DocumentSnapshot snapshot) {
  //   print(">>>> from snapshot");
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   return User2(
  //     name: data['name'],
  //     userId: data['userId'],
  //     type: data['type'],
  //     password: data['password'],
  //     borrowedBooks: List<Book>.from(
  //       data['borrowedBooks'].map((bookData) => Book.fromMap(bookData)),
  //     ),
  //   );
  // }


  factory User2.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return User2(
      name: data?['name'] ?? '', // Set a default value when 'name' is null
      userId: data?['userId'] ?? '', // Set a default value when 'userId' is null
      type: data?['type'] ?? '', // Set a default value when 'type' is null
      password: data?['password'] ?? '', // Set a default value when 'password' is null
      borrowedBooks: (data?['borrowedBooks'] ?? []).map<Book>((bookData) => Book.fromMap(bookData)).toList(),
    );
  }


}

//Load data and return list
Stream<List<User2>> fetchUsers(String searchTerm) {
  print(">>>>fetch user fun");
  return FirebaseFirestore.instance
      .collection('users')
      .where('name', isGreaterThanOrEqualTo: searchTerm)
      .snapshots()
      .map((QuerySnapshot querySnapshot) {
    print(">>>> maped querySnapshot");
    List<User2> userList = [];

    for (var doc in querySnapshot.docs) {
      try{
        print(">>>> inside querySnapshot.docs.forEach");
        print("name from doc of fromShapshot :${User2.fromSnapshot(doc).name}");
        print(">>>> inside querySnapshot.docs.forEach");
        print("doc id: ${doc.id}");
        print("doc data: ${doc.data()}");
        User2 user = User2.fromSnapshot(doc);
        print(user.name);
        print(user.userId);
        print(user.password);
        print(user.borrowedBooks);
        print(user.borrowedBooks.length);
        print(user.type);
        print("=============end=====");
        userList.add(user);
      }
      catch(e){
        print("error in loop : ${e}");
      }
    }

    return userList;
  });
}




//first build
// UserListBuilder
class UserListBuilder extends StatelessWidget {
  final TextEditingController searchController;

  const UserListBuilder({required this.searchController});

  @override
  Widget build(BuildContext context) {
    print("Stream builder");
    return StreamBuilder<List<User2>>(
      stream: fetchUsers(searchController.text),
      builder: (BuildContext context, AsyncSnapshot<List<User2>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No users found');
        }

        List<User2> userList = snapshot.data!;

        return ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            User2 user = userList[index];
            return ListTile(
              title: Text(' ${user.name}'),
              subtitle: Text('User ID: ${user.userId}'),
              trailing: ElevatedButton(
                onPressed: () {
                  print(user.userId);
                  Get.to(EditUserForm(user: user,));
                },
                child: const Text('Edit'),
              ),
              // Display other user properties as needed
            );
          },
        );
      },
    );
  }
}

/*
*             print(user.name);
            print(user.userId);
            print(user.password);
            print(user.borrowedBooks);
            print(user.type);
            print("=============end=====");
* 
* 
* */



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


  // Optional: Add a factory method to create a Book object from a map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      name: map['name'],
      authorName: map['authorName'],
      issuedDate: (map['issuedDate'] as Timestamp).toDate(),
      bookId: map['bookId'],
      stocks: map['stocks'],
    );
  }

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
