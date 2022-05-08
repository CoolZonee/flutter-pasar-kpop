import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class ImageAPI {
  upload(File imageFile) async {
    // open a bytestream
    final stream = http.ByteStream(DelegatingStream(imageFile.openRead()));

    // get file length
    final length = await imageFile.length();

    // string to uri
    final uri = Uri.parse("http://192.168.100.3:5000/images/upload");

    // create multipart request
    final request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    final multiPartFile = http.MultipartFile('img', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multiPartFile);

    // send
    final response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {});
  }

  Future<dynamic> getImage(String imageName) async {
    final response = await http
        .get(Uri.parse("http://192.168.100.3:5000/images/" + imageName));
    return response.bodyBytes;
  }
}
