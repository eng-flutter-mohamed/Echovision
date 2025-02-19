// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';

class LipMovementAnalysisPage extends StatefulWidget {
  const LipMovementAnalysisPage({super.key});

  @override
  _LipMovementAnalysisPageState createState() =>
      _LipMovementAnalysisPageState();
}

class _LipMovementAnalysisPageState extends State<LipMovementAnalysisPage> {
  // متغير لتخزين نتيجة التحليل (يمكن تحديثه لاحقاً)
  String analysisResult = "What are you saying?";
  // متغير لتحديد الكاميرا (أمامية أو خلفية)
  bool isRearCamera = false; // نستخدم الكاميرا الأمامية بشكل افتراضي

  // متغير للتحكم في ظهور محتوى الكاميرا (المعاينة والكابشن)
  bool _cameraVisible = false;
  // متغير لتحديد حالة التسجيل
  bool _isRecording = false;
  // مرجع لحالة الكاميرا للتحكم في التسجيل
  CameraState? _cameraState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.08),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // البادنج حول المحتوى بالكامل
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // زر تسجيل خروج يظهر في الأعلى (محاذي لليمين)
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () {
                  // منطق تسجيل الخروج هنا
                },
                label: const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 10),
            // إذا لم يتم تفعيل الكاميرا بعد، نعرض شاشة فارغة مع زر مركزي (الشتر) لبدء التحليل
            if (!_cameraVisible)
              Expanded(
                child: Column(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // عند الضغط لأول مرة، يتم تفعيل عرض الكاميرا والكابشن
                        setState(() {
                          _cameraVisible = true;
                        });
                      },
                      child: Image.asset(
                        "assets/Images/Shutter2.png",
                        height: 81,
                        width: 81,
                      ),
                    ),
                  ],
                ),
              )
            else
              // عند تفعيل الكاميرا، يتم عرض محتوى الكاميرا والكابشن وأسفلهم صف الأزرار
              Column(
                children: [
                
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 450,
                      width: double.infinity,
                      color: Colors.black87,
                      child: CameraAwesomeBuilder.custom(
                        previewFit:CameraPreviewFit.fitHeight ,
                        sensorConfig: SensorConfig.single(
                          sensor: isRearCamera
                              ? Sensor.position(SensorPosition.back)
                              : Sensor.position(SensorPosition.front),
                          flashMode: FlashMode.always,
                          aspectRatio: CameraAspectRatios.ratio_4_3,
                          zoom: 0.0,
                        ),
                        saveConfig: SaveConfig.photoAndVideo(),
                        mirrorFrontCamera: false,
                        enablePhysicalButton: false,
                        progressIndicator:
                            const Center(child: CircularProgressIndicator()),
                        onImageForAnalysis: (AnalysisImage image) async {
                          // هنا يتم استقبال كل إطار للتحليل (يمكن إرسال الإطار للموديل لاحقاً)
                          await Future.delayed(const Duration(milliseconds: 100));
                          return;
                        },
                        // دالة الـ builder تُستخدم لإضافة overlay إن أردت؛ هنا نقوم بتخزين حالة الكاميرا فقط
                        builder: (CameraState state, Preview preview) {
                          _cameraState = state;
                          return Container();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // الكابشن أسفل محتوى الكاميرا
                  Container(
                    height: 132,
                    width: 386,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      analysisResult,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // صف يحتوي على صورتين: زر تبديل الكاميرا وزر الشتر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // زر تبديل الكاميرا: ينقل بين الكاميرا الأمامية والخلفية
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isRearCamera = !isRearCamera;
                          });
                        },
                        child: Image.asset(
                          "assets/Images/Cameraswap.png",
                          height: 81,
                          width: 81,
                        ),
                      ),
                      const SizedBox(width: 35),
                      // زر الشتر: عند الضغط عليه، حسب حالة الكاميرا يتم بدء أو إيقاف التسجيل
                      GestureDetector(
                        onTap: () {
                          if (_cameraState != null) {
                            _cameraState!.when(
                              onVideoMode: (videoState) {
                                // إذا لم يكن التسجيل جاريًا، نبدأ التسجيل
                                if (!_isRecording) {
                                  videoState.startRecording();
                                  setState(() {
                                    _isRecording = true;
                                  });
                                }
                              },
                              onVideoRecordingMode: (videoRecordingState) {
                                // إذا كان التسجيل جاريًا، نوقف التسجيل
                                if (_isRecording) {
                                  videoRecordingState.stopRecording();
                                  setState(() {
                                    _isRecording = false;
                                  });
                                }
                              },
                          
                            );
                          }
                        },
                        child: Image.asset(
                          "assets/Images/Shutter.png",
                          height: 81,
                          width: 81,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
