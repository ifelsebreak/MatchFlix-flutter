# MatchFlix
![Platform](http://img.shields.io/badge/platform-android-blue.svg?style=flat)
![License](https://img.shields.io/github/license/ifelsebreak/MatchFlix)
![Language](https://img.shields.io/badge/language-Dart-blue)
![Toolkit] (https://img.shields.io/badge/toolkit-Flutter-brightgreen)

# Overview

![Overview](https://github.com/yuyakaido/images/blob/master/CardStackView/sample-overview.gif)

Proof of concept for a Tinder-like app to find movies that both you and your partner (or friend, or family member or whatever)  want to watch. Movies appear as cards in a deck and you swipe them left or right: when you both swipe right on the same movie you have a match and you can stream it via Netflix or Prime Video or other platforms.

Made with Flutter and Dart, uses themoviedb.org API for mve data.


## DISCLAIMER

- Backend not yet implemented (doesn't register likes and dislikes and the match mechanism is just a mock-up animation).
- Deck is currently generated with batches of 5 cards, to be replaced with a better solution.
- The app takes the data from the themoviedb.org API: you must sign up on their website and provide your own API key (it's free).
- It's my first mobile app ever so expect messy code and bad prarctices.
- Tested on emulator and Samsung Galaxy A50
