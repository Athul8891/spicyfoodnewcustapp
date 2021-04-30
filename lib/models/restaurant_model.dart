class RestaurantsModel {
  String title;
  String thumb;
  String cuisines;
  String readyDuration;
  String offer;
  String rating;

  RestaurantsModel(
      {this.title,
        this.thumb,
        this.cuisines,
        this.readyDuration,
        this.offer,
        this.rating});

  RestaurantsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    thumb = json['thumb'];
    cuisines = json['cuisines'];
    readyDuration = json['ready_duration'];
    offer = json['offer'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['thumb'] = this.thumb;
    data['cuisines'] = this.cuisines;
    data['ready_duration'] = this.readyDuration;
    data['offer'] = this.offer;
    data['rating'] = this.rating;
    return data;
  }
}