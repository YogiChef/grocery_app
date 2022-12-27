// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/widgets/fetch_page.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../service/global_methods.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.lable,
    this.press,
    this.horizontal = 0,
    this.fontSize = 18,
    this.width,
    this.color = Colors.green,
  }) : super(key: key);
  final String lable;
  final Function()? press;
  final double horizontal;
  final double fontSize;
  final double? width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: MaterialButton(
        onPressed: press,
        child: Text(
          lable,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    Key? key,
    required this.lable,
    this.horizontal = 0,
    this.fontSize = 18,
    this.width,
    this.color = Colors.green,
    this.txtColor = Colors.white,
  }) : super(key: key);
  final String lable;

  final double horizontal;
  final double fontSize;
  final double? width;
  final Color color;
  final Color txtColor;

  Future<void> _googleSignin(BuildContext context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await FirebaseAuth.instance.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          // if (authResult.additionalUserInfo!.isNewUser) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'id': authResult.user!.uid,
            'name': authResult.user!.displayName,
            'email': authResult.user!.email,
            'shipping-address': '',
            'userWish': [],
            'userCart': [],
            'createdAt': Timestamp.now(),
          });
          // }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const FetchPage()));
        } on FirebaseException catch (error) {
          errorDialog('$error.message', context);
        } catch (error) {
          print('object');
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: MaterialButton(
        onPressed: () {
          _googleSignin(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('images/google.png'),
            const SizedBox(
              width: 20,
            ),
            Text(
              lable,
              style: TextStyle(fontSize: fontSize, color: txtColor),
            ),
          ],
        ),
      ),
    );
  }
}

class HeartBtn extends StatelessWidget {
  const HeartBtn({
    super.key,
    required this.proId,
    this.isInWish,
    this.size = 20,
  });
  final String proId;
  final bool? isInWish;
  final double size;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProvduct = productProvider.findProductById(proId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return IconButton(
        onPressed: () async {
          try {
            final User? user = auth.currentUser;
            if (user == null) {
              errorDialog(
                "No user found, Please login first",
                context,
              );
              return;
            }
            if (isInWish == false && isInWish != null) {
              await addToWishlist(productId: proId, context: context);
            } else {
              await wishlistProvider.removeOneItem(
                  wishlistId:
                      wishlistProvider.getWishlistItems[getCurrProvduct.id]!.id,
                  proId: proId);
            }
            await wishlistProvider.fetchWishlist();
          } catch (e) {
            errorDialog('$e', context);
          } finally {}
        },
        icon: Icon(
          isInWish != null && isInWish == true
              ? IconlyBold.heart
              : IconlyLight.heart,
          size: size,
          color: isInWish != null && isInWish == true
              ? Colors.red
              : Colors.black54,
        ));
  }
}
