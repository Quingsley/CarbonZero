/// key used to store background notification messages
const String notificationKey = 'NOTIFICATIONS';

/// store
const String fcmNtfKey = "FCMNOTIFICATIONSKEY";

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

///
Map<int, String> getMonth = {
  1: 'JAN',
  2: 'FEB',
  3: 'MAR',
  4: 'APR',
  5: 'MAY',
  6: 'JUN',
  7: 'JUL',
  8: 'AUG',
  9: 'SEP',
  10: 'OCT',
  11: 'NOV',
  12: 'DEC',
};

/// reason for collecting lifestyle info
const String lifeStyleMessage =
    '''Understanding your activity level helps us tailor our carbon footprint calculation to your lifestyle. By knowing whether you're sedentary or active, we can accurately estimate the carbon emissions associated with your daily activities. This information allows us to provide you with personalized recommendations on how to reduce your carbon footprint effectively. Additionally, it enables us to highlight areas where you can make the most significant environmental impact, whether it's through transportation choices, energy consumption, or other daily habits. By sharing your activity level with us, you're helping us create a more customized and impactful sustainability plan tailored specifically to your needs and habits.''';

/// reason for collecting diet info
const dietMessage =
    """Understanding your dietary preferences allows us to provide you with more accurate insights into your carbon footprint. Different dietary choices have varying environmental impacts, and by knowing whether you follow a vegan, vegetarian, pescatarian, or specific meat consumption diet, we can better estimate the carbon emissions associated with your food consumption. This information enables us to offer personalized recommendations on how you can reduce your carbon footprint through dietary adjustments. For example, we can suggest plant-based alternatives, sustainable sourcing options, or other strategies tailored to your diet. By sharing your dietary preferences with us, you're helping us create a more comprehensive and effective sustainability plan that aligns with your lifestyle and values.""";

/// checks if email isValid
bool isEmailValid(String email) {
  // Define a regular expression for email validation
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Use the RegExp class to check if the email matches the pattern
  return emailRegex.hasMatch(email);
}

/// privacy policy url
const String privacyUrl = 'https://carbonzero-coral.vercel.app/privacy';

/// terms
const String terms = 'https://carbonzero-coral.vercel.app/terms';

/// ntf types
enum NotificationTypes {
  /// chat
  chat('chat'),

  /// daily tip
  tip('tip'),

  /// new challenge
  communityChallenge('communityChallenge');

  const NotificationTypes(this.name);

  /// name of the notification type
  final String name;
}
