# Basic Elixir

# Data Types

# Data Types
- Atoms
- Numbers
- Lists
- Tuples
- Keyword Lists
- Regular Expressions
- Booleans

# Atoms
Atoms are just like symbols in Ruby.  They consist of a colon, followed by
letters, digits, and underscores.

Some examples are:

    ::: ruby
    :foo
    :bar
    :"some string"
    :certain_@symbols_are_ok_too

# Atoms (cont)
Atoms are just like, say, integers, in that their name is their value.  Two
atoms with the same name are identical, and will evaluate to each other every
time.

```elixir
:foo == :foo  # true
:bar == "bar" # false
```

In Elixir and Erlang, atoms are used frequently to tag response types.  You'll
often see them as the first element in a tuple, used as a response type.  We'll
see tuples a little later.

# Numbers - Integers
Integers can be written in various ways.  Let's see a few:

```elixir
1234567
1_234_567
1_234_567 == 1234567 # You can use underscores to make numbers easier to read
```

In Elixir, there's no limit on how large an integer can be.

You can do normal sorts of things with these integers:

```elixir
12 + 24 # 36
19 - 100 # -81
```

# Numbers - Floating Points
Floating point numbers have a decimal point.

```elixir
1.23
350.72
.25 #=> (SyntaxError) iex:1: syntax error before: '.'
```

Notice that there must be a number on both sides of the decimal in order to have
a valid floating point number.

# Lists
Lists look like arrays in other languages, although they have different
semantics.  Writing a list is easy:

```elixir
[1,2,3]
[:foo, :bar]
[:also, [:they, :can], [:contain, :lists]]
```

Due to the way they're implemented, the easiest thing to do with a list is to
get its head or its tail - that is, the first element in the list, or all the
remaining elements in a list.  This is because they are actually just linked
lists.

# Lists (cont)
There are a couple of built in functions for accessing the head and tail of a list: `hd` and `tl`.

```elixir
a = [1, 2, 3]
hd(a) # 1
tl(a) # [2, 3]
```

If you want something more like arrays, then you want tuples.

# Tuples
Tuples are ordered collections:

```elixir
{1, 2, 3}
{:foo, :bar}
```

Tuples are used very frequently in Pattern Matching and in return values from
various functions (those two facts are not unrelated).

# Keyword Lists
In Erlang, these data types don't exist.  Elixir provides some
 syntactic sugar around some core Erlang types to provide Keyword Lists.  These
serve the same purpose as hashes in Ruby.

```elixir
[author: "Josh Adams", title: "Basic Elixir"]
```

That's just converted into an array of 2-element tuples, so that's the same as
the following:

```elixir
[{:author, "Josh Adams"}, {:title, "Basic Elixir"}]
```

# Regular Expressions
If you aren't familiar with Regular Expressions, think of them as a concise way
to write rules for pattern matching.  If you *are* familiar with Regexes, Elixir
has Perl Compatible Regular Expressions, so you can mostly use them like you're
used to:

```elixir
Regex.replace %r/[aeiou]/, "Beginning Elixir", "z" # "Bzgznnzng Elzxzr"
```

# Booleans
In Elixir, everything but `false` or `nil` is truthy.  `false` and `nil` are
both shorthands for the atoms with the same name - namely, `:false` and `:nil`.

# Pattern Matching

# Pattern Matching
- Match Operator
- Function Definitions
- Case Statements

# Match Operator
The 'Match Operator' is just the equals sign.  It looks like variable assignment
at first glance, but there's something fishy about it:

```elixir
foo = 1
```

This sets the previously-unbound variable 'foo' to the integer 1.  That's just
assignment, right?

# Match Operator (cont)
Not really.

```elixir
1 = foo
```

If the equals sign is an assignment operator, why was that a valid expression?
It turns out the match operator is really more like making an assertion than it
is assignment - it just turns out that if you assert an unbound variable matches
a value, Elixir will bind the variable and the assertion will pass.

# Match Operator (cont)
If a match fails, you'll get a `MatchError`.  You can see this with the
following:

```elixir
2 = foo
```

`foo` already had the value 1, so the match fails and the `MatchError` is
thrown.  Since so many things depend on Pattern Matching, I'm willing to bet you
will run into `MatchError` quite often as you're learning.  I certainly do (both
here and when I was learning Erlang).

# Match Operator (cont)
Let's try some more advanced matches, to further explore how what we're dealing
with is something entirely different from assignment.

```elixir
{:foo, bar} = {:foo, 3}
```

What did the expression we just typed do?  I'll let you think about it before I
execute it.

```elixir
bar # 3
```

That's right, it bound the previously unbound `bar` variable to the value 3, so
that the match would be successful.

# Match Operator (cont)
Underscores play an interesting role in Elixir.  They tell the compiler that you
don't care about the value in a given position in a Pattern you're matching on.
Sort of like a wildcard for Pattern Matching.  Here's an example:

```elixir
{_, baz} = {1, 2}
baz # 2
```

Imagine we knew that the value we were interested in in the data structure we
were matching was in its second position, and we didn't care about the other
components.  The underscore provides a clear signal to the compiler that we just
don't care about that value.

# Match Operator (cont)
Finally, there's one more important point in Elixir that's different than Erlang
and confused me for a bit.  If you want to use a variable in a pattern match as
a filter (i.e. you want a MatchError thrown if the data on the righthand side
doesn't match the presently-bound value in a given variable) then you need to
signal to the compiler that you don't want to re-bind the variable.  This can be
done with the caret-symbol, or hat (^).

```elixir
[a, 2] = [1, 2]
[a, 2] = [3, 2] # Here, a gets re-bound
[^a, 2] = [4, 2] # MatchError
```

In Erlang, you cannot modify a variable once it's been bound.  Elixir removes
this restriction, and so they had to provide this facility to differentiate
between variable binding and variables used for matches.  It's a decent
trade-off.

# Function Definitions
Pattern matching is used to choose between multiple possible definitions of a
function.  As an example, I'll define a silly function:

```elixir
print_name_egotistically = fn 
  :josh -> "Your name is Josh!"
  _     -> "I don't care what your name is!"
end
print_name_egotistically.(:josh)
print_name_egotistically.(:phil)
```

That function has a different function definition depending on the pattern
matching for its arguments.  This is the first intensely different sort of thing
that we've run into in Elixir so far.  As I was a math major in college, when I
first ran across this sort of thing in Erlang it got me really excited, as
that's really how I often like to see a function defined.

# Case Statements
Case statements can be used for control flow, and they, too, operate based on
Pattern Matching.

```elixir
case {1,2,3} do
  {4,5,6} -> "No match here"
  {1,2,3} -> "This matches"
  {_,2,3} -> "This would match, but since it's below another match it isn't hit."
end
```

# Functions

# Functions
In Elixir, functions are first class types.  This shouldn't be terribly
surprising; it *is* a functional programming language, after all.  Today, we'll
have a look at:

- Defining Anonymous Functions
- Calling Anonymous Functions
- Using Functions as first class types

Let's get started.

# Defining Anonymous Functions
Anonymous functions are defined with the `fn` keyword.  Let's see what that
looks like:

```elixir
print_name = fn
  {:person, first_name, last_name} -> first_name <> " " <> last_name
end
```

Functions take parameter lists and bodies, separated by arrows (`->`).  The
parameter lists are used for Pattern Matching (we actually saw function
declaration in the last episode on Pattern Matching).

The `print_name` function above will match a tuple containing three elements,
when the first element is the atom `:person`.  It then matches to a body that
will concatenate the first and last names together (where by convention, we
assume they will be in the second and third positions in the tuple).

# Calling Anonymous Functions
The syntax to call an anonymous function in Elixir is a little weird looking at
first.  Let's see what it looks like:

```elixir
print_name.({:person, "Josh", "Adams"})
```

That's easy enough, although the dot makes calling them feel different from
calling functions in modules..  What do you think happens if you try to call it
with an argument that doesn't match any of the parameter lists?

# Calling Anonymous Functions (cont)

```elixir
print_name.('foo')
```

It throws a `FunctionClauseError`.

# Calling Anonymous Functions (cont)
Let's define an anonymous function that behaves differently depending on the
argument provided:

```elixir
calculate_bill = fn
  [{:item, price}, {:item, price2}] -> price + price2
  {:item, price} -> price
end
```

Now, this is in fact a silly way to define this function (recursion would make
more sense, so you could accept more than 2 items), but for the purposes of
demonstrating Pattern Matching in functions it's acceptable.

# Calling Anonymous Functions (cont)
Now you can call this function with either a single item or a list containing
two items, and it will return the price.  Let's try it:

```elixir
calculate_bill.([{:item, 20}, {:item, 10}])
calculate_bill.({:item, 35})
```

So that worked, but like we said, it's pretty low-utility - it can only accept
one or two items, tops.  I was going to follow up here by defining the function
recursively, but recursive anonymous functions in Elixir require a bit of
finagling with the Y combinator, so I won't cover that yet.

# Calling Anonymous Functions (cont)
One more fun thing that you can do with anonymous functions is invoke them
immediately.  For instance:

```elixir
(fn -> "foo" end).()
```

Obviously that, too, is a pretty unlikely example, but it serves to show off
immediate invocation, none the less.

# Using Functions as first class types
Since functions are first-class in Elixir, you can pass them as arguments or
return them from other functions.  Let's play with that.

```elixir
add = fn
  num -> (fn num2 -> num + num2 end)
end
```

Here, `add` is a function that takes an argument, and returns a function that will
add that argument to the new function's single argument.  We can use this to
generate a function that adds 3 to its argument:

```elixir
add3 = add.(3)

add3.(5)
```

# Using Functions as first class types (cont)
You can also write functions that take other functions as arguments.  For
example:

```elixir
greet_person = fn
  greeter, {:person, first_name, last_name} -> greeter.(first_name <> " " <> last_name)
end

polite_greeter = fn
  name -> "Hello, #{name}, nice to meet you!"
end

terse_greeter = fn
  name -> "Hi #{name}"
end

person = {:person, "Josh", "Adams"}

greet_person.(polite_greeter, person)
greet_person.(terse_greeter, person)
```

# Mix and Modules

# Mix and Modules
Modules are the primary unit of code organization in Elixir.  They can contain
functions, both private and public.

In this section, we're going to cover:
- Using mix to begin a new project
- Defining a module
- Compiling a module
- Module definitions have return values
- Documenting a Module
- Generating documentation output using ExDoc

# Using Mix to begin a new project

Elixir ships with a tool called `mix` that is used for creating, compiling, and
testing Elixir projects.  To use `mix` to start a new project, use `mix new
#{projectname}`

```bash
mix new modules_example
```

This will generate a few files for you.  You end up with `lib` and `test`
directories, and a few project files.  Let's go ahead and look at the `mix.exs`
file that was generated.

# Using mix to begin a new project (cont)

```
defmodule ModulesExample.Mixfile do
  use Mix.Project

  def project do
    [ app: :modules_example,
      version: "0.0.1",
      elixir: "~> 0.10.2-dev",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end
end
```

That's fairly self-explanatory, so we'll just move on from here.  We'll be
editing this file a bit later.

# Defining a module

Open up an editor and go to the file `lib/modules_example.ex` and edit it to
look like the following:

```elixir
defmodule ModulesExample do
  def publish(message) do
    message
  end
end
```

Save the file, and we'll compile it and see if we can't use that function.

# Compiling a module

There are two ways to get the file compiled and into an `iex` session.  The
first is to just launch `iex` with a module as an argument: `iex
lib/modules_example.ex`  We'll do that and verify that we can call this function.

```shell
$ iex lib/modules_example.ex
Erlang R16B01 (erts-5.10.2) [source-bdf5300] [64-bit] [smp:4:4]
[async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (0.10.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> ModulesExample.publish("foo")
"foo"
```

# Compiling a module (cont)
The second way to compile the module using `elixirc`.  This ships with elixir,
and can be invoked by `elixirc lib/modules_example.ex`.  It will generate a file
named `Elixir.ModulesExample.beam` in the current directory.  If you launch
`iex` from that directory, the module will also be available to you.

# Module definitions have return values
In Elixir, you can also just define a module directly inside the REPL.  For
someone that's coming from Erlang, this will be a bit surprising.  There's a
really interesting feature that comes out of defining a module.  To see what's
happening, type the following into `iex`:

```erlang
output = defmodule Foo do
  def bar do
    "whee"
  end
end
```

You'll notice that `defmodule` returns a tuple.  It's actually got a really neat
structure:

# Module definitions have return values (cont)

```
{:module, Foo,
 <<70, 79, 82, 49, 0, 0, 7, 24, 66, 69, 65, 77, 65, 116, 111, 109, 0, 0, 0, 102,
0, 0, 0, 11, 10, 69, 108, 105, 120, 105, 114, 46, 70, 111, 111, 8, 95, 95, 105,
110, 102, 111, 95, 95, 4, 100, 111, 99, 115, 9, ...>>,
 {:bar, 0}}
```

The tuple contains, in the following order:

- An atom, `:module`
- The constant representing the module: `Foo`
- A binary containing the bytecode defining the module.  This is extremely
  interesting, as it can be used to (for instance) shove this module over into
  another node and load it over the network without that node ever having had
  the source code available to it.
- A tuple describing the last function defined in that module - This is actually
  because the last item in the module definition return value tuple is just the
  return value of the last executed expression in the module.  This happens to
  be the return value of defining a function, which is a tuple containing the
  function name and arity.

# Documenting a Module
Elixir supports module and function documentation as first-class constructs.
They can be defined with the help of things known as module attributes.  These
begin with an `@` within a module.

Let's open up the `ModulesExample` module from before and add documentation to it.
This is achieved by using the `@moduledoc` and `@doc` attributes.  You pass them
a heredoc, and it may contain markdown formatting.

# Documenting a Module (cont)

```elixir
defmodule ModulesExample do
  @moduledoc """
    A module used for training in [ElixirSips](http://www.elixirsips.com).
  """

  @doc """
    Returns the message it is provided.  This is *extremely* valuable!
  """
  def publish(message) do
    message
  end
end
```

# Documenting a Module (cont)
You can access a module's documentation using the `h` helper in `iex`.  To see
this in action, run `iex lib/modules_example.ex`

```
iex(1)> h(ModulesExample) 
ModulesExample

  A module used for training in [ElixirSips](http://www.elixirsips.com).
iex(2)> h(ModulesExample.publish)
* def publish(message)

  Returns the message it is provided.  This is *extremely* valuable!
```

# Documenting a Module (cont)
So that's one way of looking at documentation - it's very convenient to have
access to documentation directly from your REPL, and it's a great feature of the
language.

You can also generate documentation as html (which makes the markdown
support...useful).  To generate documentation for this module, you'll use ExDoc
by way of `mix`.

# Generating documentation output using ExDoc
We need to add ExDoc as a dependency for our project, so `mix` can install it.
Open up mix.exs and add the dependency:

```elixir
defmodule ModulesExample.Mixfile do
  ...
  defp deps do
    [
      { :ex_doc, github: "elixir-lang/ex_doc" } 
    ]
  end
end
```

# Generating documentation output using ExDoc (cont)
Now get mix to install your dependencies:

```bash
mix deps.get
```

Finally, you can generate the documentation with:

```bash
mix docs
```

There you have it - nice documentation output for your modules!

# Summary

# Summary
So this was a brief but relatively thorough basic introduction to Elixir as a
programming language.  We covered syntax and tooling.  In the next section,
we're going to cover testing.
