# ErlangDC Elixir Workshop

This is the code and text for a three hour elixir workshop on December 7, 2013
in Washington, D.C. for the ErlangDC one day conference.

## Running it
To run this presentation, do the following:

```
bundle
vimdeck deck/introduction_to_elixir/basic_elixir.md
```

## Outline

Since it's a comically long talk, it's broken up into the following sections:

- Introduction to Elixir
  - Basic Elixir
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
  - Testing
    - What is Testing For?
    - Unit Testing
      - ExUnit
      - Defining Tests
      - Assertions
      - Examples / live coding
      - Plug Exercism.io
      - Doctests - ZOMG
  - Slightly less basic Elixir (but still pretty basic)
    - List Comprehensions
    - Records
    - Processes
    - Pipe Operator
- Introduction to OTP with Elixir
  - Servers
  - Finite State Machines
  - GenEvent
  - Supervisors
    - Basic
    - Adding Persistent State (let it crash...but don't forget stuff)
- Building a project with Elixir
  - Unsure what project I need to do here...figure it out

