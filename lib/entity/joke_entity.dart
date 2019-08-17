class JokeEntity {
  String msg;
  int code;
  List<JokeData> data;

  JokeEntity({this.msg, this.code, this.data});

  JokeEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    if (json['data'] != null) {
      data = new List<JokeData>();
      (json['data'] as List).forEach((v) {
        data.add(new JokeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JokeData {
  String topCommentscontent;
  dynamic image;
  dynamic thumbnail;
  dynamic gif;
  dynamic topCommentsvoiceuri;
  int forward;
  dynamic video;
  String type;
  String topCommentsheader;
  int down;
  String uid;
  String passtime;
  String header;
  int comment;
  String text;
  int soureid;
  int up;
  String topCommentsname;
  String username;

  JokeData(
      {this.topCommentscontent,
      this.image,
      this.thumbnail,
      this.gif,
      this.topCommentsvoiceuri,
      this.forward,
      this.video,
      this.type,
      this.topCommentsheader,
      this.down,
      this.uid,
      this.passtime,
      this.header,
      this.comment,
      this.text,
      this.soureid,
      this.up,
      this.topCommentsname,
      this.username});

  JokeData.fromJson(Map<String, dynamic> json) {
    topCommentscontent = json['top_commentsContent'];
    image = json['image'];
    thumbnail = json['thumbnail'];
    gif = json['gif'];
    topCommentsvoiceuri = json['top_commentsVoiceuri'];
    forward = json['forward'];
    video = json['video'];
    type = json['type'];
    topCommentsheader = json['top_commentsHeader'];
    down = json['down'];
    uid = json['uid'];
    passtime = json['passtime'];
    header = json['header'];
    comment = json['comment'];
    text = json['text'];
    soureid = json['soureid'];
    up = json['up'];
    topCommentsname = json['top_commentsName'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['top_commentsContent'] = this.topCommentscontent;
    data['image'] = this.image;
    data['thumbnail'] = this.thumbnail;
    data['gif'] = this.gif;
    data['top_commentsVoiceuri'] = this.topCommentsvoiceuri;
    data['forward'] = this.forward;
    data['video'] = this.video;
    data['type'] = this.type;
    data['top_commentsHeader'] = this.topCommentsheader;
    data['down'] = this.down;
    data['uid'] = this.uid;
    data['passtime'] = this.passtime;
    data['header'] = this.header;
    data['comment'] = this.comment;
    data['text'] = this.text;
    data['soureid'] = this.soureid;
    data['up'] = this.up;
    data['top_commentsName'] = this.topCommentsname;
    data['username'] = this.username;
    return data;
  }
}
