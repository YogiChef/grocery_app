// ignore_for_file: use_build_context_synchronously, unused_field, avoid_print

import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/auth/login.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/service/global_methods.dart';
import 'package:grocery_app/widgets/button_widget.dart';
import 'package:grocery_app/widgets/text_input.dart';
import 'package:grocery_app/widgets/text_widget.dart';

import '../consts/conts.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({super.key});

  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  final _emailCtr = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtr.dispose();

    super.dispose();
  }

  bool _isLoading = false;
  void _forgetPassword() async {
    if (_emailCtr.text.isEmpty || !_emailCtr.text.contains('@')) {
      errorDialog('Please enter a correct email address', context);
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        await auth.sendPasswordResetEmail(email: _emailCtr.text.toLowerCase());

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
        Fluttertoast.showToast(
            msg: "An email has been sent to your email address",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade300,
            textColor: Colors.white,
            fontSize: 16.0);
      } on FirebaseException catch (error) {
        errorDialog('$error.message', context);
      } catch (error) {
        print('object');
      } finally {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Swiper(
          duration: 5000,
          autoplayDelay: 5100,
          itemCount: Constss.authImgePaths.length,
          itemBuilder: (context, index) {
            return Image.asset(
              Constss.authImgePaths[index],
              fit: BoxFit.cover,
            );
          },
          autoplay: true,
        ),
        Container(
          color: Colors.black.withOpacity(0.7),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 100,
                ),
                TextWidget(
                  text: 'Welcome Back',
                  color: Colors.white,
                  textSize: 30,
                  isTitle: true,
                ),
                TextWidget(
                  text: 'Sign up to continue',
                  color: Colors.white,
                  textSize: 18,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        TextInput(
                            textInputAction: TextInputAction.done,
                            hintText: 'Email address',
                            keyboardType: TextInputType.text,
                            controller: _emailCtr,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field is missing';
                              } else {
                                return null;
                              }
                            },
                            onEditing: () => _forgetPassword()),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                ButtonWidget(
                  lable: 'Reset now',
                  press: _forgetPassword,
                  color: Colors.white38,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
