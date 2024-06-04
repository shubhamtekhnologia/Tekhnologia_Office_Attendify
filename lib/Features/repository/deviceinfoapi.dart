import 'dart:io';

import 'package:device_info/device_info.dart';


class DeviceInformation {
  static Future<Map<String, String>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, String> deviceInfoMap = {};

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceInfoMap['deviceId'] = androidInfo.androidId;
        print( deviceInfoMap['deviceId'] );
        // deviceInfoMap['deviceName'] = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceInfoMap['deviceId'] = iosInfo.identifierForVendor;
        // deviceInfoMap['deviceName'] = iosInfo.name;
      }
    } catch (e) {
      print('Failed to get device info: $e');
    }

    return deviceInfoMap;
  }
}