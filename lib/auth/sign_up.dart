// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/pages/loading_manager.dart';
import 'package:grocery_app/service/global_methods.dart';
import 'package:grocery_app/widgets/button_widget.dart';
import 'package:grocery_app/widgets/fetch_page.dart';
import 'package:grocery_app/widgets/text_input.dart';
import 'package:grocery_app/widgets/text_widget.dart';

import '../consts/conts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _fullNameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _passCtr = TextEditingController();
  final _addresslCtr = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    _fullNameCtr.dispose();
    _emailCtr.dispose();
    _passCtr.dispose();
    _addresslCtr.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitSignUp() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        await auth.createUserWithEmailAndPassword(
          email: _emailCtr.text.toLowerCase().trim(),
          password: _passCtr.text.trim(),
        );
// Connect to FirebaseFireStore ************
        final User? user = auth.currentUser;
        final _uid = user!.uid;
        user.updateDisplayName(_fullNameCtr.text);
        user.reload();
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameCtr.text,
          'email': _emailCtr.text.toLowerCase(),
          'shipping-address': _addresslCtr.text,
          'userWish': [],
          'userCart': [],
          'createdAt': Timestamp.now(),
        });
        _formKey.currentState!.reset();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const FetchPage()));
      } on FirebaseException catch (error) {
        errorDialog(
          '${error.message}',
          context,
        );
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        errorDialog(
          '$error',
          context,
        );
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(children: [
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
                              textInputAction: TextInputAction.next,
                              hintText: 'Full name',
                              keyboardType: TextInputType.text,
                              controller: _fullNameCtr,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is missing';
                                } else {
                                  return null;
                                }
                              },
                              onEditing: () =>
                                  FocusScope.of(context).requestFocus(
                                    _emailFocusNode,
                                  )),
                          const SizedBox(
                            height: 25,
                          ),
                          TextInput(
                              textInputAction: TextInputAction.next,
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailCtr,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                } else {
                                  return null;
                                }
                              },
                              onEditing: () =>
                                  FocusScope.of(context).requestFocus(
                                    _passFocusNode,
                                  )),
                          const SizedBox(
                            height: 25,
                          ),
                          TextInput(
                            textInputAction: TextInputAction.next,
                            hintText: 'Password',
                            keyboardType: TextInputType.visiblePassword,
                            focusNode: _passFocusNode,
                            obscureText: _obscureText,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(
                                  _obscureText == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                )),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 8) {
                                return 'Please enter a valid password';
                              } else {
                                return null;
                              }
                            },
                            controller: _passCtr,
                            onEditing: () => FocusScope.of(context)
                                .requestFocus(_addressFocusNode),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextInput(
                            textInputAction: TextInputAction.done,
                            hintText: 'Shipping address',
                            keyboardType: TextInputType.text,
                            controller: _addresslCtr,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 12) {
                                return 'Please enter a valid address';
                              } else {
                                return null;
                              }
                            },
                            onEditing: () => _submitSignUp(),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ButtonWidget(
                          lable: 'Sign Up',
                          press: _submitSignUp,
                          color: Colors.white38,
                          width: double.infinity,
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      )),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget(
                        text: 'OR',
                        color: Colors.white,
                        isTitle: true,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Expanded(
                          child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Already a user?',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        children: [
                          TextSpan(
                              text: ' Sign in',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, 'login');
                                })
                        ]),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
