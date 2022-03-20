import 'package:template/Api/api.dart';
import 'package:template/ApiFolder/post_share.dart';
import 'package:template/login.dart';
import 'package:template/profile.dart';
import 'package:flutter/material.dart';
import 'package:template/taikhoan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';

import '../home_page.dart';

class Sharea extends StatefulWidget {
  final String id;
  final String idaccount;
  final String username;
  final String password;
  Sharea({Key? key, required this.id, required this.idaccount, required this.username, required this.password}) : super(key: key);
  @override
  State<Sharea> createState() => _ShareaState();
}

class _ShareaState extends State<Sharea> {
  bool typing = false;
  String text = "";
  String danhGia = 'Tốt';
  String result = "";
  String alert = "";

  String check = "";
  TaiKhoan account = TaiKhoan();
  late TextEditingController _controller;
  String hinhanh = "Hình ảnh";
  File? image;
  @override
  void initState() {
    super.initState();
    String alert = "";
    api_lay_tai_khoan(widget.username, widget.password).then((value1) {
      account = value1;
    });
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller = TextEditingController();
  }

  upload(File imageFile) async {
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://10.0.2.2:8001/api/LuuAnh");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    // ignore: unnecessary_new
    var multipartFile = new http.MultipartFile('file', stream, length, filename: basename(imageFile.path));
    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future getImagefromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
        hinhanh = basename(image.path);
      });
    } on PlatformException catch (e) {
      print('Fail: $e');
    }
  }

  AlshowAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text("Thông báo"),
      content: Text("Chia sẻ thành công"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var dvsize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: const Color.fromRGBO(154, 175, 65, 1), title: Text("Share"), actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 95,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Color.fromRGBO(154, 175, 65, 1)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('http://10.0.2.2:8001/images/' + account.image.toString()),
                      ),
                      Text(
                        account.hoTen.toString(),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: const Text('Trang chủ'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                        return MyHomePage(
                          taiKhoan: account,
                          username: widget.username,
                          password: widget.password,
                        );
                      }, transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      }),
                      (Route route) => false);
                },
              ),ListTile(
                leading: Icon(Icons.list),
                title: const Text('Bài đăng'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                        return Post(
                          account: account,
                          username: widget.username,
                          password: widget.password,
                        );
                      }, transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      }),
                      (Route route) => false);
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: const Text('Thông tin người dùng'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                        return Profile(username: widget.username, password: widget.password);
                      },
                      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: const Text('Đăng xuất'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                          return LoginPage();
                        },
                        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                      (Route route) => false);
                },
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    maxLines: 8,
                    decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
                  ),
                )),
            Text(
              alert,
              style: const TextStyle(color: Colors.red),
            ),
            TextButton(
                onPressed: () async {
                  await getImagefromGallery();
                },
                child: Text(
                  hinhanh,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            IconButton(
              color: Colors.blueGrey,
              icon: Row(
                children: [
                  Icon(Icons.share),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                    "Chia sẻ",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 30),
                  )
                ],
              ),
              onPressed: () {
                if (_controller.text.isEmpty) {
                  setState(() {
                    alert = "Vui lòng nhập đầy đủ thông tin";
                  });
                } else if (_controller.text.length > 300) {
                  setState(() {
                    alert = "Số lượng ký tự phải nhỏ hơn 300";
                  });
                } else {
                  setState(() {
                    if (image != null) {
                      api_Post(_controller.text, widget.id, widget.idaccount, basename(image!.path)).then((value) {
                        upload(image!);
                        AlshowAlertDialog(context);
                      });
                    } else {
                      api_Post(_controller.text, widget.id, widget.idaccount, "").then((value) {
                        setState(() {
                          AlshowAlertDialog(context);
                        });
                      });
                    }

                    _controller.clear();
                  });
                }
              },
            ),
          ],
        ));
  }
}
