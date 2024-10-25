import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<void> saveDeviceInfo(String userId) async {
  var deviceInfo = DeviceInfoPlugin();
  String? deviceId;
  String? deviceName;
  String? brandName;
  String? model;
  String? product;

  // Assuming the app is running on Android or iOS
  if (Platform.isAndroid) {
    var androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
    deviceName = androidInfo.device;
    brandName = androidInfo.brand;
    model = androidInfo.model;
    product = androidInfo.product;
  } else if (Platform.isIOS) {
    var iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor;
    deviceName = iosInfo.name;
    brandName = "None";
    model = iosInfo.model;
    product = "IOS";
  }

  // Get the current time for `lastLogin`
  var lastLogin = Timestamp.now();

  // Reference to Firestore document
  var deviceDoc = FirebaseFirestore.instance
      .collection('users-device')
      .doc(userId)
      .collection('devices')
      .doc(deviceId ?? "None");

  // Save device information
  await deviceDoc.set({
    'deviceName': deviceId, // You can replace this with more descriptive info
    'osVersion': Platform.operatingSystemVersion,
    'lastLogin': lastLogin,
    "name": deviceName ?? "None",
    "brand": brandName,
    "model": model,
    "product": product,
  }, SetOptions(merge: true));
}
