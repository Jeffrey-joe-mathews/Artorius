import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  DateTime now = DateTime.now();
  DateTime messageDate = timestamp.toDate();
  
  Duration difference = now.difference(messageDate);

  if (difference.inMinutes < 1) {
    return "Just now";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return "$weeks week${weeks > 1 ? 's' : ''} ago";
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return "$months month${months > 1 ? 's' : ''} ago";
  } else {
    int years = (difference.inDays / 365).floor();
    return "$years year${years > 1 ? 's' : ''} ago";
  }
}
