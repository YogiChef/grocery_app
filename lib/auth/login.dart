// ignore_for_file: use_build_context_synchronously

import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/pages/loading_manager.dart';
import 'package:grocery_app/widgets/button_widget.dart';
import 'package:grocery_app/widgets/fetch_page.dart';
import 'package:grocery_app/widgets/text_input.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import '../consts/conts.dart';
import '../consts/firebase_const.dart';
import '../service/global_methods.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtr = TextEditingController();
  final _passCtr = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailCtr.dispose();
    _passCtr.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await auth.signInWithEmailAndPassword(
          email: _emailCtr.text.toLowerCase().trim(),
          password: _passCtr.text.trim(),
        );
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
                    text: 'Sign in to continue',
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
                            textInputAction: TextInputAction.done,
                            hintText: 'Password',
                            keyboardType: TextInputType.visiblePassword,
                            onEditing: () => _submitLogin(),
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
                          )
                        ],
                      )),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'forget_password');
                      },
                      child: const Text(
                        'Forget Password?',
                        style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    lable: 'Login',
                    press: _submitLogin,
                    color: Colors.white38,
                    width: double.infinity,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const GoogleButton(
                    lable: 'Sign in with Google',
                    width: double.infinity,
                    color: Colors.white,
                    txtColor: Colors.red,
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
                  ButtonWidget(
                    lable: 'Continue as a guest',
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FetchPage()));
                    },
                    color: Colors.black87,
                    width: double.infinity,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Don\'t have an account?',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        children: [
                          TextSpan(
                              text: ' Sign Up',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, 'sign_up');
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
