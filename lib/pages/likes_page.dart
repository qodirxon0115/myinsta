import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myinsta/services/db_service.dart';

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

  void apiLoadLikes() {
    setState(() {
      isLoading = true;
    });
    DBService.loadLikes().then((value) => {
          resLoadPost(value),
        });
  }

  void resLoadPost(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void apiPostUnLike(Post post){
    setState(() {
      isLoading = true;
      post.liked = false;
    });
    DBService.likePost(post, false).then((value) => {
      apiLoadLikes(),
    });
  }

  @override
  void initState() {
    super.initState();
    apiLoadLikes();
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
                      child: post.imgUser.isEmpty
                          ? Image(
                              image: AssetImage("assets/images/ic_person.png"),
                              width: 40,
                              height: 40,
                            )
                          : Image.network(
                              post.imgUser,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.fullName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          post.date,
                          style: const TextStyle(fontWeight: FontWeight.normal),
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
                onPressed: () {
                  apiPostUnLike(post);
                },
                icon: post.liked ? const Icon(
                  EvaIcons.heart,
                  color: Colors.red,
                ) : const Icon(
                  EvaIcons.heartOutline,
                  color: Colors.black,
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
