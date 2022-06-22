import 'package:dash_generator/business_logic.dart';
import 'package:dash_generator/presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<DownloadBloc>(
        create: (context) => DownloadBloc(),
        child: const HomePage(),
      ),
      title: 'Dash Generator',
    );
  }
}
