import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const COLOR_CONVERTER = {
  "blue": Colors.blue,
  "red": Colors.red,
  "white": Colors.white,
  "grey": Colors.grey,
  "green": Colors.green,
  "yellow": Colors.yellow
};


String FORMATE_DATE_TIME(dynamic timestamp) {
  // Check if the timestamp is null or not a valid type
  if (timestamp == null) return 'Unknown time';

  try {
    // If timestamp is a Firestore Timestamp, convert it to DateTime
    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      dateTime = timestamp;
    } else {
      return 'Invalid time';
    }

    // Format the DateTime using intl package
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
  } catch (e) {
    return 'Invalid time';
  }
}