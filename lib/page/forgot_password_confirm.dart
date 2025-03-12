import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iov/api/api.dart';
import 'package:iov/localization/language/languages.dart';
import 'package:iov/utils/color_custom.dart';
import 'package:iov/widget/back_ios.dart';

class ForgotPasswordConfirmPage extends StatefulWidget {
  const ForgotPasswordConfirmPage({Key? key, required this.user}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String user;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<ForgotPasswordConfirmPage> {
  @override
  void initState() {
    textUserEditingController.text = widget.user;
    super.initState();
  }

  forgotConfirm(BuildContext context) {
    var param = jsonEncode(<dynamic, dynamic>{
      "userName": textUserEditingController.text,
      "confirmationCode": textEditingController.text,
      "password": textPassEditingController.text,
    });

    Api.post(context, Api.forgot_password_confirm, param).then((value) => {
          if (value != null)
            {Navigator.of(context).popUntil(ModalRoute.withName('/login'))}
          else
            {}
        });
  }

  TextEditingController textEditingController = TextEditingController();
  TextEditingController textUserEditingController = TextEditingController();
  TextEditingController textPassEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                ColorCustom.greyBG2,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            children: [
              const BackIOS(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(bottom: 40, top: 40),
                        child: Text(Languages.of(context)!.confirm_password,
                          style: const TextStyle(color: Colors.black, fontSize: 40),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(Languages.of(context)!.username,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: textUserEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: Languages.of(context)!.forgot_password,
                            hintStyle: const TextStyle(fontSize: 16),
                            // fillColor: colorSearchBg,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(Languages.of(context)!.otp,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: textEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: Languages.of(context)!.otp,
                            hintStyle: const TextStyle(fontSize: 16),
                            // fillColor: colorSearchBg,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(Languages.of(context)!.password,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: textPassEditingController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: Languages.of(context)!.password,
                            hintStyle: const TextStyle(fontSize: 16),
                            // fillColor: colorSearchBg,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorCustom.primaryColor,
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            forgotConfirm(context);
                          },
                          child: Text(Languages.of(context)!.confirm,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
