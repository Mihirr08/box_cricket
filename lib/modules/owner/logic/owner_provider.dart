import 'package:box_cricket/models/OwnerRegistrationModel.dart';
import 'package:box_cricket/network/base_url.dart';
import 'package:box_cricket/network/dio_singleton.dart';
import 'package:dio/dio.dart';

class OwnerProvider {
  registerOwner(OwnerRegistrationModel model) async {
    print("Model to json ${await model.toJson()}");
    await DioSingleton().post(
      endPoint: Endpoints.registerNewOwner,
      data: FormData.fromMap(
        await model.toJson(),
      ),
    );
  }

  Future<bool?> checkIsOwnerRegistered(String phoneNumber) async {
    Response response = await DioSingleton().post(
        endPoint: Endpoints.isOwnerRegistered, data: {"phone": phoneNumber});
    try {
      if (response.statusCode == 200) {
        return response.data["isRegistered"];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }
}
