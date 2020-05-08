import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:fanplaycore/constants.dart';
import 'package:fanplaycore/widgets/components/fab_bottom_app_bar.dart';
import 'package:fanplaycore/widgets/components/fab_with_icons.dart';
import 'package:fanplaycore/widgets/components/layout.dart';
import 'package:fanplaycore/widgets/components/page_transition.dart';
import 'package:fanplaycore/widgets/screens/login.dart';
import 'package:fanplaycore/widgets/screens/profile_screen.dart';
import 'package:fanplaycore/widgets/screens/sample_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  PageController _pageController;

  String _lastSelected = 'TAB: 0';

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return new Scaffold(
      //key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/FPH100C.png'),
                    fit: BoxFit.contain),
              ),
            ),
            ListTile(
              title: Text('Login'),
              onTap: () {
                Navigator.push(context, PageTransitions(widget: Login()));
              },
            )
          ],
        ),
      ),
      appBar: GradientAppBar(
        gradient: LinearGradient(colors: [kActiveColor, kInactiveColor]),
        //backgroundColor: Color(0xFFFEBC12),
        leading: Builder(
          builder: (context) => Material(
            // needed
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Scaffold.of(context).openDrawer(), // needed
              child: Image.asset(
                "assets/images/fpsymbol3.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        //leading: Image.asset('assets/images/fpsymbol3.png'),
        // onPressed: () => Scaffold.of(context).openDrawer(),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.bell),
            onPressed: () {
              //Navigator.push(context, PageTransitions(widget: SampleScreen()));
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.shareAlt),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.userAlt),
            onPressed: () {
              Navigator.push(context, PageTransitions(widget: ProfileScreen()));
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            buildContainerSummaryScreen(height, width),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.blue,
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavyBar(),
    );
  }

  BottomNavyBar buildBottomNavyBar() {
    return BottomNavyBar(
      selectedIndex: _currentIndex,
      onItemSelected: (index) {
        setState(() => _currentIndex = index);
        _pageController.jumpToPage(index);
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          title: Text('Summary'),
          icon: Icon(Icons.home),
          inactiveColor: kInactiveColor,
          activeColor: kActiveColor,
        ),
        BottomNavyBarItem(
          title: Text('Shop'),
          icon: Icon(FontAwesomeIcons.shoppingCart),
          inactiveColor: kInactiveColor,
          activeColor: kActiveColor,
        ),
        BottomNavyBarItem(
          title: Text('Rewards'),
          icon: Icon(FontAwesomeIcons.trophy),
          inactiveColor: kInactiveColor,
          activeColor: kActiveColor,
        ),
        BottomNavyBarItem(
          title: Text('Item One'),
          icon: Icon(Icons.settings),
          inactiveColor: kInactiveColor,
          activeColor: kActiveColor,
        ),
      ],
    );
  }

  Container buildContainerSummaryScreen(double height, double width) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/web_BG_mobile_01.png'),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.batteryHalf,
                    size: 30,
                    color: Color(0xFF284BA0),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Center(
                  child: Text(
                    'TODAY',
                    style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF284BA0),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.calendarAlt,
                    size: 30,
                    color: Color(0xFF284BA0),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CircularPercentIndicator(
                  radius: 120.0,
                  animation: true,
                  animationDuration: 5400,
                  lineWidth: 10.0,
                  percent: 0.7,
                  center: new Text(
                    '5.6 hrs SLEEP',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.black26,
                  progressColor: Color(0xFF284BA0),
                  circularStrokeCap: CircularStrokeCap.butt,
                ),
              ),
              Expanded(
                child: CircularPercentIndicator(
                  radius: 120.0,
                  animation: true,
                  animationDuration: 5400,
                  lineWidth: 10.0,
                  percent: 0.5,
                  center: new Text(
                    '7689 STEPS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.black26,
                  progressColor: Color(0xFFF37421),
                  circularStrokeCap: CircularStrokeCap.butt,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                elevation: 8.0,
                onPressed: () {},
                color: Colors.white,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(5),
                  height: height * .09,
                  width: width * .36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/hb_03.gif",
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          buildTextCalendarDate('6 May >'),
                          buildTextTitle('60 BPM'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              RaisedButton(
                elevation: 8.0,
                onPressed: () {},
                color: Colors.white,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(5),
                  height: height * .09,
                  width: width * .4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/bp01.gif",
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          buildTextCalendarDate('6 May >'),
                          buildTextTitle('120mmHG'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: height * .10,
            width: width * .95,
            child: RaisedButton(
              color: Colors.white,
              elevation: 8.0,
              padding: EdgeInsets.all(5),
              onPressed: () {
                print('activity pressed');
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextTitle('Activity'),
                      buildTextCalendarDate('6 May >'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            buildTextInnerHeader('Move'),
                            SizedBox(
                              height: 5,
                            ),
                            buildTextInnerData('205 KCal'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            buildTextInnerHeader('Steps'),
                            SizedBox(
                              height: 5,
                            ),
                            buildTextInnerData('6700'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            buildTextInnerHeader('Distance'),
                            SizedBox(
                              height: 5,
                            ),
                            buildTextInnerData('2 Km'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: height * .10,
            width: width * .95,
            child: RaisedButton(
              color: Colors.white,
              elevation: 8.0,
              padding: EdgeInsets.all(5),
              onPressed: () {
                print('activity pressed');
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextTitle('Heart Rate'),
                      buildTextCalendarDate('8 May >'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            buildTextInnerData('82 BPM'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: height * .10,
            width: width * .95,
            child: RaisedButton(
              color: Colors.white,
              elevation: 8.0,
              padding: EdgeInsets.all(5),
              onPressed: () {
                print('activity pressed');
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextTitle('Blood Pressure'),
                      buildTextCalendarDate('2 May >'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            buildTextInnerData('120 - 140 mmHG'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: height * .10,
            width: width * .95,
            child: RaisedButton(
              color: Colors.white,
              elevation: 8.0,
              padding: EdgeInsets.all(5),
              onPressed: () {
                print('activity pressed');
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextTitle('Sleep'),
                      buildTextCalendarDate('4 May >'),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            buildTextInnerData('8 hours'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text buildTextInnerData(String data) {
    return Text(
      data,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: kInactiveColor,
      ),
    );
  }

  Text buildTextInnerHeader(String data) {
    return Text(
      data,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: kActiveColor,
      ),
    );
  }

  Text buildTextCalendarDate(String data) {
    return Text(
      data,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: kInactiveColor,
      ),
    );
  }

  Text buildTextTitle(String data) {
    return Text(
      data,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: kActiveColor,
      ),
    );
  }
}
