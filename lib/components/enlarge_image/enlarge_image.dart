import 'package:flutter/material.dart';

class EnlargeImage extends StatefulWidget {
  final String image_url;

  @override
  _EnlargeImageState createState() => _EnlargeImageState();

  EnlargeImage(this.image_url);
}

class _EnlargeImageState extends State<EnlargeImage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  color: Colors.black,
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            SizedBox(height: size.height * 0.20),
            Container(
              child: Image.network(
                widget.image_url,
                height: size.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
