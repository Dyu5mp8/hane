import 'package:flutter/material.dart';
class indicationBox extends StatelessWidget {
  const indicationBox({
    super.key,
  });

  @override
Widget build(BuildContext context) {
  return Container(
    height: 300,
    width: MediaQuery.of(context).size.width,
    color: Colors.red,
    child: Column(
      children: [
        Text("hej",)
      ],
    ),
  );
}
}