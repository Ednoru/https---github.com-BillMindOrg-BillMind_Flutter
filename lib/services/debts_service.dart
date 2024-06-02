import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nav_bar/models/debts.dart';

class DebtsService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1/debts';

  /*Future<List<Debts>> getDebtsByClientId(int clientId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$clientId')).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Debts> debts = body.map((dynamic item) => Debts.fromJson(item)).toList();
        return debts;
      } else {
        throw Exception('Failed to load debts: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } on TimeoutException catch (_) {
      throw Exception('Request to $baseUrl timed out');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }
*/
  Future<void> addDebt(Debts debt) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(debt.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 201) {
        throw Exception('Failed to add debt: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } on TimeoutException catch (_) {
      throw Exception('Request to $baseUrl timed out');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<void> deleteDebt(int debtId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$debtId'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete debt: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } on TimeoutException catch (_) {
      throw Exception('Request to $baseUrl timed out');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }
}
