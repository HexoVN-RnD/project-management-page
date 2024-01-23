import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_page/pallete.dart';
import 'package:flutter/material.dart';
import 'Project.dart';
import 'functions.dart';
import 'homepage.dart';


class DesktopBody extends StatefulWidget {
  const DesktopBody({Key? key}) : super(key: key);

  @override
  State<DesktopBody> createState() => _DesktopBodyState();
}

class _DesktopBodyState extends State<DesktopBody> {
  TextEditingController searchController = TextEditingController();
  // bool isDarkMode = false;
  final String lightModeLogo = "assets/images/logo.png";
  final String darkModeLogo = "assets/images/logo2.png";
  bool isSettingsVisible = false;
  bool isMenuOpen = false;

  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  List<Project> listResult = [];

  void fetchData() async {
    try {
      // Clear the existing data before fetching new data
      listProjects.clear();

      // Replace 'your_collection_name' with the actual name of your Firestore collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Project').get();

      // Process the data here
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for (var document in documents) {
        // Access document data using document.data() method
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {
          listProjects.add(Project(
              id: document.id,
              nameProject: data['Name'],
              state: data['Status']));
        });
      }

      // Update listResult to contain the fetched data
      setState(() {
        listResult = List.from(listProjects);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print(isDarkMode);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: itemColor),
        backgroundColor: appbarColor,
        title: Row(children: [
          Image.asset(
            isDarkMode ? 'assets/images/logo.png' : 'assets/images/logo2.png',
            filterQuality: FilterQuality.none,
            height: 50,
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 40,
                width: 450,
                child: TextField(
                  style: TextStyle(color: itemColor),
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      listResult = searchData(value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w100),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Pallete.borderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Pallete.cyan,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          PopupMenuButton(
              icon: const Icon(Icons.filter_list),
              color: appbarColor,
              onSelected: (value) async {
                if (value != 1) {
                  List<Project> filteredProjects = await filterStatus(value);
                  setState(() {
                    listResult = filteredProjects;
                  });
                } else {
                  setState(() {
                    listResult = listProjects;
                  });
                }
              },
              itemBuilder: (BuildContext bc) {
                return [
                  PopupMenuItem(
                    child: Text(
                      "Filter Project On",
                      style: TextStyle(color: itemColor),
                    ),
                    value: true,
                  ),
                  PopupMenuItem(
                    child: Text(
                      "Filter Project Off",
                      style: TextStyle(color: itemColor),
                    ),
                    value: false,
                  ),
                  PopupMenuItem(
                    child: Text(
                      "Show All",
                      style: TextStyle(color: itemColor),
                    ),
                    value: 1,
                  )
                ];
              })
        ]),
      ),
      drawer: Drawer(
        backgroundColor: appbarColor,
        width: 200,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 64,
              child: DrawerHeader(
                child: Text(
                  'MENU',
                  style: TextStyle(
                    color: itemColor,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                  isDarkMode ? Icons.brightness_5 : Icons.brightness_3,
                  color: itemColor),
              title: Text(
                'Change theme',
                style: TextStyle(fontSize: 14, color: itemColor),
              ),
              onTap: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                  if (bgColor == blackbg) {
                    bgColor = whitebg;
                  } else {
                    bgColor = blackbg;
                  }
                  if (itemColor == blackbgItemcolor) {
                    itemColor = whitebgItemcolor;
                  } else {
                    itemColor = blackbgItemcolor;
                  }
                  if (appbarColor == blackAppbar) {
                    appbarColor = whiteAppbar;
                  } else {
                    appbarColor = blackAppbar;
                  }
                });
              },
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                color: itemColor,
              ),
              title: Text(
                'Language Settings',
                style: TextStyle(fontSize: 14, color: itemColor),
              ),
              onTap: () {
                // Handle Language Settings
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listResult.length,
              itemBuilder: (context, index) {
                return SwitchListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      listResult[index].nameProject.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: itemColor,
                      ),
                    ),
                  ),
                  value: listResult[index].state,
                  activeTrackColor: Pallete.cyan,
                  onChanged: (bool value) {
                    setState(() {
                      listResult[index].state = value;
                      UpdateStatus(value, listResult[index].id);
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
