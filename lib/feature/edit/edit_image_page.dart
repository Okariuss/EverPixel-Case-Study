import 'dart:io';

import 'package:flutter/material.dart';

class EditImagePage extends StatefulWidget {
  final String imagePath;

  const EditImagePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<EditImagePage> createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Image'),
      ),
      body: Center(
        child: Image.file(
          File(widget.imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
