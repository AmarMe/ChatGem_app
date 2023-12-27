import 'dart:convert';
import 'dart:io';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageTextInputPage extends StatefulWidget {
  const ImageTextInputPage({super.key});

  @override
  State<ImageTextInputPage> createState() => _ImageTextInputPageState();
}

class _ImageTextInputPageState extends State<ImageTextInputPage> {
  TextEditingController _textController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  String _generatedText = '';
  bool isloading = false;

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await uploadImage();
    }
  }

  Future<String> uploadImage() async {
    final url = Uri.parse('http://192.168.0.5:5000/routes/add-image');

    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('img', _image!.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['path']);
        return responseData['path']; // Retrieve the path to the uploaded image
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (error) {
      print('Error uploading image: $error');
      throw Exception('Failed to upload image');
    }
  }

  Future<void> generateText() async {
    String textInput = _textController.text;

    if (_image == null) {
      print('No image selected');
      return;
    }

    setState(() {
      isloading = true;
    });

    try {
      final url = Uri.parse('http://192.168.0.5:5000/generateText');

      final requestBody = {
        'textInput': textInput,
        // Remove 'imagePath' as the server code directly reads the image from the uploads directory
      };

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _generatedText = responseData['generatedText'];
          isloading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        print(response.body);
        // Handle error
      }
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image with Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Enter text input'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await pickImageFromGallery();
              },
              child: const Text('Pick Image',
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            const SizedBox(height: 20),
            _image != null
                ? Expanded(
                    child: Image.file(_image!),
                  )
                : const Text('No image selected'),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () async {
            //     if (_textController.text.isNotEmpty) {
            //       await generateText();
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           content: Text('Please enter some text about the image.'),
            //         ),
            //       );
            //     }
            //   },
            //   child: const Text('Generate Text'),
            // ),

            // ElevatedButton(
            //     onPressed: () async {
            //       await uploadImage();
            //     },
            //     child: Text('upload image')),

            ElevatedButton(
              onPressed: () async {
                if (_textController.text.isNotEmpty) {
                  await generateText();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter some text about the image.'),
                    ),
                  );
                }
              },
              child: const Text('Generate Text',
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            const SizedBox(height: 20),
            isloading
                ? const Center(child: CircularProgressIndicator())
                : _generatedText.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Text(_generatedText,
                              style: TextStyle(fontSize: 18)),
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
