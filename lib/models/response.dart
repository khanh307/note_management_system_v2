import 'dart:convert';

class Response {
  int status;
  int? error;
  List? data;

  Response({required this.status, this.error, this.data});

  factory Response.fromJson(dynamic json) {
    return Response(
      status: json['status'],
      error: json['error'],
      data: json['data'],
    );
  }
}
