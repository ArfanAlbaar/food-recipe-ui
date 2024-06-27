import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/home/views/splash_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init(); // Initialize GetStorage
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      // initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      home: const SplashScreen(),
    ),
  );
}
