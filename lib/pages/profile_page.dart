import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myinsta/model/member_model.dart';
import 'package:myinsta/services/db_service.dart';
import 'package:myinsta/services/file_service.dart';

import '../model/post_model.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  int axisCount = 2;
  List<Post> items = [];
  File? image;
  String fullName = '', email = '', imgUrl = '';
  int countPosts = 15, countFollowers = 300, countFollowing = 100;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    apiLoadMember();
    apiLoadPosts();
  }

  apiLoadPosts(){
    DBService.loadPosts().then((value) => {
      resLoadPosts(value),
    });
  }

  resLoadPosts(List<Post> posts){
    setState(() {
      items = posts;
      countPosts = posts.length;
    });
  }

  _imgFromGallery() async {
    final XFile? photo =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      image = File(photo!.path);
    });
    apiChangePhoto();
  }

  _imgFromCamera() async {
    final XFile? photo =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      image = File(photo!.path);
    });
    apiChangePhoto();
  }

  void apiChangePhoto() {
    if (image == null) return;
    setState(() {
      isLoading = true;
    });
    FileService.uploadUserImage(image!).then((downloadUrl) => {
          apiUpdateUser(downloadUrl),
        });
  }

  apiUpdateUser(String downloadUrl) async {
    Member member = await DBService.loadMember();
    member.imgUrl = downloadUrl;
    await DBService.updateMember(member);
    apiLoadMember();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext) {
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.all(1),
              child: Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Pick Photo'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Take Photo'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  void apiLoadMember() {
    setState(() {
      isLoading = true;
    });
    DBService.loadMember().then((value) => {
          showMemberInfo(value),
        });
  }

  void showMemberInfo(Member member) {
    setState(() {
      isLoading = false;
      this.fullName = member.fullName;
      this.email = member.email;
      this.imgUrl = member.imgUrl;
      this.countFollowing = member.followingCount;
      this.countFollowers = member.followersCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text("Profile",
              style: TextStyle(
                  color: Colors.black, fontFamily: "Billabong", fontSize: 25)),
          actions: [
            IconButton(
              onPressed: () {
                AuthService.signOutUser(context);
              },
              icon: const Icon(Icons.exit_to_app),
              color: Colors.black,
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                children: [
                  //,myPhoto
                  GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              border: Border.all(
                                width: 1.5,
                                color: const Color.fromRGBO(193, 53, 132, 1),
                              )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: imgUrl.isEmpty
                                ? const Image(
                                    image: AssetImage(
                                        "assets/images/ic_person.png"),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    imgUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.add_circle,
                                color: Colors.purple,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //myInfo
                  Text(
                    fullName.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),

                  //myCount
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  countPosts.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                  "POSTS",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  countFollowers.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                  "FOLLOWERS",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  countFollowing.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                  "FOLLOWING",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //list or grid
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  axisCount = 1;
                                });
                              },
                              icon: const Icon(Icons.list_alt),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  axisCount = 2;
                                });
                              },
                              icon: const Icon(Icons.grid_view),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //myPosts
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: axisCount),
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        return itemOfPosts(items[index]);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget itemOfPosts(Post post) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: post.imgPost,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            post.caption,
            style: TextStyle(color: Colors.black87.withOpacity(0.7)),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
