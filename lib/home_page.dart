import 'package:flutter/material.dart';
import 'package:voice_assistant/feature_list.dart';
import 'package:voice_assistant/imagetextinput_page.dart';
import 'package:voice_assistant/pallete.dart';
import 'package:voice_assistant/textinput_page.dart';
import 'package:lottie/lottie.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(63, 75, 82, 40),
      appBar: AppBar(
        // backgroundColor: Color.fromRGBO(63, 75, 82, 40),
        centerTitle: true,
        title: const Text(
          'CHATGEM',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              fontFamily: "Cera Pro"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //bot profile image animations
            Center(
                child: Lottie.asset('assets/Animations/GreetingBot.json',
                    height: 300)),

            //suggestions title text
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10, left: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Select any one feature',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Cera Pro",
                    fontWeight: FontWeight.bold),
              ),
            ),

            //features of bot
            Column(
              children: [
                //Multi-turn chat feature
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TextInputPage()));
                  },
                  child: const FeaturelistBox(
                    textcolor: Colors.white,
                    color: Color.fromRGBO(51, 187, 187, 100),
                    headertext: "Chat with Gem",
                    descriptiontext:
                        "Aids users by generating text, enhancing conversations effectively",
                  ),
                ),

                //Image with text feature
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageTextInputPage()));
                  },
                  child: const FeaturelistBox(
                    textcolor: Colors.black,
                    color: Pallete.firstSuggestionBoxColor,
                    headertext: "Get Image Insights",
                    descriptiontext:
                        "Helps you to discover the insights of an image",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
