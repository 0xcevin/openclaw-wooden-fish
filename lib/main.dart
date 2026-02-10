import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Wooden Fish',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WoodenFishScreen(),
    );
  }
}

class WoodenFishScreen extends StatefulWidget {
  const WoodenFishScreen({super.key});

  @override
  State<WoodenFishScreen> createState() => _WoodenFishScreenState();
}

class _WoodenFishScreenState extends State<WoodenFishScreen> {
  int _counter = 0;
  bool _showFlash = false;

  void _incrementCounter() {
    setState(() {
      _counter += 2;  // Changed from ++ to += 2 for testing CICD
      _showFlash = true;
    });

    // 触发震动反馈 (仅在支持的设备上)
    // 注意：为了让 APK 极简，我们不引入额外的音效库，只保留震动。
    // 如果需要音效，后续可以加进来。
    _triggerHapticFeedback();

    // 0.5秒后隐藏闪光
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) { // 防止 widget 被销毁后还调用 setState
        setState(() {
          _showFlash = false;
        });
      }
    });
  }

  void _triggerHapticFeedback() {
    // 这个方法调用不会报错，即使设备不支持震动
    // 但如果要在 AndroidManifest.xml 里声明权限，APK 会更大一点。
    // 我们先不声明权限，让系统自行处理。
    // HapticFeedback.lightImpact(); // 替换为更通用的
    HapticFeedback.selectionClick(); // 这个感觉更像敲击
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 木鱼图片或按钮 (这里用一个圆形按钮代替)
            GestureDetector(
              onTap: _incrementCounter,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.brown.shade800, // 深棕色，像木头
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 5), // 阴影位置
                    ),
                  ],
                ),
                child: Icon(
                  Icons.sentiment_very_satisfied, // 用一个开心的图标代替木鱼图片
                  size: 100,
                  color: Colors.yellow.shade600, // 图标颜色
                ),
              ),
            ),
            // 功德值显示
            Positioned(
              bottom: 100, // 调整位置
              child: Text(
                '功德 + $_counter',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            // 闪光效果
            if (_showFlash)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}