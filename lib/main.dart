/*
 * Copyright 2019 Jacques Supcik
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import 'dart:math';

// import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/keypad.dart';
import 'src/logos.dart';

final Color tpfRed = Color.fromARGB(255, 178, 13, 53);

void main() => runApp(new TPF873App());

class TPF873App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TPF 873',
      theme: new ThemeData(primarySwatch: Colors.red),
      home: new MyHomePage(title: 'TPF 873'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyDelegate extends SingleChildLayoutDelegate {
  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double h = min(constraints.maxHeight, constraints.maxWidth);
    return constraints.copyWith(maxHeight: h, minHeight: h);
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return getConstraintsForChild(constraints).biggest;
  }
}

typedef void ZoneSetter(String s);

class Settings extends StatelessWidget {
  final Future<String> zone;
  final ZoneSetter setZone;

  Settings({
    Key key,
    @required this.zone,
    @required this.setZone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: zone,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return Column(children: <Widget>[
                  DrawerHeader(
                    child: null,
                  ),
                  RadioListTile<String>(
                    title: const Text('Zone 10 (Fribourg)'),
                    value: "10",
                    groupValue: snapshot.data,
                    onChanged: (String value) {
                      setZone(value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Zone 30 (Bulle)'),
                    value: "30",
                    groupValue: snapshot.data,
                    onChanged: (String value) {
                      setZone(value);
                    },
                  ),
                ]);
          }
        });
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _zone;

  Future<Null> _setZone(String zone) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _zone = prefs.setString("zone", zone).then((bool success) {
        return zone;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _zone = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('zone') ?? "10");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        title: widget.title,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: tpfRed,
          accentColor: Colors.orange,
        ),
        home: Scaffold(
          appBar: new AppBar(title: new Text(widget.title)),
          drawer: Drawer(
            child: Settings(zone: _zone, setZone: _setZone),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(
                child: FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: TpfLogoH(),
                    )),
              ),
              Flexible(
                  child: CustomSingleChildLayout(
                      delegate: _MyDelegate(),
                      child: Center(
                          child: FractionallySizedBox(
                        widthFactor: 0.85,
                        heightFactor: 0.85,
                        child: KeyPad(
                          zone: _zone,
                        ),
                      ))))
            ],
          ),
        ));
  }

//  @override
//  void afterFirstLayout(BuildContext context) {
//    // Calling the same function "after layout" to resolve the issue.
//    if (_prefs.then(onValue))
//    showHelloWorld();
//  }
//
//  void showHelloWorld() {
//    showDialog(
//      context: context,
//      builder: (context) => new AlertDialog(
//            title: Text('Information'),
//            content: new Text("Google a mis à jour ses règles relatives à "
//                "la sécurité et principalement celles concernant l'envoi de SMS "
//                "(https://play.google.com/about/privacy-security-deception/). "
//                "Afin de respecter ces règles, TPF873 envoie désormais les SMS "
//                "au travers de votre application SMS par défaut."),
//            actions: <Widget>[
//              new FlatButton(
//                child: new Text("J'ai compris"),
//                onPressed: () => Navigator.of(context).pop(),
//              )
//            ],
//          ),
//    );
//  }

}
