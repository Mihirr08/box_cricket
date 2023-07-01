import 'package:bloc/bloc.dart';
import 'package:box_cricket/models/OwnerRegistrationModel.dart';
import 'package:box_cricket/modules/owner/logic/owner_provider.dart';
import 'package:flutter/cupertino.dart';

part 'owner_state.dart';

class OwnerCubit extends Cubit<OwnerState> {
  OwnerCubit() : super(OwnerInitial());

  Future<void> register(OwnerRegistrationModel model) async {
    try {
      print("Model in register ${model.toJson()}");
      model.bookingSlots?.forEach((element) {
        print("Element is ${element.toJson()}");
      });
      emit(OwnerLoading());
      await OwnerProvider().registerOwner(model);
      emit(OwnerSuccess());
    } catch (e) {
      emit(OwnerFailed(e.toString()));
    }
  }
}
