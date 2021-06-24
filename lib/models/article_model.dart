class ArticleModel {
  String sId;
  String content;
  String imageUrl;
  String tags;
  String title;
  String time;
  Meta meta;

  ArticleModel(
      {this.sId,
      this.content,
      this.imageUrl,
      this.tags,
      this.title,
      this.time,
      this.meta});

  ArticleModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    imageUrl = json['imageUrl'];
    tags = json['tags'];
    title = json['title'];
    time = json['time'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['imageUrl'] = this.imageUrl;
    data['tags'] = this.tags;
    data['title'] = this.title;
    data['time'] = this.time;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}

class Meta {
  String publishUrl;
  String publisher;
  String publishtime;

  Meta({this.publishUrl, this.publisher, this.publishtime});

  Meta.fromJson(Map<String, dynamic> json) {
    publishUrl = json['publishUrl'];
    publisher = json['publisher'];
    publishtime = json['publishtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publishUrl'] = this.publishUrl;
    data['publisher'] = this.publisher;
    data['publishtime'] = this.publishtime;
    return data;
  }
}
