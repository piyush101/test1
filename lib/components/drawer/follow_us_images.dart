import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FollowUsImages extends StatelessWidget {
  final String imagePath;
  final Function onTap;

  const FollowUsImages({
    this.onTap,
    Key key,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        imagePath,
        fit: BoxFit.cover,
        width: 23.0,
        height: 23.0,
      ),
    );
  }
}
