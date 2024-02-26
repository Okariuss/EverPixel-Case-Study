import 'package:flutter/material.dart';

class EditImagePage extends StatefulWidget {
  final String imagePath;

  const EditImagePage({super.key, required this.imagePath});
  @override
  State<EditImagePage> createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
