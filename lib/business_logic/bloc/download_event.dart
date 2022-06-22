part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class DownloadStarted extends DownloadEvent {}

class DownloadFinished extends DownloadEvent {}

class DownloadFailed extends DownloadEvent {}
