import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive02/Screen/HomeScreen.dart';
import 'package:hive02/functions/dbFunction.dart';
import 'package:hive02/model/dataModel.dart';

class AddDetails extends StatefulWidget {
  AddDetails({Key? key}) : super(key: key);

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _classController = TextEditingController();
  final _addressController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _pickedImage;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AddDetails"),
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
                  onTap: () => _showImageSourceDialog(),
                  child: CircleAvatar(
                    radius: 50,
                    child: _pickedImage == null
                        ? Icon(Icons.add_a_photo)
                        : ClipOval(
                            child: Image.file(
                              _pickedImage!,
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _buildTextField(
                  controller: _nameController,
                  label: "Name",
                ),
                SizedBox(
                  height: 25,
                ),
                _buildTextField(
                  controller: _ageController,
                  label: "Age",
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 5,
                ),
                _buildTextField(
                  controller: _classController,
                  label: "Phone",
                  prefixText: "+91",
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
                SizedBox(
                  height: 5,
                ),
                _buildTextField(
                  controller: _addressController,
                  label: "Address",
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _addStudentButtonClicked(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                        }
                      },
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a text field with common properties
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String prefixText = "",
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: [
        if (keyboardType == TextInputType.phone)
          FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _addStudentButtonClicked(BuildContext context) {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final phoneNumber = _classController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || age.isEmpty || phoneNumber.isEmpty || address.isEmpty) {
      return;
    }

    final student = StudentModel(
      name: name,
      age: age,
      number: phoneNumber,
      image: _pickedImage?.path ?? "",
      address: address,
    );

    addStudent(student);
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text("Camera"),
            ),
            TextButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text("Gallery"),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
    Navigator.pop(context);
  }
}
