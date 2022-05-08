import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/api/post_api.dart';
import 'package:testing_app/models/auth_model.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  static const String route = "/add-post";

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _picker = ImagePicker();
  File? _image;
  final PostAPI _postAPI = PostAPI();
  // final ImageAPI _imageAPI = ImageAPI();
  Uint8List? _returnImage;
  bool _wts = false;
  bool _wtt = false;
  bool _includePos = false;
  final List<String> _category = [];

  Future<void> getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
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
      child: ListView(
        children: [
          const Text("Add Post"),
          const Text("Title"),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter title";
                }
                return null;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                  hintText: 'Enter your post title'),
            ),
          ),
          CheckboxListTile(
            title: const Text("WTS"),
            value: _wts,
            onChanged: (_) {
              setState(() {
                _wts = !_wts;
                if (_wts) {
                  _category.add("WTS");
                } else {
                  _category.remove("WTS");
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
              title: const Text("WTT"),
              value: _wtt,
              onChanged: (_) {
                setState(() {
                  _wtt = !_wtt;
                  if (_wtt) {
                    _category.add("WTT");
                  } else {
                    _category.remove("WTT");
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _priceController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter price";
                }
                return null;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price',
                  hintText: 'Enter your price'),
            ),
          ),
          CheckboxListTile(
              title: const Text("Include Postage"),
              value: _includePos,
              onChanged: (_) {
                setState(() {
                  _includePos = !_includePos;
                });
              },
              controlAffinity: ListTileControlAffinity.leading),
          TextButton.icon(
              onPressed: () async {
                await getImage();
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload Image")),
          if (_image != null) SizedBox(height: 150, child: Image.file(_image!)),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && _image != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Posting data...')));
                  final group = ["BlankPink", "RedVelvet"];
                  Map<String, dynamic> post = {
                    "imageName": basename(_image!.path.toString()),
                    "category": _category,
                    "title": _titleController.text,
                    "creator": Provider.of<AuthModel>(context, listen: false)
                        .getCurrentUser
                        .id,
                    "price": "RM" + _priceController.text,
                    "isIncludePos": _includePos.toString(),
                    "group": group
                  };

                  _postAPI.createPost(post, _image!);
                }
              },
              child: const Text("Add Post")),
          if (_returnImage != null)
            SizedBox(height: 150, child: Image.memory(_returnImage!))
        ],
      ),
    );
  }
}
