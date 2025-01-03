// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RecipeModel {
  final String? id;
  final String? title;
  final String? description;
  final String? gambar;
  final String? gambarId;
  RecipeModel({
    this.id,
    this.title,
    this.description,
    this.gambar,
    this.gambarId,
  });



  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['\$id'] != null ? map['\$id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      gambar: map['gambar'] != null ? map['gambar'] as String : null,
      gambarId: map['gambarId'] != null ? map['gambarId'] as String : null,
    );
  }

 
}
