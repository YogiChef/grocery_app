import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/auth/forget_pass.dart';
import 'package:grocery_app/auth/login.dart';
import 'package:grocery_app/auth/sign_up.dart';
import 'package:grocery_app/consts/theme_data.dart';
import 'package:grocery_app/inner/categ_page.dart';
import 'package:grocery_app/inner/feed_page.dart';
import 'package:grocery_app/inner/on_sale_page.dart';
import 'package:grocery_app/inner/product_detail.dart';
import 'package:grocery_app/orders/order_page.dart';
import 'package:grocery_app/pages/cart/cart_page.dart';
import 'package:grocery_app/providers/dark_theme_provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/order_provider.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/providers/view_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/viewed/viewed_recently.dart';
import 'package:grocery_app/widgets/fetch_page.dart';
import 'package:grocery_app/wishlist/wishlist_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        (await themeChangeProvider.darkThemeP.getTheme())!;
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> fireInitial = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fireInitial,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
                home: Scaffold(
              body: Center(
                child: Text('An error occured'),
              ),
            ));
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(create: (_) => ProductProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
              ChangeNotifierProvider(create: (_) => WishlistProvider()),
              ChangeNotifierProvider(create: (_) => ViewProvider()),
              ChangeNotifierProvider(create: (_) => OrdersProvider()),

            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                  // initialRoute: 'login',
                  home: const FetchPage(),
                  routes: {
                    'login': (context) => const LoginPage(),
                    'forget_password': (context) => const ForgetPassPage(),
                    'sign_up': (context) => const SignUpPage(),
                    'on_sale': (context) => const OnSalePage(),
                    'feed_page': (context) => const FeedPage(),
                    ProductDetails.routeName: (context) =>
                        const ProductDetails(),
                    CategoryPage.routeName: (context) => const CategoryPage(),
                    CartPage.routeName: (context) => const CartPage(),
                    'wishlist': (context) => const WishlistPage(),
                    'order': (context) => const OrderPage(),
                    'viewed_recently': (context) => const ViewedRecently(),
                  },
                );
              },
            ),
          );
        });
  }
}
