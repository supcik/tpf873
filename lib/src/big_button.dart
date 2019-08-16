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
import 'package:android_intent/android_intent.dart';

class BigButton extends StatelessWidget {
  final String text;
  final String sms;
  static const sizingFactor = 0.93;

  BigButton({
    Key key,
    @required this.text,
    @required this.sms,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: sizingFactor,
      widthFactor: sizingFactor,
      child: RaisedButton(
              onPressed: () {
                  AndroidIntent intent = new AndroidIntent(
                    action: 'android.intent.action.SENDTO',
                    data: 'smsto:873',
                    arguments: {'sms_body': this.sms},
                  );
                  intent.launch();
              },
              color: Colors.amber,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Center(
                child: Text(
                  this.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.w700,

                  )
                  //style: Theme.of(context).textTheme.display2,
                ),
              ),
            ),
    );
  }
}
