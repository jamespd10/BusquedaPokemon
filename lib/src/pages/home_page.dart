import 'dart:async';
import 'package:busquedapokemon/src/model/pokemon_all_model.dart';
import 'package:busquedapokemon/src/util/search_util.dart';
import 'package:busquedapokemon/src/widgets/crear_lista.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scrollController = new ScrollController();
  int _ultimoItem = 0;
  int _limit = 50;
  final _isLoading = ValueNotifier(false);
  final _streamController = StreamController();
  List<Result> _data = [];
  //PokemonAllModel

  @override
  void initState() {
    super.initState();
    _respuestaHttp();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _respuestaHttp();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Busqueda Pokémon'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () =>
                showSearch(context: context, delegate: SearchData()),
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _streamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  CrearLista(
                    lista: snapshot.data,
                    scrollController: _scrollController,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (BuildContext context, value, child) {
                        return _crearLoading(value);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _crearLoading(value) {
    return value ? CircularProgressIndicator() : Container();
  }

  void _changeLoading() => _isLoading.value = !_isLoading.value;

  Future<void> _respuestaHttp() async {
    try {
      _changeLoading();
      final _dio = Dio();
      final _response = await _dio.get(
        'https://pokeapi.co/api/v2/pokemon/?offset=$_ultimoItem&limit=$_limit',
      );
      _ultimoItem = _ultimoItem + _limit;
      final _allPokemon = pokemonAllModelFromJson(_response.toString());
      _data.addAll(_allPokemon.results);
      _streamController.add(_data);
    } catch (e) {
      print(e);
      _streamController.addError('Error');
    } finally {
      _changeLoading();
    }
  }
}
