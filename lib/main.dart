import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ZJUWLAN连接',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'ZJUWLAN连接'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = new TextEditingController();
  final String url = "https://net.zju.edu.cn/include/auth_action.php";
  String _data="";
  String id = "";
  String password = "";
  String login_data="";
  RegExp login_ok=new RegExp("login_ok");

  void _handleSubmitted(String text) {
    _textController.clear();
  }

  void _connect() async {
    var response = await http.post(Uri.encodeFull(url), headers: {"Accept": "application/json"},body: {"action": "login", "username":id,"password": password,"ac_id":"3","ajax":"1"});
    print(response.body);
    print(id);
    print(password);
    setState((){
      _data = response.body;
      if(login_ok.hasMatch(_data)==true)
        login_data="登陆成功";
      else
        login_data="登录失败";
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(

        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(widget.title),
        ),
        body: new Container(
          padding: const EdgeInsets.all(10.0),
          child: new Center(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new TextField(
                  decoration: new InputDecoration(
                      hintText: "输入学号"
                  ),
                  onChanged: (String str){
                    setState((){
                      id = str;
                    });
                  },
//                onChanged: (String str) {
//                  setState((){
//                    result = str;
//                  });
//                },
                ),
                new Text(id, style: new TextStyle(
                    fontSize: 18.0,
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold
                )),
                new TextField(
                  decoration: new InputDecoration(
                      hintText: "输入密码"
                  ),
                  onChanged: (String str){
                    setState((){
                      password = str;
                    });

                  },
//                onChanged: (String str) {
//                  setState((){
//                    result = str;
//                  });
//                },
                ),
                new Text(password, style: new TextStyle(
                    fontSize: 18.0,
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold
                )),
                new Text(login_data, style: new TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                )),
                new Padding(padding: new EdgeInsets.all(10.0)),
                new RaisedButton(
                  child: new Text(
                    "连接",
                    style: new TextStyle(color: Colors.white),
                  ),
                  color: Colors.blueGrey,
                  onPressed: _connect,
                )
              ],
            ),
          ),
        ),
    );// This trailing comma makes auto-formatting nicer for build methods.;
  }
}
