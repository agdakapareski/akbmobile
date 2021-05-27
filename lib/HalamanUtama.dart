import 'dart:async';

import 'package:akb/PesanMenu.dart';
import 'package:flutter/material.dart';

class HalamanUtama extends StatefulWidget {
  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PesanMenu())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "images/akb-logo-full.png",
              height: 250,
            ),
            // SizedBox(
            //   height: 40,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Expanded(
            //         child: ElevatedButton(
            //           onPressed: () {
            //             Route route =
            //                 MaterialPageRoute(builder: (context) => PesanMenu());
            //             Navigator.push(context, route);
            //           },
            //           child: Text("Lihat Menu"),
            //           style: ButtonStyle(
            //               backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)
            //           ),
            //         )
            //       )
            //     ],
            //   ),
            // )
          ],
        )
      ),
    );
  }
}
