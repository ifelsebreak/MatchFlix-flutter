# MatchFlix
![Platform](http://img.shields.io/badge/platform-android-blue.svg?style=flat)
![License](https://img.shields.io/github/license/ifelsebreak/MatchFlix)
![Language](https://img.shields.io/badge/language-Dart-blue)
![Toolkit](https://img.shields.io/badge/toolkit-Flutter-brightgreen)
![API](https://img.shields.io/badge/API-themoviedb.org-red)
![Backend](https://img.shields.io/badge/Backend-FireBase-yellow)

## DEPRECATED
### This project is being rewritten from scratch with proper OOP, sound Null-safety and state management with BLOC pattern.

## Overview

![Overview](https://github.com/ifelsebreak/MatchFlix-flutter/blob/main/lib/images/20210101_200410.gif)

Proof of concept for a Tinder-like app to find movies that both you and your partner want to watch (or friend, or family member or whatever).

Movies appear as cards in a deck and you swipe them right or left to like or dislike and also up to shout your preference (sends a push notification to the other user) or down to save the movie for later without the other user knowing.

When you both swipe right on the same movie you have a match and get notified and you can stream the movie or schedule a movie night.

You can also undo your swipe and call back a swiped card from off screen by tapping the 🔄 button.

If you tap on a movie it takes you to a screen with more details about the movie itself (score, genres, plot, etc).

Made with Flutter and Dart, uses [themoviedb.org](http://themoviedb.org) API for movie data.


## Log-in:

![Log-in](https://github.com/ifelsebreak/MatchFlix-flutter/blob/main/lib/images/Composizione_4.gif)


## Add friends to new group:

![Group invite](https://github.com/ifelsebreak/MatchFlix-flutter/blob/main/lib/images/MatchFlix_4.gif)


## Changelog

- You can log-in using your [themoviedb.org](http://themoviedb.org) account.
- When you swipe right to like a movie it also gets saved as favorite in your [themoviedb.org](http://themoviedb.org) account.
- You can send group requests to other [themoviedb.org](http://themoviedb.org) users as well as accept or decline them.
- Messed up the screen with details about the specific movie you tap on; will fix in next commit.

## DISCLAIMER

- Backend implementation still underway ("match" feature is just a mock-up animation for now).
- Deck is currently generated with batches of 5 cards, to be replaced with a better solution.
- The app takes the data from the themoviedb.org API: you must sign up on their website and get your own API key and set it as the value of the "tmdbAPIkey" variable in /lib/movie-list.dart.
- You need to set up your FireBase accont and link it to your flutter project through the google-services.json file provided by Google.
- Tested on android emulator and Samsung Galaxy A50.
