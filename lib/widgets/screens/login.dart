import 'dart:convert';

import 'package:fanplaycore/widgets/components/horizontal_orline.dart';
import 'package:fanplaycore/widgets/components/page_transition.dart';
import 'package:fanplaycore/widgets/screens/home_screen.dart';
import 'package:fanplaycore/widgets/screens/sample_screen.dart';
import 'package:fanplaycore/widgets/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

String userName;
String password;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Image.asset('assets/images/FPH100C.png'),
            ),
            Container(
              child: Text(
                'LOGIN',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                onChanged: (value) {
                  userName = value;
                },
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.user),
                  labelText: 'Username',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.unlock),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: InkWell(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                child: Text('I agree to privacy policy & terms'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ButtonTheme(
              minWidth: 250,
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.orange,
                child: Text(
                  "  LOGIN  ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                elevation: 5.0,
                onPressed: () {
                  // Do something here
                  signIn(userName, password);
//                  Navigator.push(
//                      context, PageTransitions(widget: HomeScreen()));
                },
                splashColor: Colors.blueAccent,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            HorizontalOrLine(height: 50, label: "OR"),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: null,
                    child: Image.asset('assets/images/gmail.png'),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: null,
                    child: Image.asset('assets/images/fb.png'),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: null,
                    child: Image.asset('assets/images/linkedin.png'),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: null,
                    child: Image.asset('assets/images/otp.png'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Don\'t have an Account ?',
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                SizedBox(width: 10.0, height: 0.0),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context, PageTransitions(widget: SignUpPage()));
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.orange,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void signIn(String userName, String password) async {
    String baseUrl =
        'http://45.112.139.194:8345/api/Signup/CheckSignup?signup.uEmailId=';
    String newEmail = userName.replaceAll('@', '%40');
    //print(newEmail);
    String urlfiller = '&signup.uPassword=';
    String urlBuild = baseUrl + newEmail + urlfiller + password;
    Response response = await get(urlBuild);
    var loginSuccess =
        jsonDecode(response.body)['SignupAuthentication'][0]['SId'];
    var loginInvalid = jsonDecode(response.body)['SignupAuthentication'];

    try {
      if (response.statusCode == 200) {
        if (loginSuccess == 2) {
          print('success');
          clearCredentials();
          Navigator.push(context, PageTransitions(widget: HomeScreen()));
        } else {
          print('Invalid Credentials');
        }
      }
      //print(response.body);
      else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void clearCredentials() {
    userName = '';
    password = '';
  }
}
