import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:xiao_cry/entity/joke_entity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<JokeData> lists = [];
  ScrollController _scrollController = ScrollController();
  final String baseUrl = "https://www.apiopen.top/";
  final int type = 2;
  int page = 0;

  _initData() async {
    Response response =
        await Dio().get(baseUrl + "satinGodApi?type=$type&page=${page = 0}");
    var jokeEntity = JokeEntity.fromJson(json.decode(response.toString()));
    setState(() {
      lists = jokeEntity.data;
    });
    print("_initData()：${lists.length}");
  }

  _loadMore() async {
    Response response =
        await Dio().get(baseUrl + "satinGodApi?type=$type&page=${++page}");
    var jokeEntity = JokeEntity.fromJson(json.decode(response.toString()));
    setState(() {
      lists.addAll(jokeEntity.data.toList());
    });
    print("_getMore()：${lists.length}");
  }

  Future<void> _onRefresh() async {
    Response response =
        await Dio().get(baseUrl + "satinGodApi?type=$type&page=${page = 0}");
    var jokeEntity = JokeEntity.fromJson(json.decode(response.toString()));
    setState(() {
      lists = jokeEntity.data;
    });
    print("_onRefresh()：${lists.length}");
  }

  @override
  void initState() {
    super.initState();
    _initData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
          color: Colors.grey,
          child: StaggeredGridView.countBuilder(
            controller: _scrollController,
            crossAxisCount: 4,
            itemCount: lists.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(lists[index].text),
                      Text(
                        "热评：${lists[index].topCommentscontent ?? "暂无热评"}",
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              );
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
          ),
          onRefresh: _onRefresh),
    );
  }
}
