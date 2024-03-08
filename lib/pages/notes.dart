import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});
  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final user = FirebaseAuth.instance.currentUser!;
  List<String> countryNames = [];
  String selectedCountry = '';

  final FirestoreService firestoreservice = FirestoreService();
  final noteController = TextEditingController();
  final subjectController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCountryNames();
  }

  Future<void> fetchCountryNames() async {
    final response = await http.get(
      Uri.parse('https://restcountries.com/v3.1/all'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<String> names =
          data.map((country) => country['name']['common'].toString()).toList();

      setState(() {
        countryNames = names;
        selectedCountry = countryNames.isNotEmpty ? countryNames[0] : '';
      });
    } else {
      throw Exception('Failed to load country data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromRGBO(106, 107, 107, 1),
          Color.fromARGB(255, 0, 0, 0)
        ],
        stops: [0, 1],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      )),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromRGBO(0, 168, 181, 1),
            onPressed: createNewNote,
            child: Icon(Icons.add),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: firestoreservice.getNotesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List noteList = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: noteList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = noteList[index];
                      String docID = document.id;

                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String noteCountry = data['country'];
                      String noteSubject = data['subject'];
                      String noteBody = data['note'];

                      return Slidable(
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                createNewNote(docID: docID);
                              },
                              icon: Icons.edit,
                              backgroundColor: Color.fromARGB(255, 40, 230, 119)
                                  .withOpacity(0.5),
                            ),
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                firestoreservice.deleteNote(docID);
                              },
                              icon: Icons.delete,
                              backgroundColor:
                                  Colors.red.shade300.withOpacity(0.5),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 1,
                            ),
                            Container(
                              height: 500,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300.withOpacity(0.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Note about what country: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            noteCountry,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Note about what: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            noteSubject,
                                          ),
                                        ],
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          width: 400,
                                          height: 400,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  style: BorderStyle.solid),
                                              color: const Color.fromARGB(
                                                  255, 189, 189, 189)),
                                          child: Text(
                                            noteBody,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return const Text('no data');
              }
            },
          )),
    );
  }

  void viewNote() {}

  void createNewNote({String? docID}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade300,
            content: SingleChildScrollView(
              child: Container(
                width: 400,
                height: 600,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Which country do you want to note?",
                      style: GoogleFonts.bebasNeue(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 20,
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(0, 168, 181, 1),
                                  width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(0, 168, 181, 1),
                                  width: 2))),
                      isExpanded: true,
                      value: selectedCountry,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCountry = newValue!;
                        });
                      },
                      items: countryNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(child: Text(value)),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 300, // <-- TextField width
                      height: 65, // <-- TextField height
                      child: TextField(
                        controller: subjectController,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'About what subject?',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 300, // <-- TextField width
                      height: 387, // <-- TextField height
                      child: TextField(
                        controller: noteController,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter your note here',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            if (docID == null) {
                              firestoreservice.addNote(
                                  user.uid,
                                  selectedCountry,
                                  subjectController.text,
                                  noteController.text);
                            } else {
                              firestoreservice.updateNote(
                                  docID,
                                  selectedCountry,
                                  subjectController.text,
                                  noteController.text);
                            }

                            subjectController.clear();
                            noteController.clear();

                            Navigator.pop(context);
                          },
                          color: Color.fromRGBO(0, 168, 181, 1),
                          child: Text('SAVE'),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        MaterialButton(
                          onPressed: () => Navigator.of(context).pop(),
                          color: Color.fromRGBO(0, 168, 181, 1),
                          child: Text('CANCEL'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
