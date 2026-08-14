import '../models/interest_item.dart';

abstract final class InterestsData {
  static const String sportsRecreation = 'Sports & Recreation';
  static const String sportsFans = 'Sports Fans & Live Events';
  static const String entertainment = 'Entertainment';
  static const String gamingTechnology = 'Gaming & Technology';
  static const String foodSocial = 'Food & Social Activities';
  static const String creativeHobbies = 'Creative & Hobbies';
  static const String learningCulture = 'Learning & Culture';
  static const String outdoorsTravel = 'Outdoors & Travel';
  static const String communityLifestyle = 'Community & Lifestyle';

  static const List<String> categories = [
    sportsRecreation,
    sportsFans,
    entertainment,
    gamingTechnology,
    foodSocial,
    creativeHobbies,
    learningCulture,
    outdoorsTravel,
    communityLifestyle,
  ];

  static const List<InterestItem> interests = [
    // Sports & Recreation
    InterestItem(id: 'golf', name: 'Golf', category: sportsRecreation),
    InterestItem(id: 'bowling', name: 'Bowling', category: sportsRecreation),
    InterestItem(id: 'tennis', name: 'Tennis', category: sportsRecreation),
    InterestItem(
      id: 'pickleball',
      name: 'Pickleball',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'basketball_play',
      name: 'Playing Basketball',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'baseball_play',
      name: 'Playing Baseball',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'soccer_play',
      name: 'Playing Soccer',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'football_play',
      name: 'Playing Football',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'hockey_play',
      name: 'Playing Hockey',
      category: sportsRecreation,
    ),
    InterestItem(id: 'running', name: 'Running', category: sportsRecreation),
    InterestItem(
      id: 'fitness',
      name: 'Gym & Fitness',
      category: sportsRecreation,
    ),
    InterestItem(id: 'swimming', name: 'Swimming', category: sportsRecreation),
    InterestItem(id: 'hiking', name: 'Hiking', category: sportsRecreation),
    InterestItem(id: 'biking', name: 'Biking', category: sportsRecreation),
    InterestItem(id: 'fishing', name: 'Fishing', category: sportsRecreation),
    InterestItem(id: 'camping', name: 'Camping', category: sportsRecreation),
    InterestItem(
      id: 'martial_arts',
      name: 'Martial Arts',
      category: sportsRecreation,
    ),

    // Sports Fans & Live Events
    InterestItem(
      id: 'sporting_events',
      name: 'Going to Sporting Events',
      category: sportsFans,
    ),
    InterestItem(id: 'football_fan', name: 'Football', category: sportsFans),
    InterestItem(
      id: 'basketball_fan',
      name: 'Basketball',
      category: sportsFans,
    ),
    InterestItem(id: 'baseball_fan', name: 'Baseball', category: sportsFans),
    InterestItem(id: 'hockey_fan', name: 'Hockey', category: sportsFans),
    InterestItem(id: 'soccer_fan', name: 'Soccer', category: sportsFans),
    InterestItem(
      id: 'college_sports',
      name: 'College Sports',
      category: sportsFans,
    ),
    InterestItem(id: 'motorsports', name: 'Motorsports', category: sportsFans),
    InterestItem(
      id: 'golf_tournaments',
      name: 'Golf Tournaments',
      category: sportsFans,
    ),
    InterestItem(
      id: 'tennis_events',
      name: 'Tennis Events',
      category: sportsFans,
    ),
    InterestItem(
      id: 'watch_parties',
      name: 'Watch Parties',
      category: sportsFans,
    ),

    // Entertainment
    InterestItem(id: 'movies', name: 'Movies', category: entertainment),
    InterestItem(
      id: 'television',
      name: 'TV & Streaming',
      category: entertainment,
    ),
    InterestItem(id: 'theater', name: 'Theater', category: entertainment),
    InterestItem(id: 'concerts', name: 'Concerts', category: entertainment),
    InterestItem(id: 'live_music', name: 'Live Music', category: entertainment),
    InterestItem(id: 'comedy', name: 'Comedy Shows', category: entertainment),
    InterestItem(id: 'festivals', name: 'Festivals', category: entertainment),
    InterestItem(id: 'museums', name: 'Museums', category: entertainment),
    InterestItem(
      id: 'theme_parks',
      name: 'Theme Parks',
      category: entertainment,
    ),

    // Gaming & Technology
    InterestItem(
      id: 'video_games',
      name: 'Video Games',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'board_games',
      name: 'Board Games',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'tabletop_games',
      name: 'Tabletop Games',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'card_games',
      name: 'Card Games',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'technology',
      name: 'Technology',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'artificial_intelligence',
      name: 'Artificial Intelligence',
      category: gamingTechnology,
    ),
    InterestItem(id: 'coding', name: 'Coding', category: gamingTechnology),
    InterestItem(id: 'gadgets', name: 'Gadgets', category: gamingTechnology),
    InterestItem(
      id: 'virtual_reality',
      name: 'Virtual Reality',
      category: gamingTechnology,
    ),

    // Food & Social Activities
    InterestItem(
      id: 'restaurants',
      name: 'Trying Restaurants',
      category: foodSocial,
    ),
    InterestItem(id: 'coffee', name: 'Coffee', category: foodSocial),
    InterestItem(id: 'cooking', name: 'Cooking', category: foodSocial),
    InterestItem(id: 'baking', name: 'Baking', category: foodSocial),
    InterestItem(
      id: 'food_festivals',
      name: 'Food Festivals',
      category: foodSocial,
    ),
    InterestItem(id: 'trivia', name: 'Trivia Nights', category: foodSocial),
    InterestItem(id: 'brunch', name: 'Brunch', category: foodSocial),
    InterestItem(id: 'dinner_out', name: 'Dinner Out', category: foodSocial),

    // Creative & Hobbies
    InterestItem(
      id: 'photography',
      name: 'Photography',
      category: creativeHobbies,
    ),
    InterestItem(id: 'art', name: 'Art', category: creativeHobbies),
    InterestItem(id: 'drawing', name: 'Drawing', category: creativeHobbies),
    InterestItem(id: 'painting', name: 'Painting', category: creativeHobbies),
    InterestItem(id: 'writing', name: 'Writing', category: creativeHobbies),
    InterestItem(id: 'crafts', name: 'Crafts', category: creativeHobbies),
    InterestItem(
      id: 'woodworking',
      name: 'Woodworking',
      category: creativeHobbies,
    ),
    InterestItem(
      id: 'collecting',
      name: 'Collecting',
      category: creativeHobbies,
    ),
    InterestItem(
      id: 'playing_music',
      name: 'Playing Music',
      category: creativeHobbies,
    ),

    // Learning & Culture
    InterestItem(id: 'history', name: 'History', category: learningCulture),
    InterestItem(id: 'science', name: 'Science', category: learningCulture),
    InterestItem(id: 'languages', name: 'Languages', category: learningCulture),
    InterestItem(id: 'books', name: 'Books', category: learningCulture),
    InterestItem(
      id: 'book_clubs',
      name: 'Book Clubs',
      category: learningCulture,
    ),
    InterestItem(
      id: 'documentaries',
      name: 'Documentaries',
      category: learningCulture,
    ),
    InterestItem(
      id: 'cultural_events',
      name: 'Cultural Events',
      category: learningCulture,
    ),

    // Outdoors & Travel
    InterestItem(
      id: 'road_trips',
      name: 'Road Trips',
      category: outdoorsTravel,
    ),
    InterestItem(id: 'travel', name: 'Travel', category: outdoorsTravel),
    InterestItem(id: 'beaches', name: 'Beaches', category: outdoorsTravel),
    InterestItem(id: 'mountains', name: 'Mountains', category: outdoorsTravel),
    InterestItem(id: 'parks', name: 'Parks', category: outdoorsTravel),
    InterestItem(
      id: 'sightseeing',
      name: 'Sightseeing',
      category: outdoorsTravel,
    ),
    InterestItem(id: 'cruises', name: 'Cruises', category: outdoorsTravel),
    InterestItem(id: 'nature', name: 'Nature', category: outdoorsTravel),

    // Community & Lifestyle
    InterestItem(
      id: 'volunteering',
      name: 'Volunteering',
      category: communityLifestyle,
    ),
    InterestItem(
      id: 'community_events',
      name: 'Community Events',
      category: communityLifestyle,
    ),
    InterestItem(id: 'pets', name: 'Pets', category: communityLifestyle),
    InterestItem(
      id: 'gardening',
      name: 'Gardening',
      category: communityLifestyle,
    ),
    InterestItem(
      id: 'home_improvement',
      name: 'Home Improvement',
      category: communityLifestyle,
    ),
    InterestItem(id: 'cars', name: 'Cars', category: communityLifestyle),
    InterestItem(
      id: 'motorcycles',
      name: 'Motorcycles',
      category: communityLifestyle,
    ),
    InterestItem(
      id: 'faith_community',
      name: 'Faith & Community Activities',
      category: communityLifestyle,
    ),
  ];
}
