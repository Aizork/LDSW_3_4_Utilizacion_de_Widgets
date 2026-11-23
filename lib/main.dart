
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
void main() {
  runApp(const CineApp());
}

Future<Map<String, dynamic>> obtenerPikachu() async {
  final url = Uri.parse(
    'https://pokeapi.co/api/v2/pokemon/pikachu',
  );

  final respuesta = await http.get(url);

  if (respuesta.statusCode == 200) {
    return jsonDecode(respuesta.body)
    as Map<String, dynamic>;
  } else {
    throw Exception(
      'No se pudo obtener la informacion de Pikachu',
    );
  }
}

class CineApp extends StatelessWidget {
  const CineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineApp',
      home: const PantallaInicio(),
    );
  }
}

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  static final Future<Map<String, dynamic>> datosPikachu =
  obtenerPikachu();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text('CineApp'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.menu),
          ),
        ],
      ),

      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_cine.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Capa para facilitar la lectura
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mensaje de bienvenida
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.movie,
                        size: 45,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '¡Bienvenido a CineApp!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hello World',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Buscador de películas
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar película...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Películas populares',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // Cuatro películas de ejemplo
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.05,
                  children: [
                    tarjetaPelicula('Película 1', Colors.blue),
                    tarjetaPelicula('Película 2', Colors.purple),
                    tarjetaPelicula('Película 3', Colors.teal),
                    tarjetaPelicula('Película 4', Colors.orange),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  'Especial: Detective Pikachu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                FutureBuilder<Map<String, dynamic>>(
                  future: datosPikachu,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Text('Error al consultar la API');
                    }

                    if (!snapshot.hasData) {
                      return const Text('No hay informacion disponible');
                    }

                    final pokemon = snapshot.data!;
                    final imagen = pokemon['sprites']['front_default'];

                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          if (imagen != null)
                            Image.network(
                              imagen.toString(),
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported);
                              },
                            ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nombre: ${pokemon['name']}'),
                                Text('Altura: ${pokemon['height']}'),
                                Text('Peso: ${pokemon['weight']}'),
                                const SizedBox(height: 8),
                                const Text(
                                  'Datos obtenidos de PokéAPI',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        ],
      ),

      // Menú inferior
      bottomNavigationBar: const BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, size: 30),
            Icon(Icons.favorite, color: Colors.red, size: 30),
            Icon(Icons.person_outline, size: 30),
          ],
        ),
      ),
    );
  }

  Widget tarjetaPelicula(String nombre, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.movie_creation,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nombre,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
