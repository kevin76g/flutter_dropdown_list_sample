import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DropDownScreen extends StatefulWidget {
  const DropDownScreen({Key? key}) : super(key: key);

  @override
  State<DropDownScreen> createState() => _DropDownScreenState();
}

class _DropDownScreenState extends State<DropDownScreen> {
  String? fruit;

  Future<List<QueryDocumentSnapshot>> getFruits() async {
    try {
      final ref = FirebaseFirestore.instance.collection('fruits');

      final querySnap = await ref.get();
      return querySnap.docs;
    } catch (e) {
      debugPrint(e.toString());
      throw Error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firestore Dropdown Sample'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: getFruits(),
          builder: (BuildContext context,
              AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
            List<Map<String, dynamic>> dropdownMenu = [];
            if (snapshot.hasData) {
              for (var doc in snapshot.data!) {
                dropdownMenu
                    .add({'value': doc.id, 'display': doc.get('title')});
              }
            } else if (snapshot.hasError) {
              return const Text('error');
            } else {
              return const Text('loading');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'フルーツ',
                      style: TextStyle(fontSize: 26.0),
                    ),
                    const SizedBox(
                      width: 50.0,
                    ),
                    DropdownButton<String>(
                      value: fruit,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          fruit = value!;
                        });
                      },
                      items: dropdownMenu.map<DropdownMenuItem<String>>(
                          (Map<String, dynamic> map) {
                        return DropdownMenuItem<String>(
                          value: map['value'],
                          child: Text(
                            map['display'],
                            style: const TextStyle(fontSize: 26.0),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                fruit != null
                    ? Text(
                        'ドキュメントID：$fruit',
                        style: const TextStyle(fontSize: 26.0),
                      )
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }
}
