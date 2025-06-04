class NEWS{
  final String title;
  final String description;
  final String image;
  final String url;

  NEWS({
    required this.title,
    required this.description,
    required this.image,
    required this.url,
  });

  
  factory NEWS.fromJson(Map<String, dynamic> json) {
    return NEWS(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      url: json['url'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'url': url,
    };
  }
}
