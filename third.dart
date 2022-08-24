import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';

class Third extends StatefulWidget {
 Database database;
 Third(this.database);

  @override
  State<Third> createState() => _ThirdState();
}

class _ThirdState extends State<Third> {
  List<Map> l=[];
  List name=[];
  List contact=[];
  List image=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    view_data();
  }
 Future view_data()
  async {
    String sql="select * from cdmi";
   l=await widget.database.rawQuery(sql);
   return l;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: FutureBuilder(future: view_data(),builder: (context, snapshot) {
      if(snapshot.connectionState==ConnectionState.done)
        {
              if(snapshot.hasData)
                {
                  List<Map> test=snapshot.data;
                  test.forEach((element) {
                    name.add(element['name']);
                    contact.add(element['contact']);
                    image.add(element['image']);
                  });
                }
              return ListView.builder(itemCount: name.length,itemBuilder: (context, index) {
                return ListTile(title: Text(name[index]),subtitle: Text(contact[index]),
                  leading: Image.memory(width: 50,height: 50,base64Decode(image[index])),);
              },);
        }else
          {
            return Center(child: CircularProgressIndicator(),);
          }
    },)),);
  }
}
