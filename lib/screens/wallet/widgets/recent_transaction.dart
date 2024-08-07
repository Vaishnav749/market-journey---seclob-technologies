import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../resources/color.dart';

class recenttransation extends StatefulWidget {
  const recenttransation({super.key});

  @override
  State<recenttransation> createState() => _recenttransationState();
}

class _recenttransationState extends State<recenttransation> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 80,
              width: 300,
              decoration: BoxDecoration(
                  color: bluem, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/wallet.svg',
                      fit: BoxFit.none,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lachu",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: marketbg),
                        ),
                        Text(
                          "first level",
                          style: TextStyle(fontSize: 12, color: whitegray),
                        ),
                        Text(
                          "20-07-2024",
                          style: TextStyle(fontSize: 12, color: whitegray),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "₹1000",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: marketbg),
                        ),
                        Container(
                          height: 15,
                          width: 55,
                          decoration: BoxDecoration(
                              color: greenbg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            "Accepted",
                            style: TextStyle(fontSize: 8),
                          )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
