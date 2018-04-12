import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

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
  final TextEditingController controller1 = new TextEditingController();
  final TextEditingController controller2 = new TextEditingController();
  final String url = "https://net.zju.edu.cn/include/auth_action.php";
  String _data="";
  String id = "";
  String password = "";
  String login_data="";
  RegExp login_ok=new RegExp("login_ok");
  String buttonstr="连接";
  VoidCallback func=null;
  void showMessage(String name) {
    showDialog<Null>(
        context: context,
        child: new AlertDialog(
            content: new Text(name),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('确定')
              )
            ]
        )
    );
  }

  void initState() {
    // 调用原initState方法内容
    super.initState();
    func=_connect;
    /*
     * 调用_readCounter函数，读取点击数
     *  将点击数作为参数，创建一个函数
     */
    _readinfo().then((String contents){
      setState((){
        print(contents);
        List str = contents.split('||');
        id = controller1.text = str[0];
        password = controller2.text = str[1];
      });
    });
  }

  Future<String> _readinfo() async {
    try {
      /*
       * 获取本地文件目录
       * 关键字await表示等待操作完成
       */
      File file = await _getLocalFile();
      // 使用给定的编码将整个文件内容读取为字符串
      String  contents = await file.readAsString();
      // 返回文件中的点击数
      return contents;
    } on FileSystemException {
      // 发生异常时返回默认值
      return "||";
    }
  }
  // _getLocalFile函数，获取本地文件目录
  Future<File> _getLocalFile() async {
    // 获取本地文档目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    // 返回本地文件目录
    return new File('$dir/connect.txt');
  }

  void _connect() async {
    int times=10;
    func=null;
    buttonstr="正在连接";
    while(times>0) {
      times--;
      var response = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/json"},
          body: {
            "action": "login",
            "username": id,
            "password": password,
            "ac_id": "3",
            "ajax": "1"
          });
      print(response.body);
      print(id);
      print(password);
      await (await _getLocalFile()).writeAsString('$id' + '||' + '$password');
      setState(() {
        _data = response.body;
        if (login_ok.hasMatch(_data) == true)
          {
            showMessage("登陆成功！");
            times=-1;
          }
      });
      sleep(new Duration(seconds:1));
    }
    if (times==0)
      showMessage("登陆失败！");
    func=_connect;
    buttonstr="连接";
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
                new TextField(style: new TextStyle(
                fontSize: 18.0,
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold
            ),
                  decoration: new InputDecoration(
                      hintText: "输入学号"
                  ),
                  onChanged: (String str){
                    setState((){
                      id = str;
                    });
                  },
                  controller: controller1,
                ),
                new TextField(style: new TextStyle(
                    fontSize: 18.0,
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold
                ),
                  obscureText:true,
                  decoration: new InputDecoration(
                      hintText: "输入密码"
                  ),
                  onChanged: (String str){
                    setState((){
                      password = str;
                    });

                  },
                  controller: controller2,
                ),

                new Padding(padding: new EdgeInsets.all(10.0)),
                new RaisedButton(
                  child: new Text(
                    buttonstr,
                    style: new TextStyle(color: Colors.white),
                  ),
                  color: Colors.blueGrey,
                  onPressed: func,
                )
              ],
            ),
          ),
        ),
    );// This trailing comma makes auto-formatting nicer for build methods.;
  }
}
