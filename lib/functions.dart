import 'package:cloud_firestore/cloud_firestore.dart';



void UpdateStatus(bool status, String doc_id) {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var updateState = db.collection("Project").doc(doc_id);
  updateState.update({"Status": status}).then(
          (value) => print("Successfully updated!"),
      onError: (e) => print("Error updating document $e"));
}
