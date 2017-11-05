# Extended Game Description
This gem implements "Extended Game Description", a new chess game description format.  
It is based on FEN and Extended Position Description (EPD).  

It provides robust conversion functionality, accepting a valid PGN string,
and outputting a JSON string of the chess game in EGD representation.

## Installation

```
gem install 'egd'
```

## Use

```
TODO
```

## What is this??

It's all about computer analysis of chess games.  
If we want answers to insight questions like "do I do well when I trade queens?",
or "what losing positions do I repeatedly find myself in?", simple PGNs are not enough.  

PGN is what is called "normalized" game data - it holds all the information needed to
gain insight, but it would take a lot of time even for a computer to to through thousands of games
to get the data needed to answer these questions.

What we need for expedience is a way to de-"normalize" the data in PGN, to expand the details of moves and positions.  

This is what EGD does. It is a denormalized way to represent a game of chess.

### Position equality
A consise way to represent any __diagram__ of a chess position is the [Forsyth–Edwards Notation (FEN)](https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation). However, for our purposes it is not sufficient, as it does not contain some crucial meta-information on repetition count etc.

Discussions of what a chess __position__ is, especially in a digital analysis setting, have yielded a conclusion that beyond the producing move and resulting piece placement, this information must be included:

1. possible en-passant capture square (irrespective of any legal possibility to execute such a capture),
2. TODO 3-repeat rule (possibility of draw)
3. 50-move rule (forced draw)
4. FIDE's 70-move rule (forced draw)
5. ??

## EGD details

EGD is based on [Extended Position Description (EPD)](https://chessprogramming.wikispaces.com/Extended+Position+Description)
but adds meta-information to moves as well.  

A (very short) game that can be represented in algebraic notation as 1. e4 e5
in EGD becomes a JSON hash of number keys for moves and has values with "move" and "position" keys.

```
TODO
```

## Development

1. Fork and clone the repo
2. install ruby and bundler, bundle
3. run `rspec` to see if tests pass
4. work on feature, test it, make a PR

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Epigene/egd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem uses the [BSD-3 license](https://opensource.org/licenses/BSD-3-Clause),
you may use the gem in your own work, provided you reproduce the LICENSE.txt in it.  
