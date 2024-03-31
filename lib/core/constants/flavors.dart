/// app flavors
enum Flavor {
  /// dev
  dev,

  /// prod
  prod
}

/// will return the current app flavor
Flavor getFlavor() {
  const flavorStr = String.fromEnvironment('FLUTTER_APP_FLAVOR');
  return switch (flavorStr) {
    'dev' => Flavor.dev,
    'prod' => Flavor.prod,
    _ => throw UnsupportedError('Unsupported flavor')
  };
}
