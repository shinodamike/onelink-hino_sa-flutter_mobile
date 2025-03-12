
class News {

  int? newsManagement;
  String? urlImage;
  String? urlLink;

  News({this.newsManagement, this.urlImage, this.urlLink});

  News.fromJson(Map<String, dynamic> json) {
    newsManagement = json['news_management'];
    urlImage = json['url_image'];
    urlLink = json['url_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['news_management'] = newsManagement;
    data['url_image'] = urlImage;
    data['url_link'] = urlLink;
    return data;
  }
}

