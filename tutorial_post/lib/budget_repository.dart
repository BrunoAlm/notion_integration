import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'failure_model.dart';
import 'item_model.dart';

class BudgetRepository {
  final _baseUrl = 'https://api.notion.com/v1';
  final Client _client;

  BudgetRepository({Client? client}) : _client = client ?? Client();

  Future<List<Item>> getItems() async {
    try {
      final dbId = dotenv.env['NOTION_DATABASE_ID'];
      final secret = dotenv.env['NOTION_API_KEY'];
      final url = '$_baseUrl/databases/$dbId/query';

      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'access-control-allow-origin': '*',
          'Access-Control-Allow-Headers': '*',
          HttpHeaders.authorizationHeader: 'Bearer $secret',
          'Notion-Version': '2021-08-16',
        },
      );
      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['results'] as List).map((e) => Item.fromMap(e)).toList()
          ..sort(
            (a, b) => b.date.compareTo(a.date),
          );
      } else {
        throw Failure(message: "Something went wrong ($statusCode)");
      }
    } catch (erro) {
      throw Failure(message: 'Something went wrong: ($erro)');
    }
  }

  Future<List<Item>> patchItems() async {
    try {
      final dbId = dotenv.env['NOTION_DATABASE_ID'];
      final secret = dotenv.env['NOTION_API_KEY'];
      final _patchUrl = '$_baseUrl/databases/$dbId';

      final response = await _client.patch(
        Uri.parse(_patchUrl),
        headers: {
          'access-control-allow-origin': '*',
          "Access-Control-Allow-Headers": "*",
          "Access-Control-Allow-Methods": "*",
          HttpHeaders.authorizationHeader: 'Bearer $secret',
          'Notion-Version': '2021-08-16',
        },
      );

      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['results'] as List).map((e) => Item.fromMap(e)).toList()
          ..sort(
            (a, b) => b.date.compareTo(a.date),
          );
      } else {
        throw Failure(message: "Something went wrong ($statusCode)");
      }
    } catch (erro) {
      throw Failure(message: 'Something went wrong: ($erro)');
    }
  }

  void dispose() {
    _client.close();
  }
}
