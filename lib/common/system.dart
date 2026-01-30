import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/services.dart';

class System {
  static System? _instance;

  System._internal();

  factory System() {
    _instance ??= System._internal();
    return _instance!;
  }

  // 简化为仅支持 Android
  bool get isDesktop => false;

  bool get isWindows => false;

  bool get isMacOS => false;

  bool get isAndroid => Platform.isAndroid;

  bool get isLinux => false;

  Future<int> get version async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    return switch (Platform.operatingSystem) {
      'android' => (deviceInfo as AndroidDeviceInfo).version.sdkInt,
      String() => 0,
    };
  }

  // Android 端不需要管理员权限检查
  Future<bool> checkIsAdmin() async {
    return true;
  }

  Future<AuthorizeCode> authorizeCore() async {
    // Android 端使用 VpnService，不需要授权
    return AuthorizeCode.error;
  }

  Future<void> back() async {
    await app?.moveTaskToBack();
  }

  Future<void> exit() async {
    await SystemNavigator.pop();
  }
}

final system = System();

// Android 端不存在 Windows/MacOS/Linux 的 Helper 类
class Windows {
  static Windows? _instance;

  Windows._internal();

  factory Windows() {
    _instance ??= Windows._internal();
    return _instance!;
  }

  bool runas(String command, String arguments) => false;

  Future<WindowsHelperServiceStatus> checkService() async {
    return WindowsHelperServiceStatus.none;
  }

  Future<bool> registerService() async {
    return false;
  }

  Future<bool> registerTask(String appName) async {
    return false;
  }
}

final windows = system.isWindows ? Windows() : null;

class MacOS {
  static MacOS? _instance;

  MacOS._internal();

  factory MacOS() {
    _instance ??= MacOS._internal();
    return _instance!;
  }

  Future<String?> get defaultServiceName async => null;

  Future<List<String>?> get systemDns async => null;

  Future<void> updateDns(bool restore) async {}
}

final macOS = system.isMacOS ? MacOS() : null;
