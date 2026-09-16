 import 'package:flutter/material.dart';

 enum NavigatorType {
   push,
   pushReplacement,
   pushAndRemoveUntil,
 }

 abstract class MyNavigator {
   static Future<T?> goTo<T>(
     BuildContext context, {
     required Widget toPage,
     NavigatorType type = NavigatorType.push,
   }) {
     Route<T> route = MaterialPageRoute(
      builder: (context) => toPage,
     );

     if (type == NavigatorType.push) {
       return Navigator.push<T>(
         context,
        route as Route<T>,
       );
     } 
    
     else if (type == NavigatorType.pushReplacement) {
       return Navigator.pushReplacement<T, T>(
                context,
                route as Route<T>,
              );
     } 
    
     else {
       return Navigator.pushAndRemoveUntil<T>(
         context,
       route as Route<T>,
        (r) => false,
     );
   }
   }
 }