bool signUpChecker(Map map) =>
    map.containsKey('name') &&
    map.containsKey('email') &&
    map.containsKey('password');
