import 'package:box_cricket/network/dio_singleton.dart';

class OwnerProvider{

  registerOwner() async{
     await DioSingleton().get(endPoint: "");
  }

  checkNumber() async{
     await DioSingleton().get(endPoint: "");
  }

}