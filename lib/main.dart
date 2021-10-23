import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    double year = 0;
    double month = 0;
    bool isLoading = false;
  Future<void> sendData() async {
      setState(() {
        isLoading = true;
      });

    Map<String,dynamic> map ={};
    map['year'] = year;
    map['month'] = month;

    var url = Uri.parse('https://cpsu-test-api.herokuapp.com/guess_teacher_age');
    var response = await http.post(url, headers: {'Content-Type': 'application/json'},body : json.encode(map));
    if(response.statusCode == 200)
    {
      setState(() {
        isLoading = false;
      });
        Map<String,dynamic>jsonBody  = json.decode(response.body);
        print('${jsonBody['data']['value']}');
      if(jsonBody['data']['value'] == true)
        {
          _showMaterialDialog('ยินดีด้วย',"${jsonBody['data']['text']} อายุคือ ${year.toInt()} ปี ${month.toInt()} เดือน");
          setState(() {
            year = 0;
            month = 0;
          });
        }
      else
        {
          _showMaterialDialog('ไม่ถูกต้อง',"${jsonBody['data']['text']}");
        }
    }
    else
    {
      _showMaterialDialog('พบข้อผิดพลาด',"โปรดตรวจสอบอินเตอร์เน็ตของคุณ");
    }
  }
  void _showMaterialDialog(String title,String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content:
          Text(message

          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text("ทายอายุ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
      ),
      body: Stack( children : [
      Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height : 70,
              child:
            Text(
              'ใส่ข้อมูลสำหรับทายอายุ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
            ),
            ),
            Container(
              width: 400,
              child :
            Card(
              elevation: 5,
              child: Column( children: [
                Container(child: Text("ปี",style: TextStyle(fontSize: 16,),),),
                SizedBox(height: 20,),
            SpinBox(

              min: 1,
              max: 100,
              value: year as double,
              onChanged: (value) { year = value;
              }
            ),

                Container(child: Text("เดือน",style: TextStyle(fontSize: 16,),),),
                SizedBox(height: 20,),
            SpinBox(
                min: 1,
                max: 12,
                value: month as double,
                onChanged: (value) { month = value;
                }
            ),
            ]),
      ),
            ),
            SizedBox(height: 30,),
            Container( height: 50, width: 100,
                child:
              ElevatedButton(onPressed: sendData, child: Text("Submit"),style: ElevatedButton.styleFrom(primary: Colors.lightGreen),))
          ],
        ),
      ),
        if(isLoading)
          Container(
            color: Colors.black.withOpacity(0.35),
            child: Center(
              child: SizedBox(child:
                CircularProgressIndicator(color: Colors.lightGreen,),
              ),
            ),
          )
    ])
    );
  }
}
