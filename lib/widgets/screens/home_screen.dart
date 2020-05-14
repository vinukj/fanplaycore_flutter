import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:fanplaycore/constants.dart';
import 'package:fanplaycore/widgets/components/fab_bottom_app_bar.dart';
import 'package:fanplaycore/widgets/components/fab_with_icons.dart';
import 'package:fanplaycore/widgets/components/layout.dart';
import 'package:fanplaycore/widgets/components/page_transition.dart';
import 'package:fanplaycore/widgets/components/screen_size_reducers.dart';
import 'package:fanplaycore/widgets/screens/login.dart';
import 'package:fanplaycore/widgets/screens/profile_screen.dart';
import 'package:fanplaycore/widgets/screens/sample_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';

import '../components/location.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Location location = new Location();
  Completer<GoogleMapController> _controller = Completer();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _writeController = TextEditingController();
  BluetoothDevice _connectedDevice;
  List<BluetoothService> _services;
  double homeLatitude = 0.0;
  double homeLongitude = 0.0;
  double newLatitude;
  double newLongitude;

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

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
//    widget.flutterBlue.connectedDevices
//        .asStream()
//        .listen((List<BluetoothDevice> devices) {
//      for (BluetoothDevice device in devices) {
//        _addDeviceTolist(device);
//      }
//    });
//    location.getCurrentPosition();
    getMyPosition();
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
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

//  double _latitude;
//  double _longitude;
//  String _currentAddress;
//  Future<void> getLocation() async {
//    Location location = Location();
//    await location.getCurrentPosition();
//
//    List<Placemark> placemark = await Geolocator()
//        .placemarkFromCoordinates(location.latitude, location.longitude);
//    Placemark place = placemark[0];
//    final String currentAddress =
//        "${place.name}, ${place.thoroughfare}, ${place.subLocality},${place.locality},${place.administrativeArea},${place.postalCode}";
//    //return currentAddress;
//    setState(() {
//      _currentAddress = currentAddress;
//      _latitude = location.latitude;
//      _longitude = location.longitude;
//    });
//  }

//  void getLatLong() async {
//    final SharedPreferences prefs = await _prefs;
//    double latitude = prefs.getDouble('latitude');
//    double longitude = prefs.getDouble('longitude');
//
//    //print(latitude);
//    //print(longitude);
//  }
//  double homeLatitude;
//  getLatOnly() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    //Return double
//    homeLatitude = prefs.getDouble('homelatitude');
//    return homeLatitude;
//  }

//  Future getLongOnly() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    //Return double
//    double longitude = prefs.getDouble('longitude');
//    return longitude;
//  }

  //double _distanceMoved;
//  Future<void> getMovement() async {
//
//    final double distanceMoved = await location.distanceCalculator(
//        prefs.getDouble('latitude'),
//        prefs.getDouble('longitude'),
//        location.lastLatitude,
//        location.lastLongitude);
//    if (distanceMoved > 0.01) {
//      print('alert boundary crossed');
//      setState(() {
//        _distanceMoved = distanceMoved;
//        _safeColor = Colors.red;
//      });
//    }
//    if (distanceMoved < 0.01) {
//      setState(() {
//        _distanceMoved = distanceMoved;
//        _safeColor = Colors.green;
//      });
//    }
//    if (distanceMoved.isNaN) {
//      setState(() {
//        _distanceMoved = 0.0;
//        _safeColor = Colors.green;
//      });
//    }
//  }

  void getMyPosition() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      homeLatitude = position.latitude;
      homeLongitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  void getMyNewPosition() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      newLatitude = position.latitude;
      newLongitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  String _currentAddress;
  getMyAddress() async {
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(homeLatitude, homeLongitude);
    Placemark place = placemark[0];
    final String currentAddress =
        "${place.name}, ${place.thoroughfare}, ${place.subLocality},${place.locality},${place.administrativeArea},${place.postalCode}";
    //return currentAddress;
    setState(() {
      _currentAddress = currentAddress;
    });
  }

  Color _safeColor;
  double _distanceMoved;
  void getMovement() {
    double divider = 57.29577951;
    double milesToKilo = 1.609344;
    double formulaConst = 3963.0;
    double valLat1 = homeLatitude / divider;
    double vallon1 = homeLongitude / divider;
    double vallat2 = newLatitude / divider;
    double vallon2 = newLongitude / divider;
    double val1 = sin(valLat1);
    double val2 = sin(vallat2);
    double val3 = cos(valLat1);
    double val4 = cos(vallat2);
    double val5 = cos(vallon2 - vallon1);
    double moveDistance = formulaConst * acos(val1 * val2 + val3 * val4 * val5);
    // print(distanceMoved);
    print(moveDistance);
    if (moveDistance > 0.01) {
      print('alert boundary crossed');
      setState(() {
        _distanceMoved = moveDistance;
        _safeColor = Colors.red;
      });
    }
    if (moveDistance < 0.01) {
      setState(() {
        _distanceMoved = moveDistance;
        _safeColor = Colors.green;
      });
    }
    if (moveDistance.isNaN) {
      setState(() {
        _distanceMoved = 0.0;
        _safeColor = Colors.green;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final CameraPosition _kMyLocation = CameraPosition(
      target: LatLng(homeLatitude, homeLongitude),
      zoom: 16,
    );

    final CameraPosition _kLake = CameraPosition(
      bearing: 192,
      target: LatLng(homeLatitude, homeLongitude),
      tilt: 60,
      zoom: 20,
    );

//    double distanceMoved = location.distanceCalculator(
//        homeLatitude, homeLongitude, newLatitude, newLongitude);
//    print(distanceMoved);

    //getLocation(latitude, longitude);
//    getLatLong();
//    getMovement();
    //print(_currentAddress);

    //print(latitude);
//    print(_longitude);
    //latitude = await getLatOnly();
//    print(getLongOnly());
    // print(latitude);

    //print(currentlatitude);
    //print(longitude);
    //getLatOnly();
    // print(homeLatitude);
    getMyNewPosition();
    // getMovement();

    print(homeLatitude);
    print(homeLongitude);
    print(newLatitude);
    print(newLongitude);

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
            onPressed: () {
              Share.share('This is awesome share');
            },
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
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              getMyAddress();
                            },
                            child: Icon(
                              FontAwesomeIcons.houseUser,
                              size: 40,
                            ),
                          ),
                        ),
                        Expanded(flex: 3, child: Text('$_currentAddress')),
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                            child: Icon(
                              FontAwesomeIcons.save,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 10,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                            onPressed: () {
                              getMovement();
                            },
                            child: Icon(
                              FontAwesomeIcons.route,
                              size: 40,
                            ),
                          ),
                        ),
                        Expanded(flex: 4, child: Text('$_distanceMoved')),
                        Expanded(
                          flex: 1,
                          child: buildCircleAvatar(_safeColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width * .90,
                    height: height * .60,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kMyLocation,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'LEADERBOARD',
                      style: TextStyle(
                          fontSize: width * .07,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF284BA0),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Stack(
                    //alignment: AlignmentDirectional.center,
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
                        child: Container(
                          child: CircleAvatar(
                            radius: screenWidth(context, dividedBy: 6),
                            child: CircleAvatar(
                              radius: screenWidth(context, dividedBy: 6.5),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(.4, .2),
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: new Text(
                            '4',
                            style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'RAMESH',
                        style: TextStyle(
                          color: kActiveColor,
                          fontSize: screenHeight(context, dividedBy: 30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '2,345 Points',
                        style: TextStyle(
                          color: kInactiveColor,
                          fontSize: screenHeight(context, dividedBy: 40),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Card(
                            margin: EdgeInsets.all(8),
                            elevation: 10,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius:
                                          screenWidth(context, dividedBy: 7),
                                      child: CircleAvatar(
                                        radius: screenWidth(context,
                                            dividedBy: 7.5),
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        child: Image.asset(
                                          'assets/images/ico_running_nocircle.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight(context, dividedBy: 80),
                                ),
                                Text(
                                  '10kms',
                                  style: TextStyle(
                                    fontSize:
                                        screenHeight(context, dividedBy: 35),
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight(context, dividedBy: 80),
                                ),
                                Text(
                                  'Running',
                                  style: TextStyle(
                                      fontSize:
                                          screenHeight(context, dividedBy: 35)),
                                ),
                                SizedBox(
                                  height: screenHeight(context, dividedBy: 80),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            elevation: 10,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius:
                                          screenWidth(context, dividedBy: 7),
                                      child: CircleAvatar(
                                        radius: screenWidth(context,
                                            dividedBy: 7.5),
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        child: Image.asset(
                                          'assets/images/ico_situps_nocircle.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight(context, dividedBy: 80),
                                ),
                                Text(
                                  '250',
                                  style: TextStyle(
                                    fontSize:
                                        screenHeight(context, dividedBy: 35),
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight(context, dividedBy: 80),
                                ),
                                Text(
                                  'Situps',
                                  style: TextStyle(
                                      fontSize:
                                          screenHeight(context, dividedBy: 35)),
                                ),
                                SizedBox(
                                  height: screenHeight(context, dividedBy: 80),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            elevation: 10,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius:
                                          screenWidth(context, dividedBy: 7),
                                      child: CircleAvatar(
                                        radius: screenWidth(context,
                                            dividedBy: 7.5),
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        child: Image.asset(
                                          'assets/images/ico_treadmill_nocircle.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight(context, dividedBy: 80),
                                ),
                                Text(
                                  '5 Kms',
                                  style: TextStyle(
                                    fontSize:
                                        screenHeight(context, dividedBy: 35),
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight(context, dividedBy: 80),
                                ),
                                Text(
                                  'Treadmill',
                                  style: TextStyle(
                                      fontSize:
                                          screenHeight(context, dividedBy: 35)),
                                ),
                                SizedBox(
                                  height: screenHeight(context, dividedBy: 80),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: _buildView(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavyBar(),
    );
  }

  CircleAvatar buildCircleAvatar(_safeColor) {
    return CircleAvatar(
      backgroundColor: _safeColor,
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
          icon: Icon(FontAwesomeIcons.home),
          inactiveColor: kInactiveColor,
          activeColor: kActiveColor,
        ),
        BottomNavyBarItem(
          title: Text('GeoFence'),
          icon: Icon(FontAwesomeIcons.mapMarkedAlt),
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
          title: Text('Pair'),
          icon: Icon(FontAwesomeIcons.asterisk),
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
            height: 1,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.batteryHalf,
                    size: width * .05,
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
                        fontSize: width * .06,
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
                    size: width * .05,
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
                  radius: width * .25,
                  animation: true,
                  animationDuration: 5400,
                  lineWidth: width * .02,
                  percent: 0.7,
                  center: new Text(
                    '5.6 hrs SLEEP',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * .03),
                  ),
                  backgroundColor: Colors.black26,
                  progressColor: Color(0xFF284BA0),
                  circularStrokeCap: CircularStrokeCap.butt,
                ),
              ),
              Expanded(
                child: CircularPercentIndicator(
                  radius: width * .25,
                  animation: true,
                  animationDuration: 5400,
                  lineWidth: width * .02,
                  percent: 0.5,
                  center: new Text(
                    '7689 STEPS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * .03,
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
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                padding: EdgeInsets.all(5),
                elevation: 8.0,
                onPressed: () {},
                color: Colors.white,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(0),
                  //padding: EdgeInsets.all(10),
                  height: height * .07,
                  width: width * .40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/hb_03.gif",
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.end,
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
                padding: EdgeInsets.all(5),
                elevation: 8.0,
                onPressed: () {},
                color: Colors.white,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  height: height * .07,
                  width: width * .40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/bp01.gif",
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            height: 3,
          ),
          Container(
            padding: EdgeInsets.all(3),
            height: height * .15,
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
//                    SizedBox(
//                      height: 5,
//                    ),
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
//          SizedBox(
//            height: 10,
//          ),
          Container(
            padding: EdgeInsets.all(3),
            height: height * .11,
            width: width * .95,
            child: RaisedButton(
              color: Colors.white,
              elevation: 8.0,
              // padding: EdgeInsets.all(5),
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
//            SizedBox(
//              height: 10,
//            ),
          Container(
            padding: EdgeInsets.all(3),
            height: height * .12,
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
//            SizedBox(
//              height: 10,
//            ),
          Container(
            padding: EdgeInsets.all(3),
            height: height * .12,
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

  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  widget.flutterBlue.stopScan();
                  try {
                    await device.connect();
                  } catch (e) {
                    if (e.code != 'already_connected') {
                      throw e;
                    }
                  } finally {
                    _services = await device.discoverServices();
                  }
                  setState(() {
                    _connectedDevice = device;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = new List<ButtonTheme>();

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              color: Colors.blue,
              child: Text('READ', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Send"),
                            onPressed: () {
                              characteristic.write(
                                  utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  widget.readValues[characteristic.uuid] = value;
                  print(value);
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  ListView _buildConnectDeviceView() {
    List<Container> containers = new List<Container>();

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = new List<Widget>();

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ' +
                        widget.readValues[characteristic.uuid].toString()),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Text(service.uuid.toString()),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }
}
