import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:template/Api/api.dart';

class Add extends StatefulWidget {
  Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  late TextEditingController tendiadanh;
  late TextEditingController vitri;
  late TextEditingController mota;
  late TextEditingController kinhdo;
  late TextEditingController vido;
  late TextEditingController nhucau;
  String state = "";
  String check = "2";
  String warrning = "";
  String findshoose = "";
  String hint = "Phượt";
  TextEditingController name = TextEditingController();
  String hinhanh = "Hình ảnh";
  File? image;
  @override
  void initState() {
    super.initState();
    tendiadanh = TextEditingController();
    vitri = TextEditingController();
    mota = TextEditingController();
    kinhdo = TextEditingController();
    vido = TextEditingController();
    nhucau = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    tendiadanh.dispose();
    vido.dispose();
    vitri.dispose();
    mota.dispose();
    kinhdo.dispose();
    nhucau.dispose();
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

  String buildString(String word) {
    final arr = word.split('');
    String a = "";
    if (arr.length > 30) {
      for (int i = 0; i < 30; i++) {
        a = a + "" + arr[i];
      }
      return a;
    } else {
      return arr.join("");
    }
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(154, 175, 65, 1),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back))),
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(154, 175, 65, 1),
        body: Center(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                child: Column(
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(fit: BoxFit.cover, image: AssetImage("images/VV_icon.png")),
                    //     border: Border.all(color: Colors.white, width: 5),
                    //     borderRadius: BorderRadius.all(Radius.circular(250)),
                    //   ),
                    //   height: 100,
                    //   width: 100,
                    // ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    TextField(
                        controller: tendiadanh,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: 'Tên địa danh',
                            labelStyle: TextStyle(color: Colors.black))),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    TextField(
                      controller: vitri,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Vị trí',
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    TextField(
                      controller: mota,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Mô tả',
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          DropdownButton<String>(
                            items: <String>[
                              'Phượt',
                              'Nghĩ dưỡng',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: findshoose = value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (findchoose) {
                              setState(() {
                                hint = findshoose;
                              });
                            },
                          ),
                          Text(hint)
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    TextField(
                      controller: kinhdo,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Kinh độ',
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    TextField(
                      controller: vido,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Vĩ độ',
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        warrning,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: () async {
                                await getImagefromGallery();
                              },
                              child: Text(
                                buildString(hinhanh),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: SizedBox(
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              if (tendiadanh.text == "" ||
                                  vitri.text == "" ||
                                  mota.text == "" ||
                                  findshoose == "" ||
                                  hinhanh == "" ||
                                  kinhdo.text == "" ||
                                  vido.text == "") {
                                setState(() {
                                  warrning = "Vui lòng nhập đầy đủ thông tin";
                                });
                              } else {
                                state = '0';
                                api_Add(tendiadanh.text, findshoose, vitri.text, mota.text, hinhanh, kinhdo.text, vido.text).then((value) {
                                  setState(() {
                                    upload(image!);
                                    state = '4';
                                  });
                                });
                              }
                            },
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black)),
                            child: state == ""
                                ? Container(
                                    height: 20,
                                    child: Text(
                                      "Thêm",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                : state == "0"
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text('Thêm thành công'),
                          )),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
