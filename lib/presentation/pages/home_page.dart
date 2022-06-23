import 'package:dash_generator/business_logic.dart';
import 'package:dash_generator/presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Dash Generator'),
      ),
      child: SafeArea(
        child: Center(
          child: BlocBuilder<DownloadBloc, DownloadState>(
            builder: (context, state) {
              switch (state.status) {
                case DownloadStatus.initial:
                  return CupertinoButton(
                    color: CupertinoColors.activeBlue,
                    onPressed: () =>
                        context.read<DownloadBloc>().add(DownloadStarted()),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Text(
                      'Download',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(color: CupertinoColors.white),
                    ),
                  );

                case DownloadStatus.inProgress:
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: BlocBuilder<DownloadBloc, DownloadState>(
                        builder: (context, state) {
                          return LinearProgressIndicator(
                            backgroundColor: CupertinoColors.systemGrey4,
                            color: CupertinoColors.activeBlue,
                            minHeight: 10,
                            value: state.loadingProgress,
                          );
                        },
                      ),
                    ),
                  );

                case DownloadStatus.success:
                  return const DownloadLabel(
                    color: CupertinoColors.activeGreen,
                    icon: CupertinoIcons.checkmark_alt_circle,
                    text: 'Download completato',
                  );

                case DownloadStatus.failure:
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const DownloadLabel(
                        color: CupertinoColors.systemRed,
                        icon: CupertinoIcons.xmark_circle,
                        text: 'Download fallito',
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () =>
                            context.read<DownloadBloc>().add(DownloadStarted()),
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            'Riprova',
                            style: TextStyle(
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
