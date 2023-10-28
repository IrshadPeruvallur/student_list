import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive02/Screen/addDetails.dart';
import 'package:hive02/Screen/editScreen.dart';
import 'package:hive02/model/dataModel.dart';
import '../functions/dbFunction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchcontroller = TextEditingController();
  List<StudentModel> studentList = [];
  List<StudentModel> filteredStudentList = [];
  bool isSearching = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllStudent();
  }

  void filterStudents(String search) {
    if (search.isEmpty) {
      // If the search query is empty, show all students.
      setState(() {
        filteredStudentList = List.from(studentList);
      });
    } else {
      setState(() {
        filteredStudentList = studentList
            .where((student) =>
                student.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: isSearching ? buildSearchField() : Text("Student List"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    // Clear the search query and show all students.
                    searchcontroller.clear();
                    filteredStudentList = List.from(studentList);
                  }
                });
              },
              icon: Icon(isSearching ? Icons.cancel : Icons.search),
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: studentListNotifier,
          builder: (context, List<StudentModel> studentList, child) =>
              ListView.separated(
            itemBuilder: (context, index) {
              final data = studentList[index];
              return ListTile(
                title: Text(
                  data.name,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.number),
                    Text(data.age),
                    Text(data.address),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditScreen(
                                  name: data.name,
                                  age: data.age,
                                  number: data.number,
                                  address: data.address,
                                  image: data.image,
                                  index: index)),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteStudent(index);
                      },
                      icon: Icon(Icons.delete_rounded),
                    ),
                  ],
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: FileImage(File(data.image)),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: studentList.length,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDetails(),
                ));
          },
          child: Icon(Icons.person_add),
        ));
  }

  Widget buildSearchField() {
    return TextField(
      controller: searchcontroller,
      onChanged: (query) {
        filterStudents(query);
      },
      autofocus: true,
      style: TextStyle(
        color: Colors.white, // Set the text color to white
      ),
      decoration: InputDecoration(
        hintText: "Search students...",
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.7), // Set the hint text color
        ),
        border: InputBorder.none,
      ),
    );
  }
}
