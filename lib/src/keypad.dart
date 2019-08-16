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

import 'package:flutter/material.dart';
import 'big_button.dart';

class KeyPad extends StatelessWidget {
  final Future<String> zone;

  KeyPad({
    Key key,
    @required this.zone,
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
                return  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: BigButton(
                                  text: snapshot.data,
                                  sms: snapshot.data,
                                )),
                            Expanded(child: BigButton(
                                text: snapshot.data + "R",
                                sms: snapshot.data + "R"
                            )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(child: BigButton(
                                  text: "J" + snapshot.data,
                                  sms: "J" + snapshot.data
                              )),
                              Expanded(child: BigButton(
                                  text: "J" + snapshot.data + "R",
                                  sms: "J" + snapshot.data + "R"
                              )),
                            ]),
                      ),
                    ]);
          }
        });
  }
}
