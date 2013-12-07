# ErlangDC Elixir Workshop

This is the code and text for a three hour elixir workshop on December 7, 2013
in Washington, D.C. for the ErlangDC one day conference.

## Running it
To run this presentation, do the following:

```
bundle # Then make sure you've done a `git submodule init; git submodule update` in the reveal-ck gem
cd reveal_deck/introduction_to_elixir/basic_elixir/
reveal-ck generate
servedir # this is an alias I have that just does `ruby -run -e httpd . -p 9091` to serve current dir files on port 9091
```

## Prep Work
There will be live coding examples, so go ahead and get a tmux session open on
both monitors so you don't have to look at the screen to see what you're typing:

In one terminal, which goes on your laptop screen:

```sh
tmux
# (then rename the session to 'examples')
```

And in another, which goes on the projector:

```sh
tmux a -t examples
```

## Outline

Since it's a comically long talk, it's broken up into the following sections:

- Introduction to Elixir
  - Basic Elixir [25 minutes]
    - Data Types
      - Atoms
      - Numbers
      - Lists
      - Tuples
      - Keyword Lists
      - Regular Expressions
      - Booleans
    - Pattern Matching
      - Match Operator
      - Some basic matches 
      - Function Definitions
      - Case Statements
    - Functions
      - Defining Anonymous Functions
      - Calling Anonymous Functions
      - Using Functions as First-Class Types
    - Mix and Modules
      - Using mix to begin a new project
      - Defining a module
      - Compiling a module
      - Module definitions have return values
      - Document a Module
      - Generating documentation output using ExDoc
  - Testing [20 minutes]
    - What is Testing For?
    - Unit Testing
      - ExUnit
      - Defining Tests
      - Assertions
      - Examples / live coding
      - Plug Exercism.io
      - Doctests - ZOMG
  - Slightly less basic Elixir (but still pretty basic) [25 minutes]
    - List Comprehensions
    - Records
    - Pipe Operator
    - Recursion
    - Processes
- Introduction to OTP with Elixir
  - Servers [15 minutes]
  - Finite State Machines [20 minutes]
  - GenEvent [15 minutes]
  - Supervisors
    - Basic
    - Adding Persistent State (let it crash...but don't forget stuff)
- Building a project with Elixir
  - Unsure what project I need to do here...figure it out

