import 'package:bohlalefinance/Home/pages/dept/dept.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      // MainScreen(),
    DeptScreen(),
    Container(child: Center(child: Text("text"),),)
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.healing_outlined),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.medical_information),
          title: ("Medical Records"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
        
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
         decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
         
          navBarStyle: NavBarStyle
              .style1, // Choose the nav bar style with this property.
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
}