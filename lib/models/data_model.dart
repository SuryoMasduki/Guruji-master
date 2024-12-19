class DataModel {
  final String title;
  final String desc;
  final String link;

  DataModel({required this.title, required this.desc, required this.link});

  factory DataModel.fromMap(Map<dynamic, dynamic> map) {
    return DataModel(
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
      link: map['link'] ?? '',
    );
  }
}
