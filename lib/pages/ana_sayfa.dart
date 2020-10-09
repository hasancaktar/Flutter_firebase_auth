import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../main.dart';

class AnaSayfa extends StatefulWidget {
  String mail, sifre;

  AnaSayfa({this.mail, this.sifre});

  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Anasayfa"),
        actions: [
          IconButton(
              icon: FaIcon(FontAwesomeIcons.signOutAlt),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Çıkış Yap"),
                        content: Text("Emin misiniz?"),
                        actions: [
                          FlatButton(
                            child: Text("Hayır"),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Evet"),
                            onPressed: (){
                              setState(() {
                                _auth.signOut();
                                print(_auth.currentUser.email);
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                              });

                            },
                          )

                        ],
                      );
                    });
              }),
        ],
      ),
      body: Text(widget.mail.toString()),
    );
  }
//
// _showDialog() {
//   // flutter defined function
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       // return object of type Dialog
//       return AlertDialog(
//         title: new Text("Çıkış Yap"),
//         content: Text("Çıkış yapmak istediğinize emin misiniz?"),
//         //content: new Text("Alert Dialog body"),
//         actions: <Widget>[
//           // usually buttons at the bottom of the dialog
//           new FlatButton(
//             child: new Text("Evet"),
//             onPressed: () {
//               setState(() {
//                 _auth.signOut();
//
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                     '/', (Route<dynamic> route) => false);
//               });
//             },
//           ),
//           new FlatButton(
//             child: new Text("Hayır"),
//             onPressed: () {
//               setState(() {
//                 Navigator.pop(context);
//               });
//             },
//           )
//         ],
//       );
//     },
//   );
// }
}
