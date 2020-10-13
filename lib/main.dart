import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseyeni/pages/ana_sayfa.dart';
import 'package:firebaseyeni/pages/uye_ol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => MyHomePage(),
        '/uyeol': (context) => UyeOl(),
        '/anasayfa': (context) => AnaSayfa(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 80),
                      Image.asset(
                        "assets/crm_icon.png",
                        height: 150,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.64,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "hoş geldiniz",
                              style: GoogleFonts.lobster(fontSize: 40),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 25, left: 25, bottom: 25),
                                    child: TextFormField(
                                      controller: _mailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          suffixIcon:
                                              FaIcon(FontAwesomeIcons.envelope),
                                          hintText: "ornek@mail.com",
                                          labelText: "Email"),
                                      validator: (val) =>
                                          !EmailValidator.validate(val, true)
                                              ? 'Not a valid email.'
                                              : null,
                                    ),
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
                                                    BorderRadius.circular(15)),
                                            suffixIcon: FaIcon(
                                                FontAwesomeIcons.eyeSlash),
                                            hintText: "******",
                                            labelText: "Şifre"),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Lütfen şifrenizi girin";
                                          }
                                          if (value.length < 6) {
                                            return "Şifre en az 6 karakter olmalı";
                                          } else {
                                            return null;
                                          }
                                        }),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                          right: 25,
                                        ),
                                        child: Text(
                                          "Şifremi Unuttum",
                                          style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 17),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
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
                                                  Colors.pink,
                                                  Colors.red,
                                                  Colors.deepOrange
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Center(
                                            child: Text(
                                          "Giriş",
                                          style: GoogleFonts.sansita(
                                              fontSize: 35,
                                              color: Colors.white),
                                        )),
                                      ),
                                      onTap: () {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            _girisYap(context);
                                            isLoading = true;
                                          });
                                        }

                                        // if (_formKey.currentState.validate()) {
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) => AnaSayfa(
                                        //                 mail: _mailController.text,
                                        //               )));
                                      }),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0.0, 8.0), //(x,y)
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
                                            fontSize: 35, color: Colors.white),
                                      )),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UyeOl()));
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
      ),
    );
  }

  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _girisYap(BuildContext context) async {
    await _auth
        .signInWithEmailAndPassword(
            email: _mailController.text, password: _sifreController.text)
        .then((oturumAcmisKullaniciAuthResoult) {
      var oturumAcmisKullanici = oturumAcmisKullaniciAuthResoult.user;

      if (oturumAcmisKullanici.emailVerified) {
        print("oturum açıldı");

        _showScaffold("Oturum AÇILDI");

        Navigator.of(context).pushNamedAndRemoveUntil(
            '/anasayfa', (Route<dynamic> route) => false);
      }
      if (!oturumAcmisKullanici.emailVerified) {
        setState(() {
          print("mail onaylı değil.");
          isLoading=false;
          _showScaffold("Lütfen mailinizi onaylayın");
          _auth.signOut();
        });

      }


    }).catchError((hata) {
      print(hata.toString());
      setState(() {
        _showScaffold("Mail veya Şifre hatalı");
        isLoading = false;
      });
    });
  }
}
