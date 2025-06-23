import 'package:flutter/cupertino.dart';

class PlaceHolderMessage extends StatelessWidget {
  final String? text;
  const PlaceHolderMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Text(text??"", style: const TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
