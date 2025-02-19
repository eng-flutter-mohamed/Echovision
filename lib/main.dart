import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app/screens/splash_screen.dart';
Future<void> requestPermissions() async {
  // طلب إذن الكاميرا والميكروفون
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
  ].request();

  if (statuses[Permission.camera] != PermissionStatus.granted ||
      statuses[Permission.microphone] != PermissionStatus.granted) {
    // إذا لم تُمنح الأذونات، يمكنك عرض رسالة للمستخدم
    debugPrint('لم يتم منح أذونات الكاميرا أو الميكروفون');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  runApp(const EchovisionApp());
}

class EchovisionApp extends StatelessWidget {
  const EchovisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
    );
  }
}
