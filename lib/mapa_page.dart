import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'models/usuario.dart';

class MapaPage extends StatelessWidget {
  final Usuario usuario;
  final List<Map<String, dynamic>> perfis;

  const MapaPage({Key? key, required this.usuario, required this.perfis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng posicaoInicial = LatLng(
      usuario.latitude ?? 0.0,
      usuario.longitude ?? 0.0,
    );

    final List<Marker> marcadores = perfis.map<Marker>((perfil) {
      return Marker(
        width: 80,
        height: 80,
        point: LatLng(perfil['latitude'], perfil['longitude']),
        child: Column(
          children: [
            Icon(Icons.location_pin, color: Colors.pink, size: 40),
            Text(perfil['nome'], style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Perfis no Mapa')),
      body: FlutterMap(
        options: MapOptions(center: posicaoInicial, zoom: 13),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.conecta_app',
          ),
          MarkerLayer(markers: marcadores),
        ],
      ),
    );
  }
}