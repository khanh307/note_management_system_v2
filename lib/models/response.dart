

import 'dart:convert';

abstract class Response {
  String status;
  String? error;

  Response({required this.status, this.error});
}