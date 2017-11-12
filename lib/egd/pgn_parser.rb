# Thanks to https://github.com/jedld/pgn_parser

class Egd::PgnParser
  attr_reader :headers, :pgn_content

  def initialize(pgn_content)
    @pgn_content = pgn_content
    @headers = []
    @movelist = []
    @game_attributes = {}
    @verbose = true
  end

  def call
    current_index = 0
    state = :initial
    buffer = ''
    while (current_index < @pgn_content.size)
      current_char = @pgn_content[current_index]
      current_index += 1
      if state==:initial
        if current_char=='['
          state = :start_parse_header
          next
        elsif (current_char == ' ' || current_char == "\n" || current_char == "\r")
          next
        else
          break
        end
      end

      if state==:start_parse_header
        if current_char == ']'
          state = :initial
          hd = parse_header(buffer)
          @headers << hd
          @game_attributes[hd[:type]] = hd[:value]
          buffer = ''
          next
        else
          buffer << current_char
          next
        end
      end
    end

    @movelist = simple_parse_moves

    hash = {moves: @movelist}
    hash.merge!(game_tags: @game_attributes) if @game_attributes.any?
    hash
  end

  private

  def parse_header(header)
    event_type = ""
    event_value = ""
    state = :parse_type
    current_index = 0
    buffer = ''
    while (current_index < header.size)
      current_char = header[current_index]
      current_index+=1
      if state==:parse_type
        if current_char == ' '
          event_type = buffer.dup
          buffer = ''
          state=:start_parse_value
          next
        else
          buffer << current_char
          next
        end
      elsif state==:start_parse_value
        if current_char=='"'
          state=:parse_value
          next
        else
          next
        end
      elsif state==:parse_value
        if current_char=='"'
          event_value = buffer.dup
          buffer = ''
        else
          buffer << current_char
        end

      end
    end
    {type: event_type, value: event_value}
  end

  def simple_parse_moves
    move_line = pgn_content.split("\n").map do |line|
      line unless line.strip[0] == "["
    end.compact.join(" ")

    # strip out comments and alternatives
    while move_line.gsub!(%r'\{[^{}]*\}', ""); end
    while move_line.gsub!(%r'\([^()]*\)', ""); end

    move_line = move_line.strip.gsub(%r'\s{2,}', " ")

    moves = []

    while move_line.match(%r'\d+\.')
      move_line[%r'\A(\d+)\.(.*?)((\d+\..*\z)|\z)']

      move_number = $1
      move_chunk = $2 #=> " e4 c5 "
      move_line = $4.to_s.strip

      next if !move_chunk

      move_chunk = move_chunk.to_s.gsub(%r'\.{2}\s?', ".. " )
      move_line = move_line.to_s.strip

      number_var = "@_#{move_number}"

      w = move_chunk.strip.split(" ")[0]
      b = move_chunk.strip.split(" ")[1]

      options = {}
      options.merge!(:w=>w) unless w.match?(%r'\.{2}')
      options.merge!(:b=>b) if b

      instance_variable_set(
        "@_#{move_number}",
        instance_variable_get("@_#{move_number}") ?
        instance_variable_get("@_#{move_number}").merge(options) :
        {:num=>move_number.to_i}.merge(options)
      )

      moves << instance_variable_get("@_#{move_number}") if instance_variable_get("@_#{move_number}")[:b]
      @last = instance_variable_get("@_#{move_number}")
    end

    # offload last to moves since there may not have been a black move
    moves << @last if !@last[:b]

    moves
  end
end
