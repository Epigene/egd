[![Version](https://badge.fury.io/rb/egd.svg)](https://badge.fury.io/rb/egd)
[![Build](https://circleci.com/gh/Epigene/egd/tree/master.svg?style=shield)](https://circleci.com/gh/Epigene/egd/tree/master)
[![Coverage](https://coveralls.io/repos/github/Epigene/egd/badge.svg?branch=master)](https://coveralls.io/github/Epigene/egd?branch=master)

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
Egd::Builder.new(File.read("path/to/chess.pgn")).to_json #=> JSON string
```

## What is this??

It's all about computer analysis of chess games.  
If we want answers to insight questions like "do I do well when I trade queens?",
or "what losing positions do I repeatedly find myself in?", simple PGNs are not enough.  

PGN is what is called "normalized" game data - it holds all the information needed to
gain insight, but it would take a lot of time even for a computer to go through thousands of games
to get the data needed to answer these questions.

What we need for expedience is a way to de-"normalize" the data in PGN, to expand the details of moves and positions.  

This is what EGD does. It is a denormalized way to represent a game of chess.

Please note that currently EGD supports regular chess only and assumes the standart starting position.

Denormalize the PGNs of your games, store them in a PostgreSQL database and do powerful queries on the data,
like [Chess Sense](https://github.com/Epigene/chess_sense) does.

### Position equality
Currently EGD satisfies itself with using [Forsyth–Edwards Notation (FEN)](https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation) __diagrams__ as representations of position, since they encode the three crucial pieces of information:

1. What pieces are on which squares,
2. Castling rights of both players,
2. En-passant capture square (irrespective of any legal possibility to execute such a capture).

However, a high-level competetive analysis may require the additional tracking of:
1. Threefold repetition counter,
3. Fifty-move rule counter,
4. 75-move rule counter.

## EGD details
EGD is inspired by [Extended Position Description (EPD)](https://chessprogramming.wikispaces.com/Extended+Position+Description)
but goes further than just tracking positions and adds meta-information to moves as well, specifically, it uses a combination of Long algebraic and Reversible algebraic [chess notations](https://en.wikipedia.org/wiki/Chess_notation) to specify, without ambiguity, what was moved to where and what capture or promotion took place.  

The general form of EGD is a (JSON) hash of game headers and moves:

```rb
some_egd.to_h =>

{
  # PGN game headers, in the future may contain additional meta-information
  # about the game as a whole
  "game_tags" => { 
    "Event"=>"Eurotel Trophy",
    "Key" => "value"
  },

  # the moveset, each move is identified by order number and which side is moving
  "moves" => {
    # 1st move, by white
    "1w"=>{ 
      # what was the starting position
      "start_position"=>{
        # FEN diagram of the starting position
        "fen"=>"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
        # details about the position, see "Position features" chapter
        "features"=>{}
      },
      # details about the move
      "move"=>{
        "player"=>"w", "san"=>"e4", "lran"=>"e2-e4", "from_square"=>"e2",
        "to_square"=>"e4", "piece"=>"p", "move_type"=>"move"
      },
      # what was the resulting position
      "end_position"=>{
        # FEN diagram of the resulting position
        "fen"=>"rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1",
        "features"=>{}
      }
    }
  }
}
```

A (very short) game that can be represented in algebraic notation as `1. e4 e5`


```rb
egd = Egd::Builder.new("1. e4 e5")

egd.to_h #=>
# {
#   "game_tags" => {},
#   "moves" => {
#     "1w"=>{
#       "start_position"=>{
#         "fen"=>"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
#         "features"=>{}
#       },
#       "move"=>{
#         "player"=>"w", "san"=>"e4", "lran"=>"e2-e4", "from_square"=>"e2",
#         "to_square"=>"e4", "piece"=>"p", "move_type"=>"move"
#       },
#       "end_position"=>{
#         "fen"=>"rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1",
#         "features"=>{}
#       }
#     },
#     "1b"=>{
#       "start_position"=>{
#         "fen"=>"rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1",
#         "features"=>{}
#       },
#       "move"=>{
#         "player"=>"b", "san"=>"e5", "lran"=>"e7-e5",
#         "from_square"=>"e7", "to_square"=>"e5", "piece"=>"p",
#         "move_type"=>"move"
#       },
#       "end_position"=>{
#         "fen"=>"rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2",
#         "features"=>{}
#       }
#     }
#   }
# }

egd.to_json
#=> "{\"game_tags\":{},\"moves\":{\"1w\":{\"start_position\": ... \"features\":{}}}}}"
```

Take a look at `spec/egd_spec.rb` `"when initialized with the 02 PGN, a real immortal game"`
test for the structure you get when parsing PGNs you might get from chess.com.  

### Move specifics
EGD tries to provide the maximum of meta-information about a move a programmed system can.

Currently outputted keys are:
```rb
"move" => {
  "player"=>"w", # w for White and b for Black
  "san" => "exd6", # the Short Algebraic Notation from provided PGN
  "lran" => "e5xd6", # EGDs semi-custom Long Reversible Algebraic Notation
  "from_square" => "e5",
  "to_square" => "d6",
  "piece" => "p", # moved piece. Piece codes are [p, R, N, Bl, Bd, Q, K] Bl is for (L)ight square Bishop and Bd is for (D)ark square bishop.
  "move_type" => "ep_capture", # currently distinguished types are: [move, capture, ep_capture, promotion_capture, short_castle, long_castle, promotion]
  "captured_piece" => "p", # only shows up if a capture occured
  "promotion" => "Q", # only shows up if promotion occured
}
```

Please note that, unlike PGN representation, EGD does not treat check(+) and checkmate(#)
as part of a move, instead, they are treated as part of a position.

### Position specifics
Currently positions are very minimalist - a FEN string and a "features" hash that currently can only have two keys - "check" and "checkmate".

Please note that since the treatment of checkmate event is not uniform across online PGN generators (Lichess represents checkmate as "+", whereas chess.com as "#"), a checkmate event denoted by "#" also adds the "check" => true feature tag.

Example position hash:

```rb
"end_position"=>{
  "fen"=>"rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2",
  "features"=>{
    "check" => true,
    "checkmate" => true
  }
}
```

## Future Ideas
1. Expose the move's :meta key to [annotations](https://en.wikipedia.org/wiki/Chess_annotation_symbols) like "!!", "+/-", and "$1"

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
