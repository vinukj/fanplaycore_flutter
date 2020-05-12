import 'dart:convert';

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
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
  final _writeController = TextEditingController();
  BluetoothDevice _connectedDevice;
  List<BluetoothService> _services;
  double latitude;
  double longitude;

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

  String _currentAddress;
  Future<void> getLocation() async {
    Location location = Location();
    await location.getCurrentPosition();
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(location.latitude, location.longitude);
    Placemark place = placemark[0];
    final String currentAddress =
        "${place.name}, ${place.thoroughfare}, ${place.subLocality},${place.locality},${place.administrativeArea},${place.postalCode}";
    //return currentAddress;
    setState(() => _currentAddress = currentAddress);
  }

  double _distanceMoved;
  Future<void> getMovement() async {
    Location location = Location();
    await location.getCurrentPosition();
    await location.getLastPosition();
    final double distanceMoved = await location.distanceCalculator(
        location.latitude,
        location.longitude,
        location.lastLatitude,
        location.lastLongitude);
    if (distanceMoved > 0.00050) {
      print('alert boundary crossed');
      setState(() => _distanceMoved = distanceMoved);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //print(getCurrentPosition());
    //getLocation(latitude, longitude);
    getLocation();
    getMovement();
    //print(_currentAddress);
    //print(_distanceMoved);

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
              child: Column(
                children: [
                  Card(
                    color: Colors.blue,
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.searchLocation,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Text('$_currentAddress')),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.black26,
                    child: Row(
                      children: [
                        Text('$_distanceMoved'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.green,
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
