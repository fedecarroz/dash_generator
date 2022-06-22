import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc() : super(const DownloadState()) {
    on<DownloadStarted>((event, emit) {
      emit(state.copyWith(status: DownloadStatus.inProgress));
    });
    on<DownloadFinished>((event, emit) {
      emit(state.copyWith(status: DownloadStatus.success));
    });
    on<DownloadFailed>((event, emit) {
      emit(state.copyWith(status: DownloadStatus.failure));
    });
  }
}
