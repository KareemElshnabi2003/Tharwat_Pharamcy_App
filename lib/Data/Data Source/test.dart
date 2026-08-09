
import 'package:tharwat_pharmacy/Core/Class/api.dart';

class TestRemoteData {
  Api api;
  TestRemoteData(this.api);
  getData() async {
    var response = await api.getData("https://api.storerestapi.com/categories", null);
    return response.fold((l) => l, (r) => r);
  }

}
