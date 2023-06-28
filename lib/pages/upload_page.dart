import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myinsta/model/post_model.dart';
import 'package:myinsta/services/db_service.dart';
import 'package:myinsta/services/file_service.dart';

class UploadPage extends StatefulWidget {
  final PageController? pageController;

  const UploadPage({Key? key, this.pageController}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool isLoading = false;
  var captionController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? image;

  uploadNewPost() {
    String caption = captionController.text.toString().trim();
    if (caption.isEmpty) return;
    if (image == null) return;
    apiPostImage();
  }

  void apiPostImage(){
    setState(() {
      isLoading = true;
    });
    FileService.uploadPostImage(image!).then((downloadUrl) => {
      resPostImage(downloadUrl),
    });
  }

  void resPostImage(String downloadUrl){
    String caption = captionController.text.toString().trim();
    Post post = Post(caption,downloadUrl);
    apiStorePost(post);
  }

  void apiStorePost(Post post) async{
    Post posted = await DBService.storePost(post);
    DBService.storeFeed(posted).then((value) => {
      moveToFeed(),
    });
  }

  moveToFeed() {
    setState(() {
      isLoading = false;
    });
    captionController.text = "";
    image = null;
    widget.pageController!.animateToPage(0,
        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  _imgFromGallery() async {
    final XFile? photo =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      image = File(photo!.path);
    });
  }

  _imgFromCamera() async {
    final XFile? photo =
    await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      image = File(photo!.path);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Upload",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.drive_folder_upload,
                  color: Color.fromRGBO(193, 53, 132, 1)),
              onPressed: () {
                uploadNewPost();
              },
            )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width,
                          color: Colors.grey.withOpacity(0.4),
                          child: image == null
                              ? const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.grey,
                            ),
                          )
                              : Stack(
                            children: [
                              Image.file(
                                image!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.black12,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          image == null;
                                        });
                                      },
                                      icon: const Icon(Icons
                                          .highlight_remove_outlined),
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                    Container(
                      margin:
                      const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: TextField(
                        controller: captionController,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: "Caption",
                          hintStyle:
                          TextStyle(color: Colors.black38, fontSize: 17),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}