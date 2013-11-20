# Testing


## Testing
- What is testing, and what is good for.
- ExUnit, Elixir's built-in Unit Testing framework.
- Building an example module via TDD.
- An awesome online tool and community called Exercism.io, which hails from the Ruby community originally.
- A great feature Elixir provides called doctests


## What is Testing For?
People usually think:

- Avoid regressions
- i.e., refactor without fear of accidentally changing behaviour


## What is Testing For?
IMO, greater value in:

- Thinking in tests
- Feeling pain when modules start to get too complex.  If the tests are getting hard to write, odds are the code is doing too much.
- Once I knew how to test in Erlang, I had working chat server in just a few hours.  I spent weeks before that on more trivial projects.


## Unit Testing
Unit testing is a means of testing just a single 'unit' in your system.  This
can be contrasted with an acceptance test, which tests the behaviour of a system
as a whole, and verifies that it satisfies the overarching requirements.

Unit tests, on the other hand, are focused with a single portion of the system,
and should fake, or 'mock' any collaborators out, so that a single portion of
the system can be verified on its own.


## Unit Testing
- ExUnit
- Defining Tests
- Assertions
- Examples / live coding
- Exercism.io - just a plug
- Doctests - ZOMG


## ExUnit
Elixir comes with a built in tool for writing unit tests, called `ExUnit`.  An
ExUnit test case is just a module that uses `ExUnit.Case`.  We'll build a test
case in a little bit, but for now I'll just tell you a few more things about
ExUnit.


## Defining Tests
`ExUnit.Case` will run all functions whose names start with `test` that have arity
1 - that means, they only take a single argument.

For instance, you could define a function like this:

```elixir
def test_one_is_one(_) do
  assert 1 == 1
end

# However, ExUnit provides a `test` macro that allows you to write your tests a
# bit easier on the eyes:

test "one is one" do
  assert 1 == 1
end
```


## Assertions
We just saw `assert`, which is a macro provided by ExUnit to
describe the intended behaviour of your system.

For instance, if you have the following test case:

```elixir
test "one is two" do
  assert 1 == 2
end
```

.note this line is ignored

When you run the suite, this test will fail with "Expected 1 to be (==) 2".  The
inverse of `assert` is `refute`.  These two macros provide most of what you'll
need to write your tests.  There are a few others provided, and you can check
them out in [ExUnit's Assertions documentation](http://elixir-lang.org/docs/stable/ExUnit.Assertions.html)


## LIVE CODING LIVE
## CODING LIVE CODING
## LIVE CODING LIVE
## CODING LIVE CODING
## LIVE CODING LIVE
## CODING LIVE CODING


## Exercism.io
Katrina Owen built a fantastic tool/community known as [exercism.io](http://www.exercism.io)
The goal is to get and give peer review while doing basic code katas, and to try
to converge on the 'ideal' solution to various given problems in different
languages.  They have an Elixir track, and it was the first Elixir code I ever
wrote.  I'd definitely suggest people go over there and get an account - it will
help you hone your chops, with great feedback from people who care.


## Doctests
Elixir also ships with support for something called doctests.  Basically, if you
place an example `iex` session in your module or function documentation, you can
easily verify its behaviour by specifying a doctest in your test case.

This was cribbed from Python, to my knowledge, but coming from Ruby I never have
had a chance to play with it.  It's amazing.  Let's go ahead and add a doctest
to the Schizo module so you can see how it works:

```elixir
@moduledoc """
This is a module that provides odd behaviour for transforming every other word in a string.

Here are some examples:

iex> Schizo.uppercase("this is an example")
"this IS an EXAMPLE"

iex> Schizo.unvowel("this is an example")
"this s an xmpl"
"""
```


## Doctests (cont)

To add these doctests to your test suite, open up the `SchizoTest` module and
just add the following line:

```elixir
doctest Schizo
```

.note ignore this line

Then, run the tests again, and two new test cases have been added.  Pretty cool,
huh?  Gone are the days of documentation that is subtly incorrect!
