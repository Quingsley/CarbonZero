/// key used to store background notification messages
const String notificationKey = 'NOTIFICATIONS';

///enum for app tabs
enum AppTabs {
  /// home 0
  home,

  /// 1
  statistics,

  /// 2
  community,

  /// 3
  rewards,

  /// 4
  settings
}

/// dummy text
const sampleText =
    """ We are a group of like-minded individuals who are passionate about creating a cleaner and more sustainable future. Whether you're interested in solar, wind , hydro, geothermal, or other forms of renewable energy, our community is the perfect place to learn, hare ideas, and collaborate on projects. From DIY solar panels to community and wind turbines, we believe in the power of renewable energy to transform our world. Join us today and become a part of the solution!""";

/// enum to specify the type of image
enum ImageType {
  /// profile image
  profile,

  /// community image
  community,

  /// activity image
  activity
}

/// tags
List<String> hashtags = [
  '#SustainableLiving',
  '#EcoFriendlyLife',
  '#CarbonFootprintChallenge',
  '#GreenCommunity',
  '#EcoWarriors',
  '#ClimateActionNow',
  '#RenewableRevolution',
  '#ZeroWasteJourney',
  '#GreenTechInnovation',
  '#CleanEnergyFuture',
  '#EcoConsciousLiving',
  '#LowCarbonLifestyle',
  '#SustainableHabits',
  '#CarbonNeutralGoals',
  '#PlanetFriendly',
  '#GreenLivingTips',
  '#ConsciousConsumption',
  '#SustainableSolutions',
  '#ClimateChangeAwareness',
  '#EarthGuardians',
];

/// personality enum
enum Personality {
  /// indoors user
  sedentary,

  /// active user
  active
}

/// [DietType] enum
enum DietType {
  /// Vegan
  vegan('Vegan'),

  /// Vegetarian
  vegetarian('Vegetarian'),

  /// Pescatarian
  pescatarian('Pescatarian'),

  /// High Meat
  highMeat('High Meat'),

  /// medium meat
  mediumMeat('Medium Meat'),

  /// Low Meat
  lowMeat('Low Meat');

  const DietType(this.label);

  /// label
  final String label;
}

/// [imageUrl] function
String imageUrl(DietType type) {
  String label;
  switch (type) {
    case DietType.vegan:
      label = 'assets/images/vegan.png';
    case DietType.vegetarian:
      label = 'assets/images/broccoli.png';
    case DietType.pescatarian:
      label = 'assets/images/fish-and-chips.png';
    case DietType.highMeat:
      label = 'assets/images/beef.png';
    case DietType.lowMeat:
      label = 'assets/images/low-meat.png';
    case DietType.mediumMeat:
      label = 'assets/images/low-carb-diet.png';
  }
  return label;
}

/// mode of transport enum
enum ModeOfTransport {
  /// long flight
  longFlight('Long Flight'),

  /// medium flight
  mediumFlight('Medium Flight'),

  /// short flight
  shortFlight('Short Flight'),

  /// bus
  bus('Bus'),

  /// medium car (Gasoline)
  mediumCarGasoline('Medium Car (Gasoline)'),

  /// medium car (Diesel)
  mediumCarDiesel('Medium Car (Diesel)'),

  /// Gasoline car
  gasolineCar('Gasoline Car'),

  /// medium EV
  mediumEV('Medium EV'),

  /// National rail
  nationalRail('National Rail'),

  /// International rail
  internationalRail('International Rail'),

  /// ferry
  ferry('Ferry'),

  /// hybrid EV
  hybridEV('Hybrid EV'),

  /// PHEV
  phev('PHEV'),

  ///BEV
  bev('BEV'),

  ///cycle
  cycle('Cycling'),

  /// walk
  walk('Walking');

  const ModeOfTransport(this.label);

  /// label
  final String label;
}

/// return s the string of the asset name
String getTransportAssetName(ModeOfTransport mode) {
  switch (mode) {
    case ModeOfTransport.longFlight:
      return 'assets/images/airplane.png';
    case ModeOfTransport.bev:
      return 'assets/images/electric-car.png';
    case ModeOfTransport.bus:
      return 'assets/images/bus-lane.png';
    case ModeOfTransport.ferry:
      return 'assets/images/ship.png';
    case ModeOfTransport.nationalRail:
      return 'assets/images/train.png';
    case ModeOfTransport.phev:
      return 'assets/images/phev.jpg';
    case ModeOfTransport.mediumFlight:
      return 'assets/images/flight.png';
    case ModeOfTransport.shortFlight:
      return 'assets/images/direct-flight.png';
    case ModeOfTransport.mediumCarGasoline:
      return 'assets/images/car-oil.png';
    case ModeOfTransport.mediumCarDiesel:
      return 'assets/images/car.png';
    case ModeOfTransport.gasolineCar:
      return 'assets/images/gasoline.png';
    case ModeOfTransport.mediumEV:
      return 'assets/images/hybrid-car.png';
    case ModeOfTransport.internationalRail:
      return 'assets/images/rail.png';
    case ModeOfTransport.hybridEV:
      return 'assets/images/battery-level.png';
    case ModeOfTransport.cycle:
      return 'assets/images/cycling.png';
    case ModeOfTransport.walk:
      return 'assets/images/walk.png';
  }
}

/// Energy consumption type
enum EnergyConsumptionType {
  ///electricity,
  electricity('Electricity'),

  ///natural Gas,
  gas('Natural Gas'),

  ///heating Oil,
  heatingOil('Heating Oil'),

  ///lpg,
  lpg('LPG'),

  ///wood,
  wood('Wood');

  const EnergyConsumptionType(this.label);

  /// label
  final String label;
}

/// returns the asset name for the energy consumption type
String getEnergyAsset(EnergyConsumptionType type) {
  switch (type) {
    case EnergyConsumptionType.electricity:
      return 'assets/images/eco-house.png';
    case EnergyConsumptionType.gas:
      return 'assets/images/natural-gas.png';
    case EnergyConsumptionType.heatingOil:
      return 'assets/images/candle.png';
    case EnergyConsumptionType.lpg:
      return 'assets/images/lpg.png';
    case EnergyConsumptionType.wood:
      return 'assets/images/fire.png';
  }
}

/// ActivityType enum
enum ActivityType {
  /// a single user activity
  individual,

  /// an activity that involves a group of users
  community,
}

/// Enum to represent the type of food
enum FoodType {
  /// Meat & Fish
  meatAndFish('Meat & Fish'),

  /// Dairy & Eggs
  dairyAndEggs('Dairy & Eggs'),

  /// produce
  produce('Produce'),

  /// Drinks
  drinks('Drinks'),

  /// Snacks
  snacks('Snacks');

  const FoodType(this.label);

  /// label
  final String label;
}

/// will return the food icon based on the food name
String getFoodIcon(String foodName) {
  final foodIcons = <String, String>{
    'Beef (herd)': '🐄',
    'Beef (dairy herd)': '🐮',
    'Lamb & Mutton': '🐑',
    'Pig Meat': '🐖',
    'Poultry Meat': '🐓',
    'Fish': '🐟',
    'Prawns': '🦐',
    'Eggs': '🥚',
    'Milk': '🥛',
    'Cheese': '🧀',
    'Rice': '🍚',
    'Wheat & Rye': '🥖',
    'Maize': '🌽',
    'Potatoes': '🥔',
    'Cane sugar': '🌾🍚',
    'Oat meal': '🌾',
    'Beet sugar': '🌱',
    'Barley': '🌾',
    'Tomatoes': '🍅',
    'Other pulses': '🫘',
    'Peas': '🫛',
    'Ground nuts': '🥜',
    'Cassava': '🌿',
    'Tofu (Soybeans)': '🥢',
    'Other Vegetables': '🥦',
    'Other Fruits': '🍇🍓',
    'Brassicas': '🥬',
    'Coffee': '☕',
    'Wine': '🍷',
    'Dark Chocolate': '🍫',
  };

  return foodIcons[foodName] ?? '🍽️';
}
