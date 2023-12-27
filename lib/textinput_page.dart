import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voice_assistant/customUI/ownmessage_card.dart';
import 'package:voice_assistant/customUI/replymessage_card.dart';
import 'dart:convert';

import 'package:voice_assistant/model/messagemodel.dart';

class TextInputPage extends StatefulWidget {
  const TextInputPage({super.key});

  @override
  State<TextInputPage> createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  final TextEditingController _textController = TextEditingController();
  String generatedText = '';
  bool isLoading = false;
  bool sendbutton = false;
  ScrollController scrollController = ScrollController();
  List<Messagemodel> messages = [];

  // String chatHistory = '';

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

  List<Map<String, dynamic>> chatHistory = []; // Initialize chat history

  Future<void> generateText() async {
    String userMessage = _textController.text;

    if (userMessage.isEmpty) {
      print("Enter some text from user");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://chatgem.onrender.com/generatethetext');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'history': chatHistory, // Send the chat history to the server
          'userInput': userMessage, // Send the user input to the server
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('generatedText')) {
          String generatedText = responseData['generatedText'];
          setState(() {
            setmessage("target", generatedText);
            print(generatedText);
          });

          // Update chat history with received updated history from the server
          if (responseData.containsKey('updatedHistory')) {
            List<dynamic> updatedChatHistory = responseData['updatedHistory'];
            setState(() {
              chatHistory = List<Map<String, dynamic>>.from(updatedChatHistory);
            });
            // print(chatHistory); // Process updated chat history
          }
        } else {
          print('Invalid response format');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        print(response.body);
        // Handle error
      }
    } catch (error) {
      print('Error: $error');
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image.asset(
        //   './assets/images/whatsapp_background.png',
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   fit: BoxFit.cover,
        // ),
// Gradient.linear(Alignment.topCenter, Alignment.bottomCenter, const Color.fromRGBO(63, 75, 82, 100))
        Scaffold(
          // backgroundColor: Gradient.linear(Alignment.topCenter, Alignment.bottomCenter, const Color.fromRGBO(63, 75, 82, 100)),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(51, 187, 187, 100),
            title: const Text(
              'CHATGEM',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  fontFamily: "Cera Pro"),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(63, 75, 82, 40),
                Color.fromRGBO(1, 6, 15, 20)
              ],
            )),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: messages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == messages.length) {
                            return Container(height: 70);
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 70,
                        child: Card(
                          color: Color.fromRGBO(43, 49, 56, 100),
                          margin: const EdgeInsets.only(left: 6, bottom: 8),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromRGBO(51, 187, 187, 100)),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 8, bottom: 8),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
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
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type a message',
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 150))),
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
                          icon: Icon(Icons.send, color: Colors.white))
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
