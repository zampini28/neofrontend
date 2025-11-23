import 'package:http/http.dart' as http;
import 'package:physioapp/utils/domain_connection.dart';

class PairPatientEndpoint {
  final _url = DomainConnection().url;

  Future<http.Response> pairWithPhysio(
      {required String physioId, required String token}) async {
    return await http.get(
      Uri.parse('$_url/users/$physioId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).timeout(
      const Duration(seconds: 5),
    );
  }
}
