import 'package:flutter/material.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';
import './screens/order_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/manage_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
          accentColor: Colors.red,
          buttonColor: const Color(0xff162950),
          textTheme:
              GoogleFonts.muliTextTheme(Theme.of(context).textTheme).copyWith(
            bodyText1: GoogleFonts.muli(
              textStyle: TextStyle(
                  color: const Color(0xffffffff),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            bodyText2: GoogleFonts.muli(
              textStyle: TextStyle(
                color: const Color(0xff162950),
                fontSize: 20,
              ),
            ),
            subtitle1: GoogleFonts.muli(
              textStyle: TextStyle(
                color: const Color(0xff162950),
                fontSize: 18,
              ),
            ),
            subtitle2: GoogleFonts.muli(
              textStyle: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            headline1: GoogleFonts.muli(
              textStyle: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            headline2: GoogleFonts.muli(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            headline5: GoogleFonts.muli(
              textStyle: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => AuthScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          ManageProductsScreen.routeName: (ctx) => ManageProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
