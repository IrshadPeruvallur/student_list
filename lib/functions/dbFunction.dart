import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive02/model/dataModel.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

Future<void> addStudent(StudentModel value) async {
  final studentDB = await Hive.openBox<StudentModel>("student_db");
  await studentDB.add(value);
  // value.id = _id;
  // studentListNotifier.value.add(value);
  // studentListNotifier.notifyListeners();
  getAllStudent();
}

Future<void> getAllStudent() async {
  final studentDB = await Hive.openBox<StudentModel>("student_db");
  studentListNotifier.value.clear();
  studentListNotifier.value.addAll(studentDB.values);
  studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(int index) async {
  final studentDB = await Hive.openBox<StudentModel>("student_db");
  await studentDB.deleteAt(index);
  getAllStudent();
}
