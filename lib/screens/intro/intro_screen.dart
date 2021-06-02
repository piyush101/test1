import 'package:FinXpress/screens/login/login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF7B51D3) : Color(0xFFb199e6),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Container(
                      height: size.height * .792,
                      child: PageView(
                        physics: ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          _getIntro(
                              size,
                              "https://firebasestorage.googleapis.com/v0/b/finbox-55d7a.appspot.com/o/intro%2Fintro1.png?alt=media&token=4dd3f9b7-6a59-44f7-96be-9dc28c78d66b",
                              "Bored with financial news?",
                              "We curate financial and business news in 60 words or less from trusted resources in plain english"),
                          _getIntro(
                              size,
                              "https://firebasestorage.googleapis.com/v0/b/finbox-55d7a.appspot.com/o/intro%2Fintro2.png?alt=media&token=a346da95-39c8-4eed-90bb-d339aa8508ad",
                              "Learnings and Real Insights",
                              "Learn everything about financial instruments visually and get real insights on mundane stories"),
                          _getIntro(
                              size,
                              "https://firebasestorage.googleapis.com/v0/b/finbox-55d7a.appspot.com/o/intro%2Fintro3.png?alt=media&token=6cbc80bd-19c3-4142-8be6-e2918f65ffb8",
                              "Stock Recommendations",
                              "Get stock recommendations from India's top broker at one place"),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                  _currentPage != _numPages - 1
                      ? Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomRight,
                            child: FlatButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Next',
                                    style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF7B51D3),
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF7B51D3),
                                    size: 30.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Text(''),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 100.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).popAndPushNamed(Login.login);
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Get started',
                      style: TextStyle(
                        color: Color(0xFF7B51D3),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }

  Column _getIntro(Size size, String imageurl, String title, String body) {
    return Column(
      children: <Widget>[
        Container(
          height: 320,
          // height: size.height * .5,
          // width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(5),
            image: DecorationImage(
                fit: BoxFit.cover, image: CachedNetworkImageProvider(imageurl)),
          ),
        ),
        SizedBox(height: 20.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: GoogleFonts.sourceSansPro(
                fontWeight: FontWeight.w600,
                fontSize: 30.0,
                // height: 2,
                color: Color(0xFF5f5463)),
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          body,
          style: GoogleFonts.sourceSansPro(fontSize: 17),
        ),
      ],
    );
  }
}
