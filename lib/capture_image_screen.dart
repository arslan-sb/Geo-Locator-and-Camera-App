import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CaptureImageScreen extends StatefulWidget {
  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  File? _image;

  Future<void> _captureImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
    await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final File savedImage = await File(image.path).copy(
          '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.png');
      setState(() {
        _image = savedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Capture Image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(_image!, height: 300, width: 300, fit: BoxFit.cover)
            else
              Text("No image captured."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _captureImage,
              child: Text("Capture Image"),
            ),
          ],
        ),
      ),
    );
  }
}
