// ignore_for_file: use_build_context_synchronously, prefer_if_null_operators, unnecessary_null_comparison, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/auth/forget_pass.dart';
import 'package:grocery_app/auth/login.dart';
import 'package:grocery_app/pages/loading_manager.dart';
import 'package:grocery_app/service/global_methods.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../consts/firebase_const.dart';
import '../providers/dark_theme_provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _addressContr = TextEditingController(text: '');
  final User? user = auth.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  String? email;
  String? name;
  String? address;
  bool _isLoading = false;
  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        email = userDoc.get('email');
        name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressContr.text = userDoc.get('shipping-address');
      }
    } catch (errer) {
      setState(() {
        _isLoading = false;
      });
      errorDialog('$errer', context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    final Color color = themeState.getDarkTheme ? Colors.white70 : Colors.black;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Hi,  ',
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                    TextSpan(
                        text: name == null ? 'MyName' : name,
                        style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ('My name is Prasprintert');
                          })
                  ])),
              const SizedBox(
                height: 5,
              ),
              TextWidget(
                text: email == null ? 'email@gmail.com' : email!,
                color: color,
                textSize: 18,
              ),
              Divider(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                thickness: 2,
              ),
              _listTiles(
                title: 'Address',
                subtitle: address == null
                    ? '173 M. 1 T. Nongpusta Sopisai Buengkan 38170'
                    : address,
                icon: IconlyLight.profile,
                color: color,
                pressed: () async {
                  await _showAddressDialog();
                },
              ),
              _listTiles(
                title: 'Order',
                icon: IconlyLight.bag,
                color: color,
                pressed: () {
                  Navigator.pushNamed(context, 'order');
                },
              ),
              _listTiles(
                title: 'wishlist',
                icon: IconlyLight.heart,
                color: color,
                pressed: () {
                  Navigator.pushNamed(context, 'wishlist');
                },
              ),
              _listTiles(
                title: 'Viewed',
                icon: IconlyLight.show,
                color: color,
                pressed: () {
                  if (user == null) {
                    errorDialog('No user found, Please login first', context);
                    return;
                  }
                  Navigator.pushNamed(context, 'viewed_recently');
                },
              ),
              _listTiles(
                title: 'Forget password',
                icon: IconlyLight.unlock,
                color: color,
                pressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPassPage()));
                },
              ),
              SwitchListTile(
                  title: TextWidget(
                    text: themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                    color: color,
                    isTitle: true,
                    textSize: 20,
                  ),
                  secondary: Icon(themeState.getDarkTheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined),
                  onChanged: (value) {
                    themeState.setDarkTheme = value;
                  },
                  value: themeState.getDarkTheme),
              _listTiles(
                title: user == null ? 'Login' : 'Logout',
                icon: user == null ? IconlyLight.login : IconlyLight.logout,
                color: color,
                pressed: () {
                  if (user == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                    return;
                  }
                  warningDialog('Sign Out', 'Do you wanna sign Out ?',
                      () async {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                    await auth.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  }, context, 'images/cycle.json');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: _addressContr,
              onChanged: (value) {},
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Your address'),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String _uid = user!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .update({
                      'shipping-address': _addressContr.text,
                    });
                    Navigator.pop(context);
                    setState(() {
                      address = _addressContr.text;
                    });
                  } catch (error) {
                    errorDialog(error.toString(), context);
                  }
                },
                child: const Text('Update'),
              )
            ],
          );
        });
  }

  ListTile _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function()? pressed,
    Color? color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color!,
        isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle ?? '',
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: pressed,
    );
  }
}
