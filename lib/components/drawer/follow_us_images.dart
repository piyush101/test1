import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FollowUsImages extends StatelessWidget {
  final String Image_Path;
  final Function OnTap;

  const FollowUsImages({
    this.OnTap,
    Key key,
    this.Image_Path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: OnTap,
      child: SvgPicture.asset(
        Image_Path,
        fit: BoxFit.cover,
        width: 23,
        height: 23,
      ),
    );
  }
}
