import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wan_andriod/widget/placeholder_widget.dart';

///自定义带缓存的Image
class CustomCachedNetworkImage extends StatelessWidget {
  ///图片链接
  final String imageUrl;

  ///图片填充方式
  final BoxFit fit;

  ///常量构造函数
  const CustomCachedNetworkImage(
      {super.key, required this.imageUrl, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    //如果url是'' 返回一个Container(height:0),不为空用缓存图片插件CachedNetworkImage返回图片
    return imageUrl.isEmpty
        ? Container(
            height: 0,
          )
        : CachedNetworkImage(
            //网络图片的完整URL
            imageUrl: imageUrl,
            //图片填充方式(默认BoxFit.cover)
            fit: fit,
            //占位符  PlaceholderWidget() 转圈圈的图标加上长宽 点位符组件
            placeholder: (context, url) => const PlaceholderWidget(),
            //图片获取错误显示图标
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
  }
}
