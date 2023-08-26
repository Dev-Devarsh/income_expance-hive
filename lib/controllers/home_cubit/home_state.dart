part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class FetchData extends HomeState {
  final List<TransactionModel> data;

  FetchData(this.data);
}

final class ChangeDate extends HomeState {
}
