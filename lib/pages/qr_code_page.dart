import 'package:flutter/material.dart';
import 'package:wan_andriod/utils/gaps_util.dart';
import 'package:wan_andriod/utils/utils.dart';

/// 扫码下载页面
class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        title: const Text('扫码下载'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            //c1
            const SizedBox(height: 30),
            //c2
            const Text(
              "好用的话推荐给你的小伙伴吧",
              style: TextStyle(fontSize: 14),
            ),
            //c3
            GapsUtil.gapH5,
            //c4
            const Text(
              "（ 建议使用浏览器扫描二维码下载 ^_^ ）",
              style: TextStyle(fontSize: 14),
            ),
            //c5
            const SizedBox(height: 60),
            //c6
            Image.asset(
              Utils.getImagePath('qr_code'),
              width: 260.0,
              fit: BoxFit.fill,
              height: 260.0,
            )
          ],
        ),
      ),
    );
  }
}
