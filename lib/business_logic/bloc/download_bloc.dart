import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:bloc/bloc.dart';
import 'package:dash_generator/data.dart';
import 'package:equatable/equatable.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DashatarRepo _dashRepo = DashatarRepo();

  DownloadBloc() : super(const DownloadState()) {
    on<DownloadStarted>((event, emit) async {
      emit(state.copyWith(status: DownloadStatus.inProgress));
      try {
        final dashesToDownload = await _fetchUrls(emit);
        final archive = _downloadDashes(dashesToDownload, emit);
        add(DownloadFinished());
      } catch (e) {
        add(DownloadFailed());
      }
    });
    on<DownloadFinished>((event, emit) {
      emit(state.copyWith(status: DownloadStatus.success));
    });
    on<DownloadFailed>((event, emit) {
      emit(state.copyWith(status: DownloadStatus.failure));
    });
  }

  Future<List<Dash>> _fetchUrls(
    Emitter<DownloadState> emit,
  ) async {
    int counter = 0;
    var dashes = <Dash>[];

    await for (final dashBuffer in _dashRepo.getDashesWithUrl()) {
      if (dashBuffer.isEmpty) break;

      dashes.addAll(dashBuffer);
      counter += dashBuffer.length;
      emit(state.copyWith(loadingProgress: counter / 245 * 0.33));
    }
    return dashes;
  }

  Future<Uint8List> _downloadDashes(
    List<Dash> dashesToDownload,
    Emitter<DownloadState> emit,
  ) async {
    final outputStream = OutputStream();
    final zipEncoder = ZipEncoder()..startEncode(outputStream);
    int counter = 0;
    await for (final img in _dashRepo.downloadDashImages(dashesToDownload)) {
      zipEncoder.addFile(
        ArchiveFile(
          img.key,
          img.value.length,
          img.value,
        ),
      );
      counter++;
      emit(state.copyWith(loadingProgress: (counter / 245 * 0.67) + 0.33));
    }
    zipEncoder.endEncode();
    return Uint8List.fromList(outputStream.getBytes());
  }
}
