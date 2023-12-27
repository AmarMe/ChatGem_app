import 'package:flutter/material.dart';

class ReplyMessageCard extends StatelessWidget {
  const ReplyMessageCard(
      {super.key, required this.message, required this.time});
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Color.fromRGBO(6, 247, 44, 130)),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(19),
                  bottomLeft: Radius.circular(19),
                  bottomRight: Radius.circular(19))),
          color: Color.fromRGBO(78, 82, 87, 150),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Stack(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 12, bottom: 20, left: 15, right: 60),
                child: Text(
                  message,
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: "Cera Pro",
                      color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  time,
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Cera Pro",
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
