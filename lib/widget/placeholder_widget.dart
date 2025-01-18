import 'package:flutter/material.dart';

///图片加载占位符组件
class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(
          // 定义圆形进度指示器的线条宽度(默认4.0)
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
