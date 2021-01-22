import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen'; //belongs to the WelcomeScreen class

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  //SingleTickerProviderStateMixin is the add-on ability of _WelcomeScreenState object

  AnimationController controller; //linear function
  Animation animation; //curved function layered up on controller

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      lowerBound: 0.4,
      upperBound: 1.0,
      //Current _WelcomeScreen State object will act as the TickerProvider
    );

    controller.forward();
    controller.addListener(() {
      //Calls the listener every time the value of the animation changes.
      setState(() {
        //values are already changing with AnimationController
        //setState only used to trigger re-build of widget , do nothing else
      });
    });
    ////////////////////////////////////////////////////////////

    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    // parent -> The animation to which this animation applies a curve
    // curve -> The curve to use in the forward direction
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 1);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background4.png'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.yellow.withOpacity(0.5), BlendMode.dstATop),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(19, 0, 19, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'frog_come_closer_animation',
                    child: Container(
                      child: Image.asset('images/logo1.png'),
                      height: animation.value * 60,
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    text: [
                      "  मन की बात ..",
                      "करें कुछ बातचीत !",
                    ],
                    speed: Duration(milliseconds: 100),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontFamily: 'Teko',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              RoundedButton(
                buttoncolour: Color(0xFFBF360C),
                buttontitle: 'LOG IN thokiye dabake.\n       Jai Mahakal 🙏',
                onPressedAct: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              RoundedButton(
                buttoncolour: Color(0xFF012D08),
                buttontitle:
                    'Samaaj mai rehna hai to,\nREGISTER karna padega 👊',
                onPressedAct: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose(); //destructor of the run time memory
    super.dispose();
  }
}
