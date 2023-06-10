import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'qr_code_scanner_state.dart';

class QrCodeScannerCubit extends Cubit<QrCodeScannerState> {
  QrCodeScannerCubit() : super(QrCodeScannerInitial());
}
