import 'package:equatable/equatable.dart';

class Artwork extends Equatable {
  final String base64Image;
  final String? fileName;

  const Artwork({required this.base64Image, this.fileName});

  @override
  List<Object?> get props => [base64Image, fileName];
}
