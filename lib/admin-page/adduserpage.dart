import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../service_fb/data_model.dart';
import '../service_fb/firebaseservice.dart';

class StudentAddPage extends StatefulWidget {
  @override
  _StudentAddPageState createState() => _StudentAddPageState();
}

class _StudentAddPageState extends State<StudentAddPage> {
  final _nameController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _branchController = TextEditingController();
  final _passwordController = TextEditingController();
  FirestoreService firestoreUser = FirestoreService();

  String _selection = 'Student';
  late User? user;

  void _submit() {
    // Do something with the input values
    print('Name: ${_nameController.text}');
    print('Roll No: ${_rollNoController.text}');
    print('Branch: ${_branchController.text}');
    print('Selection: $_selection');
    print('Selection: ${_passwordController.text}');
  }


  void userCollectionSubmitButton() {
    // Collect user details
    user = User(
      name: _nameController.text,
      userId: _rollNoController.text,
      type: _selection,
      password: _passwordController.text,
      borrowedBooks: [],
    );

    // Add the user to Firebase
    firestoreUser.addUser(user!)
        .then((_) {
      // User added successfully
      print('User added to Firebase');
      Get.snackbar('Success', 'User data Added');
      // Reset form values
      _nameController.clear();
      _rollNoController.clear();
      _branchController.clear();
      _passwordController.clear();
      setState(() {
        user = null;
      });
    })
        .catchError((error) {
      // Error occurred while adding the user
      print('Error adding user to Firebase: $error');
      Get.snackbar('Error', 'User data not added');
      // Handle the error or show an error message to the user
    });
  }



  late String _selectedValue;

  void _handleDropdownChange(String value) {
    setState(() {
      _selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student/Faculty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _rollNoController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Roll No',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _branchController,
              decoration: InputDecoration(
                labelText: 'Branch',
              ),
            ),
            SizedBox(height: 20),
            MyDropDown(onChanged: _handleDropdownChange),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'password',
              ),
            ),
            ElevatedButton(
              onPressed: (){
                _submit();
                userCollectionSubmitButton();
              },
              child: Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }
}


class MyDropDown extends StatefulWidget {
  final void Function(String) onChanged;

  MyDropDown({required this.onChanged});

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  late String _selection = 'Student';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selection,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selection = newValue;
            widget.onChanged(newValue); // Invoke the callback function with the new value
          });
        }
      },
      items: const <String>['Student', 'Faculty']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
