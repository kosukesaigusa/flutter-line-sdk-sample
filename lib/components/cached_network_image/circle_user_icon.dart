import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleUserIcon extends StatelessWidget {
  CircleUserIcon({
    required this.radius,
    required this.imageURL,
  });
  final double radius;
  final String? imageURL;
  final bool showBorder = false;
  final Color borderColor = Colors.transparent;
  final double borderWidth = 0;

  @override
  Widget build(BuildContext context) {
    if (imageURL == null) {
      return Icon(Icons.person, size: radius);
    }
    return CachedNetworkImage(
      imageUrl: imageURL!,
      imageBuilder: (context, imageProvider) => Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider,
          ),
          border: showBorder
              ? Border.all(
                  color: borderColor,
                  width: borderWidth,
                )
              : null,
        ),
      ),
      placeholder: (context, url) => Container(
        width: radius,
        height: radius,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
      errorWidget: (context, url, dynamic error) => Container(
        width: radius,
        height: radius,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
    );
  }
}
