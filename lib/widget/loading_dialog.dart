import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/utils/theme_util.dart';

class LoadingDialog extends StatefulWidget {
  final String loadingText;
  final bool outsideDismiss;
  final Function? dismissDialog;
  const LoadingDialog(
      {super.key,
      this.loadingText = 'loading...',
      this.outsideDismiss = true,
      this.dismissDialog});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  _dismissDialog() {
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    if (widget.dismissDialog != null) {
      widget.dismissDialog!(
          // 将关闭 dialog的方法传递到调用的页面.
          () {
        Get.back();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: Container(
              decoration: ShapeDecoration(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                color: ThemeUtils.dark
                    ? const Color(0xba000000)
                    : const Color(0xffffffff),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      widget.loadingText,
                      style: const TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
