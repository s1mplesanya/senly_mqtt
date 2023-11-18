class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    required this.lat,
    required this.long,
  });
}

class NovopolotskLocation extends AppLatLong {
  const NovopolotskLocation({
    super.lat = 55.5318,
    super.long = 28.5987,
  });
}
