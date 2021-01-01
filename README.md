# MatchFlix
![Platform](http://img.shields.io/badge/platform-android-blue.svg?style=flat)
![License](https://img.shields.io/github/license/ifelsebreak/MatchFlix)
![Language](https://img.shields.io/badge/language-Dart-blue)
![Toolkit](https://img.shields.io/badge/toolkit-Flutter-brightgreen)
![API](https://img.shields.io/badge/API-themoviedb.org-red)

# Overview

![Overview](https://github.com/yuyakaido/images/blob/master/CardStackView/sample-overview.gif)

Proof of concept for a Tinder-like app to find movies that both you and your partner want to watch (or friend, or family member or whatever).

Movies appear as cards in a deck and you swipe them right or left to like or dislike and also to shout your preference (sends a push notification to the other user) or down to save the movie for later without the other user knowing.

When you both swipe right on the same movie you have a match and get notified and you can stream the movie or schedule a movie night.

You can also undo your swipe and call back a swiped card from off screen by tapping the 🔄 button.

If you tap on a movie it takes you to a screen with more details about the movie itself (score, genres, plot, etc).

Made with Flutter and Dart, uses themoviedb.org API for movie data.


## DISCLAIMER

- Backend not yet implemented (doesn't register likes and dislikes and the match mechanism is just a mock-up animation).
- Deck is currently generated with batches of 5 cards, to be replaced with a better solution.
- The app takes the data from the themoviedb.org API: you must sign up on their website get an API key and set it as the value of the "tmdbAPIkey" variable in /lib/movie-list.dart.
- It's my first mobile app ever, so expect messy code and bad prarctices.
- Tested on android emulator and Samsung Galaxy A50.
