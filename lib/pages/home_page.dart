import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myinsta/pages/profile_page.dart';
import 'package:myinsta/pages/search_page.dart';
import 'package:myinsta/pages/upload_page.dart';

import 'feed_page.dart';
import 'likes_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController? _pageController;
  int _currentTap = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          MyFeedPage(pageController: _pageController,),
          const MySearchPage(),
          UploadPage(pageController: _pageController,),
          const LikesPage(),
          const ProfilePage()
        ],
        onPageChanged: (int index){
          setState(() {
            _currentTap = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (int index){
          setState(() {
            _currentTap = index;
            _pageController!.animateToPage(index, duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn);
          });
        },
        currentIndex: _currentTap,
        activeColor:  const Color.fromRGBO(193, 53, 132, 1),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,)
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 32,)
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
                size: 32,)
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border_outlined,
                size: 32,)
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                size: 32,)
          ),
        ],
      ),
    );
  }
}