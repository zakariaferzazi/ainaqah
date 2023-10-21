class Salebanner {
  String? title;
  String? startDate;
  String? endDate;
  String? image;
  String? thumb;

  Salebanner(
      {this.title,
        this.startDate,
        this.endDate,
        this.image,
        this.thumb});

  Salebanner.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
    thumb = json['thumb'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    data['thumb'] = this.thumb;
    return data;
  }
}