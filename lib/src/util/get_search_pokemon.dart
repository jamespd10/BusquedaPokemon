import 'package:busquedapokemon/src/model/pokemon_model.dart';
import 'package:busquedapokemon/src/pages/resultado_page.dart';
import 'package:busquedapokemon/src/util/get_color.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:busquedapokemon/src/util/capitalize.dart';

class GetSearchPokemon extends StatelessWidget {
  final PokemonModel pokemon;
  const GetSearchPokemon(this.pokemon);

  @override
  Widget build(BuildContext context) {
    final String _base = 'https://raw.githubusercontent.com/PokeAPI/';
    final String _url =
        '${_base}sprites/master/sprites/pokemon/${this.pokemon.id}.png';
    return FutureBuilder(
      future: GetColor.get(_url),
      builder: (_, AsyncSnapshot<PaletteGenerator> snapshot) {
        return Center(
          child: Container(
            width: 200,
            height: 200,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                color: !snapshot.hasData
                    ? Colors.transparent
                    : snapshot.data.dominantColor.color,
                child: InkWell(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          _url,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          children: <Widget>[
                            Text(
                              this.pokemon.name.capitalize(),
                              style: TextStyle(
                                fontSize: 30,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 6
                                  ..color = Colors.blue[700],
                              ),
                            ),
                            Text(
                              this.pokemon.name.capitalize(),
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.yellow,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Resultado(
                          nombre: this.pokemon.name,
                          color: !snapshot.hasData
                              ? Colors.transparent
                              : snapshot.data.dominantColor.color,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
