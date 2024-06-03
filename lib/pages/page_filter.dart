import 'package:flutter/material.dart';

class PageFilter extends StatefulWidget {
  const PageFilter({super.key, required this.filters});
  final Map<String, dynamic> filters;

  @override
  State<PageFilter> createState() => _PageFilterState();
}

class _PageFilterState extends State<PageFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sitemarker"),
      ),
      body: Center(
        child: Text(widget.filters.toString()),
      )// TODO: Add the result here
    );
  }
}