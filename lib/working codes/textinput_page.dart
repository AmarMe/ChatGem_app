import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voice_assistant/customUI/ownmessage_card.dart';
import 'package:voice_assistant/customUI/replymessage_card.dart';
import 'dart:convert';

import 'package:voice_assistant/model/messagemodel.dart';

class TextInputPage1 extends StatefulWidget {
  const TextInputPage1({super.key});

  @override
  State<TextInputPage1> createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage1> {
  final TextEditingController _textController = TextEditingController();
  String generatedText = '';
  bool isLoading = false;
  bool sendbutton = false;
  ScrollController scrollController = ScrollController();
  List<Messagemodel> messages = [];

  void sendmessage(String message) {
    setmessage("source", message);
    print(messages[messages.length - 1].message);
  }

  void setmessage(String type, String message) {
    Messagemodel messagemodel = Messagemodel(
        type: type, message: message, time: DateTime.now().toString());
    setState(() {
      messages.add(messagemodel);
    });
  }

  Future<void> generateText() async {
    String textInput = _textController.text;

    final Map<String, String> requestBody = {
      'textInput': textInput,
    };

    if (textInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter some questions!")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://192.168.43.54:5000/generatethetext/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          generatedText = responseData['generatedText'];

          setmessage("target", generatedText);
          isLoading = false;
          print(generatedText);
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          './assets/images/whatsapp_background.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Generate Text'),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: messages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == messages.length) {
                            return Container(height: 50);
                          }
                          if (messages[index].type == "source") {
                            return OwnMessageCard(
                                message: messages[index].message.toString(),
                                time: messages[index]
                                    .time
                                    .toString()
                                    .substring(10, 16));
                          } else {
                            return ReplyMessageCard(
                                message: messages[index].message.toString(),
                                time: messages[index]
                                    .time
                                    .toString()
                                    .substring(10, 16));
                          }
                        })),

                /////////textfield and send button

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: Card(
                          margin: const EdgeInsets.only(
                              left: 5, right: 2, bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _textController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              onChanged: (value) {
                                if (value.length > 0) {
                                  setState(() {
                                    sendbutton = true;
                                  });
                                } else {
                                  setState(() {
                                    sendbutton = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type a message'),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (sendbutton) {
                              scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                            }
                            sendmessage(_textController.text);
                            generateText();
                            _textController.clear();
                          },
                          icon: Icon(Icons.send))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
