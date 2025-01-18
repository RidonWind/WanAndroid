import 'package:flutter/material.dart';

///点赞 喜欢 组件
class LikeButtonWidget extends StatefulWidget {
  final bool isLike;
  final Function onTap;
  const LikeButtonWidget(
      {super.key, required this.isLike, required this.onTap});

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

//with TickerProviderStateMixin 动画
class _LikeButtonWidgetState extends State<LikeButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  double size = 24.0;

  @override
  void initState() {
    super.initState();
    //加了with TickerProviderStateMixin才有vsync: this
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    animation = Tween(begin: size, end: size * 0.5).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: LikeAnimation(
          controller: controller,
          animation: animation,
          isLike: widget.isLike,
          onTap: widget.onTap,
          listenable: controller,
        ));
  }
}

class LikeAnimation extends AnimatedWidget implements StatefulWidget {
  final AnimationController controller;
  final Animation animation;
  final bool isLike;
  final Function onTap;
  const LikeAnimation({
    super.key,
    required this.controller,
    required this.animation,
    this.isLike = false,
    required this.onTap,
    required super.listenable,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        isLike ? Icons.favorite : Icons.favorite_border,
        size: animation.value,
        color: isLike ? Colors.redAccent : Colors.grey[600],
      ),
      onTapDown: (details) {
        controller.forward(); //向前
      },
      onTapUp: (details) {
        Future.delayed(const Duration(milliseconds: 100), () {
          controller.reverse(); //逆向
          onTap(); //回调函数 被点击后处理收藏或取消收藏
        });
      },
    );
  }
}
