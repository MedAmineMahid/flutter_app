import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:flutter_tested/api_service.dart';

class AdditionalInfoPage extends StatefulWidget {
  @override
  _AdditionalInfoPageState createState() => _AdditionalInfoPageState();
}

class _AdditionalInfoPageState extends State<AdditionalInfoPage> {
  final TextEditingController _hereditaryDiseasesController = TextEditingController();
  final TextEditingController _healthHistoryController = TextEditingController();
  File? _medicalPdf;

  void _submit() async {
    // Add logic to submit the form data and the PDF file to the backend
    if (_medicalPdf != null) {
      await ApiService.uploadMedicalRecord('user_id', _medicalPdf!);
    }
    // Additional API calls for the form data can be made here
  }

  void _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _medicalPdf = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _hereditaryDiseasesController,
              decoration: InputDecoration(labelText: 'Hereditary Diseases'),
            ),
            TextField(
              controller: _healthHistoryController,
              decoration: InputDecoration(labelText: 'Health History'),
            ),
            ElevatedButton(
              onPressed: _pickPdf,
              child: Text('Upload Medical Record PDF'),
            ),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
