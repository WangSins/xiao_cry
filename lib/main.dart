import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:xiao_cry/entity/joke_entity.dart';
import 'package:xiao_cry/constant/api_constant.dart';

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
  List<JokeData> _lists = [];
  ScrollController _scrollController = ScrollController();
  int _page = 0;

  _initData() async {
    Response response = await Dio().get(APIConstant.BASE_URL +
        APIConstant.ACTION_SATIN_GOD_API +
        "?type=${APIConstant.TYPE_TEXT}&page=${_page = 0}");
    var jokeEntity = JokeEntity.fromJson(json.decode(response.toString()));
    setState(() {
      _lists = jokeEntity.data;
    });
    print("_initData()：${_lists.length}");
  }

  _loadMore() async {
    Response response = await Dio().get(APIConstant.BASE_URL +
        APIConstant.ACTION_SATIN_GOD_API +
        "?type=${APIConstant.TYPE_TEXT}&page=${++_page}");
    var jokeEntity = JokeEntity.fromJson(json.decode(response.toString()));
    setState(() {
      _lists.addAll(jokeEntity.data.toList());
    });
    print("_getMore()：${_lists.length}");
  }

  Future<void> _onRefresh() async {
    Response response = await Dio().get(APIConstant.BASE_URL +
        APIConstant.ACTION_SATIN_GOD_API +
        "?type=${APIConstant.TYPE_TEXT}&page=${_page = 0}");
    var jokeEntity = JokeEntity.fromJson(json.decode(response.toString()));
    setState(() {
      _lists = jokeEntity.data;
    });
    print("_onRefresh()：${_lists.length}");
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
            itemCount: _lists.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_lists[index].text),
                      Text(
                        "热评：${_lists[index].topCommentscontent ?? "暂无热评"}",
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
