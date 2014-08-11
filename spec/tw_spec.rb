require "mars_rover"

describe "Plateau class" do

  it "initializes/sets attr_reader with maximum (upper right) x and y coordinates" do
    @grid = Plateau.new(12,32)
    expect(@grid.max_x).to eq(12)
    expect(@grid.max_y).to eq(32)
  end
end


describe "Rover class" do 
  before(:each) do
    @grid = Plateau.new(12,32)
    @rover = Rover.new(3,4,"N",@grid)
  end
  
  it "initializes/sets attr_reader with x/y position coordinates, orientation and current plateau information" do
    expect(@rover.coordinate_x).to eq(3)
    expect(@rover.coordinate_y).to eq(4)
    expect(@rover.orientation).to eq("N")
    expect(@rover.grid).to eq(@grid)
  end

  it "turns rover 90 degrees left when instructed with 'L'" do
    @rover.turn("L")
    @rover.turn("L")
    @rover.turn("L")
    expect(@rover.orientation).to eq("E")
  end

  it "turns rover 90 degrees right when instructed with 'R'" do
    @rover.turn("R")
    @rover.turn("R")
    expect(@rover.orientation).to eq("S")
  end

  it "moves rover one grid upwards if current orientation is North" do
    @rover.move
    expect(@rover.coordinate_x).to eq(3)
    expect(@rover.coordinate_y).to eq(5)
  end

  it "moves rover one grid to the right if current orientation is East" do
    @rover_east = Rover.new(3,4,"E",@grid)    
    @rover_east.move
    expect(@rover_east.coordinate_x).to eq(4)
    expect(@rover_east.coordinate_y).to eq(4)
  end

  it "moves rover one grid downwards if current orientation is South" do
    @rover_south = Rover.new(3,4,"S",@grid)    
    @rover_south.move
    expect(@rover_south.coordinate_x).to eq(3)
    expect(@rover_south.coordinate_y).to eq(3)
  end

  it "moves rover one grid to the left if current orientation is West" do
    @rover_west = Rover.new(3,4,"W",@grid)
    @rover_west.move
    expect(@rover_west.coordinate_x).to eq(2)
    expect(@rover_west.coordinate_y).to eq(4)
  end

  it "runs an entire instruction block per rover" do
    @rover.process_instruction("MMMLRMMLRMLMM")
    expect(@rover.coordinate_x).to eq(1)
    expect(@rover.coordinate_y).to eq(10)
    expect(@rover.orientation).to eq("W")
  end
end


describe "Program class" do
  before(:each) do
    @program = Program.new("testfile_1.txt")
  end

  it "opens input file and and creates line-seperated instance variable" do 
    @program.open_file
    expect(@program.instance_variable_get(:@input_lines)).to eq(["5 5\n", "1 2 N\n", "LMLMLMLMM\n", "3 3 E\n", "MMRMMRMRRM"])
  end

  it "sends final location of rovers to STOUT with one rover per line" do
    expect { @program.run }.to output("1 3 N\n5 1 E\n").to_stdout
  end

  it "throws an exception when input file is not correct or readable" do 
    @program_bad_file = Program.new("not_existent.txt")
    expect { @program_bad_file.run }.to raise_error(IOError)
  end

  it "throws an exception when plateau coordinates is not in the correct format" do
    @program_bad_plateau = Program.new("testfile_2.txt")
    expect { @program_bad_plateau.run }.to raise_error(ArgumentError)
  end

  it "throws an exception when rover position is not within grid" do 
    @program_bad_rover_position_1 = Program.new("testfile_3.txt")
    expect { @program_bad_rover_position_1.run }.to raise_error(ArgumentError)
  end

  it "throws an exception when rover position/orientation input is not correct" do 
    @program_bad_rover_position_2 = Program.new("testfile_4.txt")
    expect { @program_bad_rover_position_2.run }.to raise_error(ArgumentError)
  end

  it "throws an exception when rover instruction input is not correct" do 
    @program_bad_rover_instruction = Program.new("testfile_5.txt")
    expect { @program_bad_rover_instruction.run }.to raise_error(ArgumentError)
  end
end