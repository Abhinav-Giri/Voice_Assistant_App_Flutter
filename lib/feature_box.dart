import 'package:flutter/material.dart';

class Feature extends StatelessWidget {
  final Color color;
  final String headerText;
  final String contentText;
  const Feature({
    super.key,
    required this.color,
    required this.contentText,
    required this.headerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 18.0).copyWith(left: 15),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  headerText,
                  style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  contentText,
                  style: TextStyle(
                    fontFamily: 'Cera Pro',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
