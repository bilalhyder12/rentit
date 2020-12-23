class AdData {
  String uid;
  String title;
  String desc;
  String province;
  String city;
  String category;
  double price;
  String duration;
  DateTime date;
  List<String> imageURL;
  String address;

  AdData({
    this.uid,
    this.title,
    this.desc,
    this.province,
    this.city,
    this.category,
    this.price,
    this.duration,
    this.address
  }) {
    date = null;
    imageURL = null;
  }
}
