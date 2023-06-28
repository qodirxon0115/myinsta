

class Post {
  String imgPost = "";
  String caption = "";
  String uid = "";
  String imgUser = "";
  String date = "";
  String fullName = "";
  String id = "";
  bool liked = false;
  bool mine = false;

  Post(this.caption, this.imgPost);

  Post.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullName = json['fullName'],
        imgUser = json['imgUser'],
        imgPost = json['imgPost'],
        id = json['id'],
        caption = json['caption'],
        date = json['date'],
        liked = json['liked'];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'fullName': fullName,
    'imgUser': imgUser,
    'id': id,
    'imgPost': imgPost,
    'caption': caption,
    'date': date,
    'liked': liked,
  };
}
