import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/main.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({'local': 'ar'});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  test('Api defaultHeaders and authHeaders return expected headers', () {
    final defaultH = Api.defaultHeaders();
    expect(defaultH['Accept'], 'application/json');
    expect(defaultH['Lang'], 'ar');
    expect(defaultH.containsKey('Authorization'), isFalse);

    final authH = Api.authHeaders('sample_token_xyz');
    expect(authH['Authorization'], 'Bearer sample_token_xyz');
    expect(authH['Accept'], 'application/json');
    expect(authH['Lang'], 'ar');
  });
}
