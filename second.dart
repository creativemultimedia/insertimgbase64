import 'dart:convert';
import 'dart:io';
import 'package:mathspuzzle_demo2/third.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

class Second extends StatefulWidget {
  const Second({Key? key}) : super(key: key);
  @override
  State<Second> createState() => _SecondState();
}
class _SecondState extends State<Second> {
  final ImagePicker _picker = ImagePicker();
   XFile? image;
   bool t=false;
   Database? database;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db_create();
  }
  db_create()
  async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'creative.db');
     database= await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE cdmi (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contact TEXT , image TEXT)');
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Column(children: [
      TextButton(onPressed: () {
        showDialog(context: context, builder: (context) {
          return AlertDialog(title: Text("select Galary or Camera Image"),actions: [
            TextButton(onPressed: () async {
              image = await _picker.pickImage(source: ImageSource.gallery);
              setState(() {
                t=true;
                Navigator.pop(context);
              });
            }, child: Text("Gallery")),
            TextButton(onPressed: () async {
              image = await _picker.pickImage(source: ImageSource.camera);
              setState(() {
                t=true;
                Navigator.pop(context);
              });
            }, child: Text("Gallery")),
          ],);
        },);
      }, child: Text("Browse")),
      TextButton(onPressed: ()async {
          String img=base64Encode(await image!.readAsBytes());
          String qry="insert into cdmi values(null,'keyur','87878','$img')";
          int r_id;
           r_id=await database!.rawInsert(qry);
          print(r_id);
      }, child: Text("Submit")),
      Container(width: 100,height: 100,child:  (t==true) ? Image.file(File(image!.path)) : Text("Upload") ),
      ElevatedButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Third(database!);
        },));
      }, child: Text("VIew"))
    ],)),);
  }
}
