import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String nome;
  final String id;

  Product({required this.nome, required this.id});

  @override
  List<Object?> get props => [id, nome];
}
