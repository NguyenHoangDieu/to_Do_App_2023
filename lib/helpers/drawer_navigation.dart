import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app_2023/screens/about_us_screen.dart';
import 'package:to_do_app_2023/screens/category_screen.dart';
import 'package:to_do_app_2023/screens/home_screen.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("lib/assets/image/avt.jpg"),
              ),
                accountName: Text('Hoang Dieu'),
                accountEmail: Text('hoangdieu8023@gmail.com'),
                decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text("Category"),
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CategoryScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About us"),
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AboutUsScreen())),
            )
          ],
        ),
      ),
    );
  }
}
