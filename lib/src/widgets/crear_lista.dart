import 'package:busquedapokemon/src/model/pokemon_all_model.dart';
import 'package:busquedapokemon/src/pages/resultado_page.dart';
import 'package:busquedapokemon/src/util/get_color.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:busquedapokemon/src/util/capitalize.dart';

class CrearLista extends StatelessWidget {
  final List<Result> lista;
  final ScrollController scrollController;
  const CrearLista({
    Key key,
    this.lista,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.builder(
          controller: scrollController,
          itemCount: lista.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          ),
          itemBuilder: (BuildContext context, int index) {
            List _listUrl = lista[index].url.split('/');
            String _id = _listUrl[6];
            String _url =
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$_id.png';
            return FutureBuilder(
              future: GetColor.get(_url),
              builder: (_, AsyncSnapshot<PaletteGenerator> snapshot) {
                return Container(
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
                                    lista[index].name.capitalize(),
                                    style: TextStyle(
                                      fontSize: 30,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 6
                                        ..color = Colors.blue[700],
                                    ),
                                  ),
                                  Text(
                                    lista[index].name.capitalize(),
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
                                nombre: lista[index].name,
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
                );
              },
            );
          },
        );
      },
    );
  }
}
