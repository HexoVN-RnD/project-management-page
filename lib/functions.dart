import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_page/backup/main_screen.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import 'Project.dart';
import 'homepage.dart';

void UpdateStatus(bool status, String doc_id) {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var updateState = db.collection("Project").doc(doc_id);
  updateState.update({"Status": status}).then(
      (value) => print("Successfully updated!"),
      onError: (e) => print("Error updating document $e"));
}

List<Project> searchData(value) {
  List<Project> SearchProjects = [];
  // Implement search logic here
  // You may filter your listProjects based on the search value
  if (value.isNotEmpty) {
    List<Project> SearchProjects = listProjects
        .where((project) => removeDiacritics(project.nameProject.toLowerCase())
            .contains(removeDiacritics(value.toLowerCase())))
        .toList();
    return SearchProjects;
    // Update the UI based on search results if needed
    // filteredProjects;
  } else {
    SearchProjects = List.from(listProjects);
    // Update the UI based on search results if needed
    return SearchProjects;
  }
}


Future<List<Project>> filterStatus(value) async {
  List<Project> filterProject = [];
  for (var doc in listProjects){
    if (doc.state == value){
      filterProject.add(doc);
    }
  }
  return filterProject;
}