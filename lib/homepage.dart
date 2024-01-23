
import 'package:demo_page/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'Project.dart';
import 'backup/main_screen.dart';
import 'desktop.dart';
import 'mobile_body.dart';


List<Project> listProjects = [];
List<Project> listResult = listProjects;
bool isDarkMode = false;


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileBody(),
        desktopBody: DesktopBody(),
      ),
    );
  }
}

