import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EachBankHelper extends StatelessWidget {
  final String img;
  final String title;
  final Widget body;

  const EachBankHelper(
    this.img,
    this.title,
    this.body, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon(icon, color: Color(0xff010c80)),
              SvgPicture.asset(
                img,
                width: 20,
                height: 20,
                color: Color(0xff010c80),
              ),
              SizedBox(width: 10),
              Text(title, style: TextStyle(fontSize: 16)),
              SizedBox(width: 10),
            ],
          ),

          Padding(padding: const EdgeInsets.only(left: 30.0), child: body),
        ],
      ),
    );
  }
  }
