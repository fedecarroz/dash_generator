// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'download_bloc.dart';

enum DownloadStatus { initial, inProgress, success, failure }

class DownloadState extends Equatable {
  final DownloadStatus status;

  const DownloadState({
    this.status = DownloadStatus.initial,
  });

  DownloadState copyWith({
    DownloadStatus? status,
  }) {
    return DownloadState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
