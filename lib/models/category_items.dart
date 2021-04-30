import 'dart:convert';

List<CategoryItems> categoryItemsFromJson(String str) => List<CategoryItems>.from(json.decode(str).map((x) => CategoryItems.fromJson(x)));

String categoryItemsToJson(List<CategoryItems> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryItems {
  int id;
  String title;
  String thumb;

  CategoryItems({
    this.id,
    this.title,
    this.thumb,
  });

  factory CategoryItems.fromJson(Map<String, dynamic> json) => CategoryItems(
    id: json["id"],
    title: json["title"],
    thumb: json["thumb"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumb": thumb,
  };
}