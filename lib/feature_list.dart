import 'package:flutter/material.dart';
import 'package:voice_assistant/pallete.dart';

class FeaturelistBox extends StatelessWidget {
  const FeaturelistBox(
      {super.key,
      required this.color,
      required this.headertext,
      required this.descriptiontext,
      required this.textcolor});
  final Color color;
  final String headertext;
  final String descriptiontext;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headertext,
                style: TextStyle(
                    color: textcolor,
                    fontFamily: "Cera Pro",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Text(
                descriptiontext,
                style: TextStyle(
                  color: textcolor,
                  fontFamily: "Cera Pro",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 25,
                    color: textcolor,
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
