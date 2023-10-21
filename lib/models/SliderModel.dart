class SliderModel {
  String? image;
  String? thumb;
  String? url;
  String? desc;
  String? title;

  SliderModel({this.image, this.thumb, this.url, this.desc,this.title});

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      image: json['image'],
      thumb: json['thumb'],
      url: json['url'],
      desc: json['desc'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['thumb'] = this.thumb;
    data['url'] = this.url;
    data['desc'] = this.desc;
    data['title'] = this.title;
    return data;
  }
}
