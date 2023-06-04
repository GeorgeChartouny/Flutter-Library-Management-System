// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Book {
  late int? id;
  late String? title;
  late String? author;
  late String? pub_year;
  late String? category;
  late Object? additional_details;
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.pub_year,
    required this.category,
    required this.additional_details,
  });

  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? pub_year,
    String? category,
    Object? additional_details,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      pub_year: pub_year ?? this.pub_year,
      category: category ?? this.category,
      additional_details: additional_details ?? this.additional_details,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'author': author,
      'pub_year': pub_year,
      'category': category,
      'additional_details': additional_details,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
        id: map['id'],
        title: map['title'],
        author: map['author'],
        pub_year: map['pub_year'],
        category: map['category'],
        additional_details: map['additional_details']);
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Book(id: $id, title: $title, author: $author, pub_year: $pub_year, category: $category, additional_details: $additional_details)';
  }

  @override
  bool operator ==(covariant Book other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.author == author &&
        other.pub_year == pub_year &&
        other.category == category &&
        other.additional_details == additional_details;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        author.hashCode ^
        pub_year.hashCode ^
        category.hashCode ^
        additional_details.hashCode;
  }
}
