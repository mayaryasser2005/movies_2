import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListWatch extends StatefulWidget {
  static const String routeNamed = "ListWatch";

  const ListWatch({super.key});

  @override
  State<ListWatch> createState() => _ListWatchState();
}

class _ListWatchState extends State<ListWatch> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.greenAccent,);
  }
}
