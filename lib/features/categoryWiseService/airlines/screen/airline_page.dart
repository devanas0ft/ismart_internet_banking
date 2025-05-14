import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/screen/search_flight_screen.dart';

class AirlinesIntroPage extends StatelessWidget {
  // final String cashbackAmount;

  final ServiceList service;

  const AirlinesIntroPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/images/book your flight-min.png"),
            const Column(
              children: [
                Text(
                  "Book Your Flight",
                  style: TextStyle(fontFamily: "popinbold", fontSize: 26),
                ),
                Text(
                  "Book airplane tickets in a convenient manner.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "popinmedium",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF989898),
                  ),
                ),
              ],
            ),
            CustomRoundedButtom(
              title: "Get Started",
              onPressed: () {
                NavigationService.pop();
                NavigationService.push(
                  target: SearchFlightScreen(service: service),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
