class Plateau
  attr_reader :max_x, :max_y

  def initialize (max_x, max_y)
    @max_x = max_x
    @max_y = max_y
  end
end


class Rover
  attr_reader :coordinate_x, :coordinate_y, :orientation, :grid

  def initialize (coordinate_x, coordinate_y, orientation, grid)
    @coordinate_x = coordinate_x
    @coordinate_y = coordinate_y
    @orientation = orientation
    @grid = grid
  end

  DIRECTIONS = ['N', 'E', 'S', 'W']

  def process_instruction (instruction)
    instruction.each_char { |instruction| 
      turn(instruction) if instruction == 'L' || instruction == 'R'
      move if instruction == 'M'
    }
  end

  def move
    case @orientation
    when 'N'
      @coordinate_y += 1 if @coordinate_y < @grid.max_y
    when 'E'
      @coordinate_x += 1 if @coordinate_x < @grid.max_x
    when 'S'
      @coordinate_y -= 1 if @coordinate_y > 0
    when 'W'
      @coordinate_x -= 1 if @coordinate_x > 0
    end
  end

  def turn (direction)
    index_orientation = DIRECTIONS.index(@orientation)
    index_orientation = -1 if index_orientation == 3

    @orientation = DIRECTIONS[index_orientation - 1] if direction == 'L'
    @orientation = DIRECTIONS[index_orientation + 1] if direction == 'R'
  end

  def report_location
    puts "#{@coordinate_x} #{@coordinate_y} #{@orientation}"
  end

end


class Program

  def initialize (filename)
    @filename = filename
  end

  def run 
    open_file
    create_plateau
    process_rover_commands
  end

  def open_file

    # check file
    if !File.file? (@filename)
      raise IOError.new('Not possible to open file or not existent')
    end

    # make array of input lines
    @input_lines = File.new(@filename, "r").readlines
  end

  def create_plateau

  # check plateau input
    if @input_lines[0] =~ /^\d+\s\d+$/
      coords = @input_lines.shift.split
      @plateau = Plateau.new(coords[0].to_i, coords[1].to_i);
    else
      raise ArgumentError.new ('Plateau coordinates input is not in the correct format (eg. "12 6\\n") or missing')
    end
  end

  def process_rover_commands

  # read input file until last line
    while !@input_lines.empty?
      place_rover
      move_rover
    end
  end

  def place_rover
    rover_position_orientation = @input_lines.shift

    # check position/orientation input syntax
    if rover_position_orientation =~/^\d+\s\d+\s[NESW]$/
      data = rover_position_orientation.split

      #check position/orientation input values
      if data[0].to_i > @plateau.max_x || data[1].to_i > @plateau.max_y
        raise ArgumentError.new('Initial rover coordinates must be within defined plateau')
      end

      @rover = Rover.new(data[0].to_i, data[1].to_i, data[2], @plateau)

    else
      raise ArgumentError.new ('Rover position/orientation input is not in the correct format (eg. "12 4 N\\n") or missing')
    end
  end

  def move_rover
    instruction = @input_lines.shift
   
    #check rover instruction input
    if instruction =~ /^[LRM]+$/
      @rover.process_instruction(instruction)
      @rover.report_location
    else 
      raise ArgumentError.new ('Rover instruction input is not in the correct format (eg. "LMRRLMRRL\n") or missing')
    end
  end
end


# Execute program with arguments from command line (accept multiple files)
ARGV.each {|file|
  @program = Program.new(file)
  @program.run
}