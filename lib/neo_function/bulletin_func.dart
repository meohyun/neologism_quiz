import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

makepost(context) {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  FirebaseFirestore.instance.collection('post').add({
    "name": _titleController.text,
    "content": _contentController.text,
    "time": Timestamp.now()
  });

  Navigator.pushNamed(context, 'post', arguments: {
    "name": _titleController.text,
    "content": _contentController.text,
    "time": Timestamp.now()
  });
}
