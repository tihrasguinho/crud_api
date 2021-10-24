bool signInChecker(Map map) =>
    map.containsKey('email') && map.containsKey('password');
