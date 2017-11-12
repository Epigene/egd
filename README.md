# Extended Game Description
This gem implements conversion functionality between standart PGN and EGD (Extended Game Description).
EGD is a new chess game description format that is based on FEN and Extended Position Description (EPD).  

## Installation

```
gem install 'egd'
```

## Use

```
require "egd"
Egd.call(File.read("path/to/chess.pgn")) #=> JSON string
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

Denormalize the PGNs of your games, store them in a PostgreSQL database and do powerful queries on the data, like [Extended Game Description Analysis](TODO) does.

### Position equality
Currently EDG satisfies itself with using [Forsyth–Edwards Notation (FEN)](https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation) __diagrams__ as representations of position, since they encode the two curial pieces of information:

1. What pieces are on which squares,
2. Castling rights of both players,
2. En-passant capture square (irrespective of any legal possibility to execute such a capture).

However, a high-level competetive analysis may require the additional tracking of:
1. Threefold repetition counter,
3. Fifty-move rule counter,
4. 75-move rule counter.

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
