// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

import '../auth/login.dart';
import '../consts/firebase_const.dart';

Future<void> warningDialog(
  String title,
  String subtitle,
  Function()? press,
  BuildContext context,
  String? img,
) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Lottie.asset(
                img!,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(title),
            ],
          ),
          content: Text(
            subtitle,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Cancle'),
            ),
            TextButton(
              onPressed: press,
              child: TextWidget(
                text: 'Ok',
                color: Colors.red,
                isTitle: true,
                textSize: 20,
              ),
            )
          ],
        );
      });
}

Future<void> errorDialog(
  String subtitle,
  BuildContext context,
) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Lottie.asset(
                'images/error.json',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('Error occured')
            ],
          ),
          content: Text(
            subtitle,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Cancle', style: TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () async {
                final User? use = auth.currentUser;
                if (use == null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                  return;
                }
                await auth.signOut();
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
          ],
        );
      });
}

Future<void> addToCart({
  required String productId,
  required int qty,
  required BuildContext context,
}) async {
  final User? user = auth.currentUser;
  final _uid = user!.uid;
  final cartId = const Uuid().v4();
  try {
    FirebaseFirestore.instance.collection('users').doc(_uid).update({
      'userCart': FieldValue.arrayUnion([
        {
          'cartId': cartId,
          'proId': productId,
          'qty': qty,
        }
      ])
    });
    await Fluttertoast.showToast(
        msg: "Product has been added to yout cart",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade300,
        textColor: Colors.black,
        fontSize: 16.0);
  } catch (e) {
    errorDialog(e.toString(), context);
  }
}

Future<void> addToWishlist({
  required String productId,
  required BuildContext context,
}) async {
  final User? user = auth.currentUser;
  final _uid = user!.uid;
  final wistlistId = const Uuid().v4();
  try {
    FirebaseFirestore.instance.collection('users').doc(_uid).update({
      'userWish': FieldValue.arrayUnion([
        {
          'wishlistId': wistlistId,
          'proId': productId,
        }
      ])
    });
    await Fluttertoast.showToast(
        msg: "Product has been added to yout wishlist",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade300,
        textColor: Colors.black,
        fontSize: 16.0);
  } catch (e) {
    errorDialog(e.toString(), context);
  }
}
