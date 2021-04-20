import 'package:busquedapokemon/src/model/pokemon_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:busquedapokemon/src/util/capitalize.dart';

class Resultado extends StatefulWidget {
  final String nombre;
  final Color color;

  const Resultado({
    Key key,
    @required this.nombre,
    this.color,
  }) : super(key: key);

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
        title: Text('${widget.nombre.capitalize()}'),
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
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 100, 10, 20),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            offset: Offset(2.0, 10.0),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                                snapshot.data.name.capitalize(),
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
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: this.widget.color,
                                radius: 100,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Image.network(
                                '${snapshot.data.sprites.frontDefault}',
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Stack(
                                  children: <Widget>[
                                    Text(
                                      this.widget.nombre.capitalize(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 6
                                          ..color = Colors.blue[700],
                                      ),
                                    ),
                                    Text(
                                      this.widget.nombre.capitalize(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
          title: Text(element.ability.name.capitalize()),
        ));
    });
    return _lista;
  }

  List<Widget> _movimientos(List<Move> moves) {
    List<Widget> _lista = [];
    moves.forEach((element) {
      _lista
        ..add(ListTile(
          title: Text(element.move.name.capitalize()),
        ));
    });
    return _lista;
  }

  List<Widget> _tipos(List<Type> types) {
    List<Widget> _lista = [];
    types.forEach((element) {
      _lista
        ..add(ListTile(
          title: Text(element.type.name.capitalize()),
        ));
    });
    return _lista;
  }

  List<Widget> _estadisticas(List<Stat> stats) {
    List<Widget> _lista = [];
    stats.forEach((element) {
      _lista
        ..add(ListTile(
          title: Text(element.stat.name.capitalize()),
          trailing: Text('${element.baseStat}'),
        ));
    });
    return _lista;
  }
}
