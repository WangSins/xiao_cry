import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:xiao_cry/constant/api_constant.dart';
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
  List<JokeResult> _lists = [];
  ScrollController _scrollController = ScrollController();
  int _page = 0;
  bool _showFBA = false;

   _loadMore(bool isRefresh) async {
    Response response = await Dio().get(APIConstant.BASE_URL +
        APIConstant.ACTION_GET_JOKE +
        "?type=${APIConstant.TYPE_TEXT}&count=${APIConstant.DEFAULT_COUNT}&page=${isRefresh ? _page = 0 : ++_page}");
    var jokeEntity = JokeEntity.fromJson(json.decode(response.toString()));
    setState(() {
      if (isRefresh) {
        _lists = jokeEntity.result;
      } else {
        _lists.addAll(jokeEntity.result.toList());
      }
    });
  }

  Future<void> _onRefresh() async {
    Response response = await Dio().get(APIConstant.BASE_URL +
        APIConstant.ACTION_GET_JOKE +
        "?type=${APIConstant.TYPE_TEXT}&count=${APIConstant.DEFAULT_COUNT}&page=${_page = 0}");
    var jokeEntity = JokeEntity.fromJson(json.decode(response.toString()));
    setState(() {
      _lists = jokeEntity.result;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMore(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore(false);
      }
      if (_scrollController.offset >
          _scrollController.position.minScrollExtent) {
        setState(() {
          _showFBA = true;
        });
      } else {
        setState(() {
          _showFBA = false;
        });
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
                        "热评：${_lists[index].topCommentsContent ?? "暂无热评"}",
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
      floatingActionButton: !_showFBA
          ? null
          : FloatingActionButton(
              onPressed: () {
                _scrollController.jumpTo(0);
              },
              child: Icon(
                Icons.arrow_upward,
              ),
              backgroundColor: Colors.grey[100],
              heroTag: APIConstant.TYPE_TEXT,
            ),
    );
  }
}
