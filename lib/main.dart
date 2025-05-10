
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heirloom/routes/app_routes.dart';
import 'package:heirloom/services/internet/connectivity.dart';
import 'package:heirloom/services/internet/no_internet_wrapper.dart';
import 'package:heirloom/themes/light_theme.dart';

import 'Controller/controller_bindings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ConnectivityController());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          theme: light(),
          debugShowCheckedModeBanner: false,
          getPages: AppRoutes.routes,
          initialRoute: AppRoutes.customNavBar,
         initialBinding: ControllerBindings(),


          // builder: (context, child) {
          //   return Scaffold(body: NoInternetWrapper(child: child!));
          // },
          // builder: DevicePreview.appBuilder, // Add this line to wrap the app in DevicePreview.
          // locale: DevicePreview.locale(context), // Adds support for locale preview.
        );
      },
    );
  }
}


