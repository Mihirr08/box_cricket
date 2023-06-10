part of 'owner_cubit.dart';

@immutable
abstract class OwnerState {}

class OwnerInitial extends OwnerState {}

class OwnerFailed extends OwnerState{
  final String error;

  OwnerFailed(this.error);
}
class OwnerSuccess extends OwnerState{

}
class OwnerLoading extends OwnerState{}
