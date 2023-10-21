part of 'tab_cubit.dart';

@immutable
sealed class TabState {}

final class TabInitial extends TabState {}
final class ChangeTab extends TabState {}


