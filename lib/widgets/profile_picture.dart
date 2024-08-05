import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {

  final String title;
  final String image;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const ProfilePicture({
    super.key,
    required this.title,
    required this.image,
    required this.size,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final defaultBackgroundColor = Theme.of(context).highlightColor;

    return Container(
      clipBehavior: Clip.hardEdge,
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title.isNotEmpty ? title.substring(0,1).toUpperCase() : '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size/2.5,
              fontWeight: FontWeight.bold,
              color: color ?? defaultColor
            ),
          ),
          Visibility(
            visible: image.isNotEmpty,
            child: CachedNetworkImage(
              width: size,
              height: size,
              fit: BoxFit.cover,
              imageUrl: image
            ),
          ),
        ],
      )
    );
  }
}