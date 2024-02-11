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
  community
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
      label =
          'https://firebasestorage.googleapis.com/v0/b/carbonzero-53d68.appspot.com/o/vegan.png?alt=media&token=88f40034-3eca-451c-a987-d6cb2f4d2bdc';
    case DietType.vegetarian:
      label =
          'https://firebasestorage.googleapis.com/v0/b/carbonzero-53d68.appspot.com/o/broccoli.png?alt=media&token=32983f1f-dd97-4d4f-a5f2-a44282cb6d51';
    case DietType.pescatarian:
      label =
          'https://firebasestorage.googleapis.com/v0/b/carbonzero-53d68.appspot.com/o/fish-and-chips.png?alt=media&token=3eaf7dad-5785-4ea8-8ede-e78dc987e0cd';
    case DietType.highMeat:
      label =
          'https://firebasestorage.googleapis.com/v0/b/carbonzero-53d68.appspot.com/o/beef.png?alt=media&token=4b17798a-0966-42b9-854f-32179e911eec';
    case DietType.lowMeat:
      label =
          'https://firebasestorage.googleapis.com/v0/b/carbonzero-53d68.appspot.com/o/food.png?alt=media&token=34c725d8-8f8a-4ce5-9f06-98aab9611cb2';
  }
  return label;
}
