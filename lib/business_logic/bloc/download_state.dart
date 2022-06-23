// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'download_bloc.dart';

enum DownloadStatus { initial, inProgress, success, failure }

class DownloadState extends Equatable {
  final DownloadStatus status;
  final double loadingProgress;

  const DownloadState({
    this.status = DownloadStatus.initial,
    this.loadingProgress = 0.0,
  });

  DownloadState copyWith({
    DownloadStatus? status,
    double? loadingProgress,
  }) {
    return DownloadState(
      status: status ?? this.status,
      loadingProgress: loadingProgress ?? this.loadingProgress,
    );
  }

  @override
  List<Object> get props => [status, loadingProgress];
}
