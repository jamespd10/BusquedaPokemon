import 'package:busquedapokemon/src/model/pokemon_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Resultado extends StatefulWidget {
  final String nombre;

  const Resultado({Key key, @required this.nombre}) : super(key: key);

  @override
  _ResultadoState createState() => _ResultadoState();
}

class _ResultadoState extends State<Resultado> {
  Future<PokemonModel> _pokemon;
  @override
  void initState() {
    super.initState();
    _pokemon = _getDataPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nombre}'),
      ),
      body: FutureBuilder(
        future: _pokemon,
        builder: (BuildContext context, AsyncSnapshot<PokemonModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            return ListView(
              padding: EdgeInsets.only(top: 20),
              children: [
                Stack(
                  children: [
                    Card(
                      margin: EdgeInsets.fromLTRB(10, 100, 10, 20),
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'Id',
                                style: TextStyle(fontSize: 20),
                              ),
                              trailing: Text(
                                '${snapshot.data.id}',
                                style: TextStyle(fontSize: 20),
                              ),
                              onTap: () {},
                            ),
                            ListTile(
                              title: Text(
                                'Nombre',
                                style: TextStyle(fontSize: 20),
                              ),
                              trailing: Text(
                                snapshot.data.name,
                                style: TextStyle(fontSize: 20),
                              ),
                              onTap: () {},
                            ),
                            ExpansionTile(
                              title: Text(
                                'Tipos',
                                style: TextStyle(fontSize: 20),
                              ),
                              children: _tipos(snapshot.data.types),
                            ),
                            ExpansionTile(
                              title: Text(
                                'Habilidades',
                                style: TextStyle(fontSize: 20),
                              ),
                              children: _habilidades(snapshot.data.abilities),
                            ),
                            ExpansionTile(
                              title: Text(
                                'Estadisticas',
                                style: TextStyle(fontSize: 20),
                              ),
                              children: _estadisticas(snapshot.data.stats),
                            ),
                            ListTile(
                              title: Text(
                                'Altura',
                                style: TextStyle(fontSize: 20),
                              ),
                              trailing: Text(
                                '${snapshot.data.height}',
                                style: TextStyle(fontSize: 20),
                              ),
                              onTap: () {},
                            ),
                            ExpansionTile(
                              title: Text(
                                'Movimientos',
                                style: TextStyle(fontSize: 20),
                              ),
                              children: _movimientos(snapshot.data.moves),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.green],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 100,
                          child: Image.network(
                            '${snapshot.data.sprites.frontDefault}',
                          ),
                        ),
                      ),
                    ),
                  ],
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
    );
  }

  Future<PokemonModel> _getDataPokemon() async {
    try {
      Dio _dio = Dio();
      Response _response = await _dio.get(
        'https://pokeapi.co/api/v2/pokemon/${widget.nombre}',
      );
      return pokemonModelFromJson(_response.toString());
    } catch (e) {
      return null;
    }
  }

  List<Widget> _habilidades(List<Ability> abilities) {
    List<Widget> _lista = [];
    abilities.forEach((element) {
      _lista
        ..add(ListTile(
          title: Text(element.ability.name),
        ));
    });
    return _lista;
  }

  List<Widget> _movimientos(List<Move> moves) {
    List<Widget> _lista = [];
    moves.forEach((element) {
      _lista
        ..add(ListTile(
          title: Text(element.move.name),
        ));
    });
    return _lista;
  }

  List<Widget> _tipos(List<Type> types) {
    List<Widget> _lista = [];
    types.forEach((element) {
      _lista
        ..add(ListTile(
          title: Text(element.type.name),
        ));
    });
    return _lista;
  }

  List<Widget> _estadisticas(List<Stat> stats) {
    List<Widget> _lista = [];
    stats.forEach((element) {
      _lista
        ..add(ListTile(
          title: Text(element.stat.name),
          trailing: Text('${element.baseStat}'),
        ));
    });
    return _lista;
  }
}
