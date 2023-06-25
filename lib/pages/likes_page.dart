import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../model/post_model.dart';

class LikesPage extends StatefulWidget {
  final PageController? pageController;

  const LikesPage({Key? key, this.pageController}) : super(key: key);

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  bool isLoading = false;
  List<Post> items = [];

  String? image_1 =
      'https://images.unsplash.com/photo-1686092854995-b735b32187a2';
  String? image_2 =
      'https://images.unsplash.com/photo-1684885783404-98ade0ab49c8';
  String? image_3 =
      'https://images.unsplash.com/photo-1685856898185-57eb303fd776';

  @override
  void initState() {
    super.initState();
    items.add(Post(image_1!, 'Best photo '));
    items.add(Post(image_2!, 'Beautiful photo'));
    items.add(Post(image_3!, 'Hello World'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Likes',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Billabong', fontSize: 30),
          ),
          actions: [
            IconButton(
              onPressed: () {
                widget.pageController!.animateToPage(2,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn);
              },
              icon: const Icon(Icons.camera_alt),
              color: Colors.black,
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, index) {
                  return itemOfPost(items[index]);
                }),
            isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : const SizedBox.shrink(),
          ],
        ));
  }

  Widget itemOfPost(Post post) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(),

          //user info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: const Image(
                        image: AssetImage("assets/images/ic_person.png"),
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Esonov Qodirxon',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          '2023-06-11  19:40',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    )
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          //Post image
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            imageUrl: post.imgPost,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),

          //like share
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  EvaIcons.heart,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  EvaIcons.shareOutline,
                ),
              ),
            ],
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                text: "${post.caption}",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}