import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lmsproject/main.dart';

class UpdateBookPage extends StatefulWidget {
  final int id;
  final String title;
  final String author;
  final String pub_year;
  final String category;
  final dynamic additional_details;

  const UpdateBookPage(
      {Key? key,
      required this.id,
      required this.title,
      required this.author,
      required this.pub_year,
      required this.category,
      this.additional_details})
      : super(key: key);

  @override
  _UpdateBookPageState createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  //declaring the fields for each column
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  DateTime? pubYear;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController additionalDetailsController =
      TextEditingController();

  initState() {
    // input the data we already have into the appropriate field
    titleController.text = widget.title;
    authorController.text = widget.author;
    pubYear = DateFormat("yyy-MM-dd").parse(widget.pub_year);
    categoryController.text = widget.category;
    if (widget.additional_details != null) {
      if (widget.additional_details is String) {
        additionalDetailsController.text = widget.additional_details!;
      } else {
        additionalDetailsController.text =
            jsonEncode(widget.additional_details!);
      }
    } else {
      additionalDetailsController.text = '';
    }

    super.initState();
  }

// formatting the additional_details to json format
  String formatAdditionalDetails(String additionalDetails) {
    print(additionalDetails);
    if (additionalDetails == null) {
      return '';
    }

    //split the input by comma and remove the white space
    final keyValuePairs = additionalDetails.split(',').map((pair) {
      final parts = pair.split(':');
      final key = parts[0].trim();
      final value = parts[1].trim();
      return '"$key":"$value"';
    });
    return '{${keyValuePairs.join(',')}}';
  }

// update Function, check if required fields are not empty before calling the post api
  Future<void> updateBook() async {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        pubYear == null ||
        categoryController.text.isEmpty) {
      // add error message
      return;
    }
    // foramting the pubYear to the desired format
    String formattedPubYear = DateFormat("yyyy-MM-dd").format(pubYear!);

    // map the values added into an object
    Map<String, dynamic> requestBody = {
      "title": titleController.text,
      "author": authorController.text,
      "pub_year": formattedPubYear,
      "category": categoryController.text,
      "additional_details":
          formatAdditionalDetails(additionalDetailsController.text),
    };
    await http.put(Uri.parse("http://127.0.0.1:8000/book/${widget.id}/update"),
        body: requestBody);
    //recall the fetch all books function to display the udpated data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ),
    );
  }

  // show a date picker when pressing on the field of pub_year
  Future<void> selectPubYear() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: pubYear ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    // checking if pubYear is not empty, get the year,month,day
    if (selectedDate != null) {
      setState(() {
        pubYear = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit an existing Book")),
      body: Column(children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(label: Text("Title *")),
        ),
        TextField(
          controller: authorController,
          decoration: const InputDecoration(label: Text("Author *")),
        ),
        TextButton(
          onPressed: () {
            print(pubYear);
            selectPubYear();
          },
          child: ListTile(
            title: Text(
              pubYear != null
                  ? "Publication Year: ${pubYear!.year}"
                  : "Select Publication Year *",
            ),
            trailing: const Icon(Icons.calendar_today),
          ),
        ),
        TextField(
          controller: categoryController,
          decoration: const InputDecoration(label: Text("Category *")),
        ),
        TextField(
          controller: additionalDetailsController,
          decoration: const InputDecoration(
              label: Text("More Information (object format)")),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16.0),
          child: ElevatedButton(
              onPressed: () {
                updateBook();
              },
              child: const Text("Update Book")),
        ),
      ]),
    );
  }
}
