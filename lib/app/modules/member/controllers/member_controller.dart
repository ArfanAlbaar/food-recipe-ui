import 'dart:html' as html; // for web

import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/models/premium_list.dart';
import 'package:foodrecipeapp/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../StorageMemberService.dart';
import '../member_service.dart';

class MemberController extends GetxController {
  var premiums = <PremiumList>[].obs;
  // Register
  Future<void> registerMember(
      String username, String name, String password, String phoneNumber) async {
    isLoading(true);
    final response = await MemberService.registerMember(
        username, name, password, phoneNumber);

    if (response) {
      isLoading(false);
    } else {
      Get.snackbar('Error', 'Register gagal');
    }
  }

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  final StorageMemberService _storage = StorageMemberService();

  @override
  void onInit() {
    super.onInit();
    final token = _storage.readToken();
    isLoggedIn(token != null);
    fetchCurrentMember();
  }

  //LOGIN
  Future<void> loginMember(String username, String password) async {
    if (username.isEmpty) {
      Get.snackbar('Error', 'Username tidak boleh kosong');
      return;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'Password tidak boleh kosong');
      return;
    }
    isLoading(true);

    try {
      final token = await MemberService.loginMember(username, password);
      if (token != null) {
        _storage.writeToken(token);
        isLoggedIn(true);
        Get.offNamed(Routes.MEMBER);
        Get.snackbar('Success', 'Login berhasil');
        //ARAHKAN KE PREMIUM RECIPE
      } else {
        Get.snackbar('Error', 'Username atau Password salah');
      }
    } catch (e) {
      Get.snackbar('Error', 'Username atau Password salah');
    } finally {
      isLoading(false);
    }
  } //END LOGIN

  final MemberService _memberService = MemberService();
  Future<void> logoutMember() async {
    isLoading(true);
    await _memberService.logoutMember();
    _storage.removeToken();
    isLoggedIn(false);
    isLoading(false);
    Get.offAllNamed(Routes.HOME);
    Get.snackbar("Success", "Logout Berhasil");
  }

  void fetchAllPremiums() async {
    try {
      isLoading(true);
      List<PremiumList> result = await _memberService.getListPremium();
      print(result);
      premiums.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch premiums');
    } finally {
      isLoading(false);
    }
  }

  var isDownloading = false.obs;
  var status = ''.obs;

  Future<void> downloadByMember(int premiumId) async {
    isDownloading.value = true;
    status.value = 'Downloading...';
    try {
      final response = await _memberService.downloadPremiumByMember(premiumId);
      final bytes = response.bodyBytes;
      // Determine file name and extension
      // Determine file name and extension from Content-Disposition header
      // Determine file name and extension from Content-Disposition header
      String fileName = 'file'; // Default file name
      String extension = '.txt'; // Default extension for unknown types

      // Extract filename and extension if available from response headers
      final headerDisposition = response.headers['content-disposition'];
      if (headerDisposition != null &&
          headerDisposition.contains('filename=')) {
        final startIdx =
            headerDisposition.indexOf('filename=') + 'filename='.length;
        final endIdx = headerDisposition.indexOf(';', startIdx);
        fileName =
            headerDisposition.substring(startIdx, endIdx != -1 ? endIdx : null);

        // Replace any double quotes in the filename
        fileName = fileName.replaceAll('"', '');

        if (fileName.isNotEmpty) {
          final dotIndex = fileName.lastIndexOf('.');
          if (dotIndex != -1) {
            extension = fileName.substring(dotIndex);
            fileName = fileName.substring(0, dotIndex);
          }
        }
      }

      // For web: Create a blob and trigger download
      final blob = html.Blob([bytes], 'application/octet-stream');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', '$fileName$extension')
        ..click();

      html.Url.revokeObjectUrl(url);
      isDownloading.value = false;
      status.value = '';

      Get.snackbar('Success', 'File downloaded successfully');
    } catch (e) {
      isDownloading.value = false;
      status.value = 'Failed to download file. Please try again later.';
      Get.snackbar('Error', 'Failed to download file: $e');
    }
  }

  void showNotification(String message) {
    // Implement platform-specific notification here
    // Example: Using platform channels for showing notifications on Android/iOS
  }

  final count = 0.obs;
  void increment() => count.value++;

  // isDownloading.value = false;
  //     status.value = 'Failed to download file, Try Again later';
  Map<String, dynamic>? memberData;

  String? errorMessage;
  final formKey = GlobalKey<FormState>();

  Future<void> fetchCurrentMember() async {
    isLoading(true);

    try {
      memberData = await _memberService.currentMember();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to fetch member data: $e';
    } finally {
      isLoading(false);
    }
  }

  Future<void> createTransaction(String amount) async {
    isLoading(true);
    try {
      final response = await _memberService.createTransaction(amount);
      if (response) {
        Get.snackbar('Success', 'Transaksi berhasil');
      }
    } catch (e) {
      Get.snackbar('Error', 'Transaksi gagal');
    } finally {
      isLoading(false);
    }
  }
}
