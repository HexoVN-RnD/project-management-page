import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_page/pallete.dart';
import 'package:flutter/material.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'Project.dart';
import 'functions.dart';

List<Project> listProjects = [];
List<Project> listResult = listProjects;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isDarkMode = false;
  final String lightModelLogo = "assets/images/logo.png";
  final String darkModeLogo = "assets/images/logo2.png";
  bool isSettingsVisible = false;
  bool isMenuOpen = false;

  void fetchData() async {
    try {
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
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 70.0,
              width: double.infinity,
              // color: isDarkMode ? Pallete.backgroundColor : Pallete.whiteColor,
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: ClipRRect(
                      child: Image.asset(
                        isDarkMode ? lightModelLogo : darkModeLogo,
                        fit: BoxFit.fitHeight,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      controller: searchController,
                      onChanged: (value) {
                        List<Project> filteredProjects = [];
                        // Implement search logic here
                        // You may filter your listProjects based on the search value
                        if (value.isNotEmpty) {
                          List<Project> filteredProjects = listProjects
                              .where((project) => removeDiacritics(project.nameProject
                              .toLowerCase())
                              .contains(removeDiacritics(value.toLowerCase())))
                              .toList();
                          setState(() {
                            // Update the UI based on search results if needed
                            listResult = filteredProjects;
                          });
                        } else{
                          filteredProjects = List.from(listProjects);
                          setState(() {
                            // Update the UI based on search results if needed
                            listResult = filteredProjects;
                          });
                        }
                      //   listResult = searchData(value);
                      },

                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: ' . . .',
                        prefixIcon:
                            Icon(Icons.search, color: isDarkMode ? Colors.white38 : Colors.black38),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2, color: Pallete.cyan),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            width: 2,
                            color: Pallete.cyan,
                          ),
                        ),
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isDarkMode = !isDarkMode;
                            });
                          },
                          icon: Icon(
                            isDarkMode ? Icons.brightness_5 : Icons.brightness_4,
                            color: Colors.grey,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listResult.length,
              itemBuilder: (context, index) {
                return SwitchListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Text(
                      listResult[index].nameProject.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isDarkMode
                            ? Colors.white70
                            : Colors.black54,
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
