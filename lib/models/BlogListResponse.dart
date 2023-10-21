class BlogListResponse {
  int? numOfPages;
  List<Blog>? data;

  BlogListResponse({this.numOfPages, this.data});

  BlogListResponse.fromJson(Map<String, dynamic> json) {
    numOfPages = json['num_of_pages'];
    if (json['data'] != null) {
      data = <Blog>[];
      json['data'].forEach((v) {
        data!.add(new Blog.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_of_pages'] = this.numOfPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Blog {
  int? iD;
  String? image;
  String? postTitle;
  String? postContent;
  String? postExcerpt;
  String? postDate;
  String? postDateGmt;
  String? readableDate;
  String? shareUrl;
  String? humanTimeDiff;
  String? noOfComments;
  String? postAuthorName;

  Blog(
      {this.iD,
        this.image,
        this.postTitle,
        this.postContent,
        this.postExcerpt,
        this.postDate,
        this.postDateGmt,
        this.readableDate,
        this.shareUrl,
        this.humanTimeDiff,
        this.noOfComments,
        this.postAuthorName});

  Blog.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    image = json['image'];
    postTitle = json['post_title'];
    postContent = json['post_content'];
    postExcerpt = json['post_excerpt'];
    postDate = json['post_date'];
    postDateGmt = json['post_date_gmt'];
    readableDate = json['readable_date'];
    shareUrl = json['share_url'];
    humanTimeDiff = json['human_time_diff'];
    noOfComments = json['no_of_comments'];
    postAuthorName = json['post_author_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['image'] = this.image;
    data['post_title'] = this.postTitle;
    data['post_content'] = this.postContent;
    data['post_excerpt'] = this.postExcerpt;
    data['post_date'] = this.postDate;
    data['post_date_gmt'] = this.postDateGmt;
    data['readable_date'] = this.readableDate;
    data['share_url'] = this.shareUrl;
    data['human_time_diff'] = this.humanTimeDiff;
    data['no_of_comments'] = this.noOfComments;
    data['post_author_name'] = this.postAuthorName;
    return data;
  }
}
