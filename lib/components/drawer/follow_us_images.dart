import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FollowUsImages extends StatelessWidget {
  final String image_path;
  final Function onTap;

  const FollowUsImages({
    this.onTap,
    Key key,
    this.image_path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // handle your image tap here
      child: SvgPicture.asset(
        image_path,
        fit: BoxFit.cover,
        // this is the solution for border
        width: 23,
        height: 23,
      ),
    );
  }
}
