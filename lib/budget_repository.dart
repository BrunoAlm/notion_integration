import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:notion_integration/item_model.dart';

class BudgetRepository {
  final http.Client _client;

  BudgetRepository({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }
}
