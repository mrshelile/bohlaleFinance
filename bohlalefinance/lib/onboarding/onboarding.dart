import 'package:bohlalefinance/Home/home.dart';
import 'package:bohlalefinance/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class OnBoarding extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).copyWith().size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        //stack overlaps widgets
        Positioned(
          left: size.width * 0.05,
          top: size.height * 0.04,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bohlale Finance – Smart",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.cyan),
              ),
              const Text(
                " Financially Empowering!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.amber),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                          color: Colors.teal,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                   Navigator.push(context,MaterialPageRoute(builder:(context) => HomePage()));
                  },
                  child: const Text(
                    "Continue Here",
                    style: TextStyle(
                        color: Colors.teal, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
        ClipPath(
          //upper clippath with less height
          clipper: WaveClipper(), //set our custom wave clipper.
          child: Container(
              color: AppColors.mainColor,
              height: size.height,
              alignment: Alignment.center,
              child: const Text(
                "",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              )),
        ),
        Positioned(
            left: size.width * 0.01,
            top: size.height * 0.15,
            child: SizedBox(
              width: size.width,
              child: SvgPicture.asset("assets/chart.svg",
                  // colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                  semanticsLabel: 'Next'),
            ))
      ],
    ));
  }
}

//Costom CLipper class with Path
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0,
        size.height * 0.5); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height * 0.7);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2, size.height * 0.65);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height * 0.6);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height * 0.6);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    var thirdStart =
        Offset(size.width - (size.width / 3.24), size.height * 0.65);
    //third point of quadratic bezier curve
    var thirdEnd = Offset(size.width, size.height * 0.6);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        thirdStart.dx, thirdStart.dy, thirdEnd.dx, thirdEnd.dy);

    path.lineTo(size.width,
        size.height - 10); //end with this path if you are making wave at bottom
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}