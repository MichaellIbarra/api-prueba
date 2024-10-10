class CategoriesModel {
  final int id;
  final String name, status;

  CategoriesModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
}