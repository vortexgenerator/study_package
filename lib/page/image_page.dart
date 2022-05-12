import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('ImagePage')),
        body: Column(children: [
          ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                // Pick an image
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    _image = File(image.path);
                  });
                }
              },
              child: const Text('Image 불러오기')),
          _image == null ? const Text('empty image') : Image.file(_image!)
        ]));
  }
}
