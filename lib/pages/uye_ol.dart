import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseyeni/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UyeOl extends StatefulWidget {
  UyeOl({Key key}) : super(key: key);

  @override
  _UyeOlState createState() => _UyeOlState();
}

class _UyeOlState extends State<UyeOl> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _mailController = TextEditingController();
  final _sifreController = TextEditingController();
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                          Colors.pink,
                          Colors.pinkAccent,
                          Colors.orangeAccent,
                        ])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.70,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Column(
                            //  crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Form(
                                key: _formKey,
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 25, left: 25, bottom: 25),
                                      child: TextFormField(
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            suffixIcon: Icon(Icons.person),
                                            labelText: "Ad"),

                                        ///  validator: (value) => value.isEmpty
                                        ///      ? "Lütfen geçerli bir isim girin"
                                        ///     : null,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 25, left: 25, bottom: 25),
                                      child: TextFormField(
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            suffixIcon: Icon(Icons.person),
                                            labelText: "Soyad"),

                                        ///  validator: (value) => value.isEmpty
                                        ///      ? "Lütfen geçerli soyad girin"
                                        ///      : null,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 25, left: 25, bottom: 25),
                                      child: TextFormField(
                                          controller: _mailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              suffixIcon: Icon(Icons.mail),
                                              hintText: "ornek@mail.com",
                                              labelText: "Email"),
                                          validator: (value) => EmailValidator
                                                  .validate(value)
                                              ? null
                                              : 'Lütfen geçerli bir mail adresi girin.'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 25, left: 25),
                                      child: TextFormField(
                                          controller: _sifreController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              suffixIcon: Icon(Icons
                                                  .admin_panel_settings_rounded),
                                              hintText: "******",
                                              labelText: "Şifre"),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Lütfen şifre girin";
                                            }
                                            if (value.length < 6) {
                                              return "Şifre en az 6 haneli olmalı";
                                            }
                                            return null;
                                          }),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset:
                                                    Offset(0.0, 8.0), //(x,y)
                                                blurRadius: 4.0,
                                              ),
                                            ],
                                            gradient: LinearGradient(
                                                colors: <Color>[
                                                  Colors.blue,
                                                  Colors.blueAccent,
                                                  Colors.lightBlueAccent
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Center(
                                            child: Text(
                                          "Üye Ol",
                                          style: GoogleFonts.sansita(
                                              fontSize: 35,
                                              color: Colors.white),
                                        )),
                                      ),
                                      onTap: () {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            _uyeOl();
                                            isLoading = true;
                                          });
                                        }
                                        debugPrint("23456");
                                        // Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }

  void _uyeOl() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _mailController.text,
        password: _sifreController.text,
      )
          .then((authReseult) {
        var firebaseUser = authReseult.user;
        if (firebaseUser != null) {
          firebaseUser.sendEmailVerification().then((value) {
            setState(() {
              isLoading = false;
              _showDialog("Maili Onayla",
                  "Mailinize onay linki gönderildi. Lütfen kontrol edin");
            });
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('şifre zayıf.');
        setState(() {
          isLoading = false;
          _showScaffold("Bu mail zaten kullanılıyor!");
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          isLoading = false;
          _showScaffold("Bu mail zaten kullanılıyor!");
        });
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _showDialog(String title, String content) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: Text(content),
          //content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Tamam"),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
