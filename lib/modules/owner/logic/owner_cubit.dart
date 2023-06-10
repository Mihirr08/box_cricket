import 'package:bloc/bloc.dart';
import 'package:box_cricket/modules/owner/logic/owner_provider.dart';
import 'package:meta/meta.dart';

part 'owner_state.dart';

class OwnerCubit extends Cubit<OwnerState> {
  OwnerCubit() : super(OwnerInitial());

  Future<void> register() async {
    try {
      emit(OwnerLoading());
      await OwnerProvider().registerOwner();
      emit(OwnerSuccess());
    } catch (e) {
      emit(OwnerFailed(e.toString()));
    }
  }

  Future<void> checkPhoneNumber(String number) async {
    try {
      emit(OwnerLoading());
      await OwnerProvider().registerOwner();
      emit(OwnerSuccess());
    } catch (e) {
      emit(OwnerFailed(e.toString()));
    }
  }
}
