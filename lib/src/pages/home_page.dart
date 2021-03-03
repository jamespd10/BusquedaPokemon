import 'dart:async';
import 'package:busquedapokemon/src/model/pokemon_all_model.dart';
import 'package:busquedapokemon/src/pages/resultado_page.dart';
import 'package:busquedapokemon/src/util/search_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Color> _colorsPares = [Colors.blue, Colors.green];
  final List<Color> _colorsImPares = [Colors.yellow, Colors.purpleAccent];
  ScrollController _scrollController = new ScrollController();
  ValueNotifier<List<Result>> _listaCompleta = ValueNotifier([]);
  int _ultimoItem = 0;
  int _limit = 50;
  ValueNotifier<bool> _isLoading = ValueNotifier(false);
  Future<PokemonAllModel> _firstList;

  @override
  void initState() {
    super.initState();
    _firstList = _firstHttp();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _respuestaHttp();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
        child: FutureBuilder(
          future: _firstList,
          builder:
              (BuildContext context, AsyncSnapshot<PokemonAllModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              return Stack(
                children: <Widget>[
                  ValueListenableBuilder<List<Result>>(
                    valueListenable: _listaCompleta,
                    builder: (BuildContext context, value, child) {
                      return _crearListaPokemon(value);
                    },
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
                child: Text('Error'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _crearListaPokemon(List<Result> lista) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: lista.length,
      itemBuilder: (BuildContext context, int index) {
        List _listUrl = lista[index].url.split('/');
        String _id = _listUrl[6];
        String _url =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$_id.png';
        return ListTile(
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: index % 2 > 0 ? _colorsPares : _colorsImPares,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.network(_url)),
          ),
          title: Text(lista[index].name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Resultado(nombre: lista[index].name),
              ),
            );
          },
        );
      },
    );
  }

  Widget _crearLoading(value) {
    return value ? CircularProgressIndicator() : Container();
  }

  Future<PokemonAllModel> _firstHttp() async {
    try {
      Dio _dio = Dio();
      Response _response = await _dio.get(
          'https://pokeapi.co/api/v2/pokemon/?offset=$_ultimoItem&limit=$_limit');
      _ultimoItem = _ultimoItem + _limit;
      _agregarPokemon(pokemonAllModelFromJson(_response.toString()));
      return pokemonAllModelFromJson(_response.toString());
    } catch (e) {
      return null;
    }
  }

  void _respuestaHttp() async {
    try {
      _isLoading.value = true;
      Dio _dio = Dio();
      Response _response = await _dio.get(
        'https://pokeapi.co/api/v2/pokemon/?offset=$_ultimoItem&limit=$_limit',
      );
      _ultimoItem = _ultimoItem + _limit;
      _agregarPokemon(pokemonAllModelFromJson(_response.toString()));
    } catch (e) {
      _isLoading.value = false;
    }
  }

  void _agregarPokemon(PokemonAllModel pokemonAllModel) {
    pokemonAllModel.results.forEach((element) {
      _listaCompleta.value = List.from(_listaCompleta.value)..add(element);
    });
  }
}
