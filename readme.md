#Thoughtworks Graduate Developer Coding Assignment (Mars Rover)
#####by Till Reiter

### Running instruction
Please run this solution from the command line (Ruby v.1.9.3 on OS X has been tested): 

####Supply input as arguments (multiple input files possible):
```sh
lib $ ruby mars_rover.rb 1.txt (2.txt 3.txt)
```

####Output is printed to console. For output file enter:
```sh
lib $ ruby mars_rover.rb 1.txt > output.txt
```

####Run rspec tests in main directory (after installing gem):
```sh
$ rspec
```

### Description
- Plateau is an instance of the `Plateau` class and gets initialized with maximum (upper right) x / y coordinates.

- Each rover is represented by an instance of the class `Rover` and gets initialized with x/y position coordinates, orientation and the current plateau. 
The instance method `process_instruction` calls instance methods `turn ('L' || 'R')` or `move` with instruction input.
The instance method `report_location` reports the coordinates and position of the rover.

- Every input file gets checked and processed by an instance of the `Program` class which gets initialized with the filename. 
The instance method `run` calls instance methods `open_file`, `create_plateau` and `process_rover_commands` (all instance methods throw exceptions whenever input is incorrect or not existent).
Input files get processed sequentially.

### Assumptions
- There can be unlimited rovers on one plateau coordinate
- Input is entered as provided in the problem description, eg.:
    - 5 5
    - 1 2 N
    - LMLMLMLMM
    - 3 3 E
    - MMRMMRMRRM
- First line sets plateau
- Each following double lines set robots inital position/orientation on first line and instructions on second line
- Every input that does not conform to standard aborts execution and throws exception