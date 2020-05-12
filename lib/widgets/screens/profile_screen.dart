import 'package:fanplaycore/widgets/components/gradient_appbar.dart';
import 'package:fanplaycore/widgets/components/page_transition.dart';
import 'package:fanplaycore/widgets/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import '../../constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _value;
  int userHeight = 120;
  int userWeight = 50;

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: GradientAppBar(
        gradient: LinearGradient(colors: [kActiveColor, kInactiveColor]),
        title: Image.asset('assets/images/FPH100W.png', fit: BoxFit.cover),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              'PROFILE',
              style: TextStyle(
                  fontSize: width * .08,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF284BA0),
                  fontWeight: FontWeight.w600),
            ),
          ),
          Stack(
            alignment: Alignment(.4, .4),
            children: [
              Container(
                width: width,
                height: height * .20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bgprofile.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                child: CircleAvatar(
                  radius: width * .2,
                  child: CircleAvatar(
                    radius: width * .19,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    child: Icon(
                      FontAwesomeIcons.camera,
                      color: kActiveColor,
                      size: width * .1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          buildTextfields(width, 'Name'),
          buildTextfields(width, 'Email'),
          buildTextfields(width, 'Phone'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                FontAwesomeIcons.venusMars,
                size: 30,
                color: kInactiveColor,
              ),
              Text(
                'Gender:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                width: width * .2,
              ),
              Container(
                child: DropdownButton<String>(
                  items: [
                    DropdownMenuItem<String>(
                      child: Text('Male'),
                      value: 'one',
                    ),
                    DropdownMenuItem<String>(
                      child: Text('Female'),
                      value: 'two',
                    ),
                    DropdownMenuItem<String>(
                      child: Text('Rather not say'),
                      value: 'three',
                    ),
                  ],
                  onChanged: (String value) {
                    setState(() {
                      _value = value;
                    });
                  },
                  hint: Text('Rather not say'),
                  value: _value,
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Icon(
              FontAwesomeIcons.calendarAlt,
              color: kInactiveColor,
              size: 30,
            ),
            Text(
              'BirthDay:',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Text(
                "${selectedDate.toLocal()}".split(' ')[0],
                style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed,
                    decorationColor: kActiveColor),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Height',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Slider(
                value: userHeight.toDouble(),
                min: 100.0,
                max: 250.0,
                activeColor: kActiveColor,
                inactiveColor: kInactiveColor,
                onChanged: (double newUserHeight) {
                  setState(() {
                    userHeight = newUserHeight.round();
                  });
                },
              ),
              Text(
                userHeight.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'cm',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Weight',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Slider(
                value: userWeight.toDouble(),
                min: 25.0,
                max: 100.0,
                activeColor: kActiveColor,
                inactiveColor: kInactiveColor,
                onChanged: (double newUserWeight) {
                  setState(() {
                    userWeight = newUserWeight.round();
                  });
                },
              ),
              Text(
                userWeight.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Kg',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
          Container(
            width: width * .70,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context, PageTransitions(widget: HomeScreen()));
              },
              elevation: 8,
              color: kActiveColor,
              splashColor: kActiveColor,
              child: Text(
                'DONE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildTextfields(double width, String labelText) {
    return Container(
      width: width * .90,
      alignment: Alignment.centerLeft,
      child: TextField(
        onChanged: (value) {},
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
