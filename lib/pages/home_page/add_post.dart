import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_app/api/image_api.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  static const String route = "/add-post";

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final picker = ImagePicker();
  File? _image;
  ImageAPI imageAPI = ImageAPI();
  Uint8List? returnImage;

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
          ),
          TextButton.icon(
              onPressed: () async {
                await getImage();
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Browse")),
          if (_image != null) SizedBox(height: 150, child: Image.file(_image!)),
          ElevatedButton(
              onPressed: () async {
                var result = await imageAPI.getImage("image1651863661706.jpg");
                print(result);
                setState(() {
                  returnImage = result;
                });
              },
              child: const Text("Get photo")),
          TextButton(
              onPressed: () async {
                // final stringImg = await imageAPI.fetch();
                // setState(() {
                //   returnImage = stringImg;
                // });
              },
              child: const Text("Get Image")),
          if (returnImage != null)
            SizedBox(height: 150, child: Image.memory(returnImage!))
        ],
      ),
    );
  }
}
