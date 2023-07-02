import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myinsta/services/db_service.dart';
import 'package:myinsta/services/utils_service.dart';

import '../model/post_model.dart';

class MyFeedPage extends StatefulWidget {
  final PageController? pageController;

  const MyFeedPage({Key? key, this.pageController}) : super(key: key);

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  bool isLoading = false;
  List<Post> items = [];

  apiLoadFeeds(){
    setState(() {
      isLoading = true;
    });
    DBService.loadFeeds().then((value) => {
      resLoadFeeds(value),
    });
  }

  resLoadFeeds(List<Post> posts){
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    apiLoadFeeds();
  }


  void apiPostLike(Post post) async{
    setState(() {
      isLoading = true;
    });

    await DBService.likePost(post, true);
    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  void apiPostUnLike(Post post) async{
    setState(() {
      isLoading = true;
    });

    await DBService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }

  dialogRemovePost(Post post) async {
    var result = await Utils.dialogCommon(
        context, "MyInsta", "Do you want to delete this post?", false);
    if(result != null && result){
      setState(() {
        isLoading = true;
      });
      DBService.removePost(post).then((value) => {
        apiLoadFeeds(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Instagram',
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
                      child: post.imgUser.isEmpty?  const Image(
                        image: AssetImage("assets/images/ic_person.png"),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ) : Image.network(post.imgUser,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      )
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
                post.mine
                    ? IconButton(
                        onPressed: () {
                          dialogRemovePost(post);
                        },
                        icon: const Icon(Icons.more_horiz),
                      )
                    : SizedBox.shrink(),
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
                  if(!post.liked){
                    apiPostLike(post);
                  }else{
                    apiPostUnLike(post);
                  }
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
                text: post.caption,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
