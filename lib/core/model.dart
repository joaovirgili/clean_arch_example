abstract class Model<T> {
  Map<String, dynamic> toJson();
  T toEntity();
}
