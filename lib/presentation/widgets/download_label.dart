import 'package:flutter/cupertino.dart';

class DownloadLabel extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  const DownloadLabel({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: CupertinoColors.white,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: CupertinoColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
