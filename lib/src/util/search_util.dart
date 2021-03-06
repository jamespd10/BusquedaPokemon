import 'package:busquedapokemon/src/model/pokemon_model.dart';
import 'package:busquedapokemon/src/util/get_search_pokemon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchData extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();
    return FutureBuilder(
      future: _firstHttp(query),
      builder: (BuildContext context, AsyncSnapshot<PokemonModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          return GetSearchPokemon(snapshot.data);
        } else {
          return Center(child: Text('No se encontró resultado'));
        }
      },
    );
  }

  Future<PokemonModel> _firstHttp(String consul) async {
    try {
      Dio _dio = Dio();
      Response _response = await _dio
          .get('https://pokeapi.co/api/v2/pokemon/${consul.toLowerCase()}');
      return pokemonModelFromJson(_response.toString());
    } catch (e) {
      return null;
    }
  }
}
