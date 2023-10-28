import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive02/Screen/HomeScreen.dart';
import 'package:hive02/functions/dbFunction.dart';
import 'package:hive02/model/dataModel.dart';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  final String name;
  final String age;
  final String number;
  final String address;
  final String image;
  final int index;

  const EditScreen({
    Key? key, // Use 'Key' type, not 'super.key'
    required this.name,
    required this.age,
    required this.number,
    required this.address,
    required this.image,
    required this.index,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _classController = TextEditingController();
  final _addressController = TextEditingController();
  final _imagecontroller = ImagePicker();
  File? selectImage; // Renamed to follow naming conventions
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _ageController.text = widget.age;
    _classController.text = widget.number;
    _addressController.text = widget.address;
    // Set 'selectImage' based on 'widget.image'
    selectImage = widget.image != null ? File(widget.image) : null;
  }

  Future<void> updateStudent(int index) async {
    final studentDb = await Hive.openBox<StudentModel>("student_db");

    if (index >= 0 && index < studentDb.length) {
      final updatedStudent = StudentModel(
          name: _nameController.text,
          age: _ageController.text,
          number: _classController.text,
          address: _addressController.text,
          image: selectImage!.path);

      await studentDb.putAt(index, updatedStudent);

      // You should call 'getAllStudent' to update the student data.
      // For now, I assume it's an async method.
      await getAllStudent();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Student'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        updateimage(ImageSource.camera);
                                      },
                                      child: Text("Camera"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        updateimage(ImageSource.gallery);
                                      },
                                      child: Text("gallery"),
                                    )
                                  ],
                                ),
                              ));
                    },
                    child: CircleAvatar(
                      radius: 50,
                      child: selectImage == null
                          ? Icon(Icons.add_a_photo)
                          : ClipOval(
                              child: Image.file(
                              selectImage!,
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120,
                            )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Name";
                      }
                      return null;
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Age";
                      }
                      return null;
                    },
                    controller: _ageController,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        labelText: "Age",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Number";
                      }
                      return null;
                    },
                    controller: _classController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    decoration: InputDecoration(
                        prefixText: "+91",
                        labelText: "Phone",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Address";
                      }
                      return null;
                    },
                    controller: _addressController,
                    decoration: InputDecoration(
                        labelText: "Address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateStudent(widget.index);
                      }
                    },
                    child: Text("Update"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateimage(ImageSource source) async {
    final image = await _imagecontroller.pickImage(source: source);
    setState(() {
      selectImage = File(image!.path);
    });
    Navigator.pop(context);
  }
}
