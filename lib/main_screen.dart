import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_page/pallete.dart';
import 'package:flutter/material.dart';
import 'Project.dart';
import 'functions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Project> listProjects = [];


  void fetchData() async {
    try {
      // Replace 'your_collection_name' with the actual name of your Firestore collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
          'Project').get();

      // Process the data here
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for (var document in documents) {
        // Access document data using document.data() method
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {
          listProjects.add(Project(
              id: document.id, nameProject: data['Name'], state: data['Status']));
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
      backgroundColor: Pallete.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 70.0,
              width: double.infinity,
              color: Pallete.backgroundColor,
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: ClipRRect(
                      child: Image.asset(
                        "assets/images/HexoGrp.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  // Implement search logic here
                  // You may filter your listProjects based on the search value
                  setState(() {
                    // Update the UI based on search results if needed
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: ' . . .',
                  prefixIcon: const Icon(Icons.search, color: Colors.white38),
                  border: OutlineInputBorder(
                    borderSide:
                    const BorderSide(width: 2, color: Pallete.borderColor),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listProjects.length,
              itemBuilder: (context, index) {
                return SwitchListTile(
                  title: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 10),
                          child: Text(
                            listProjects[index].nameProject.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                  value: listProjects[index].state,
                  activeTrackColor: Colors.green,
                  onChanged: (bool value) {
                    setState(() {
                      listProjects[index].state = value;
                      UpdateStatus(value, listProjects[index].id);
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
