# Finite State Machines
## Josh Adams

![](https://pbs.twimg.com/profile_images/2284174758/v65oai7fxn47qv9nectx.png)

@knewter


# Finite State Machines
## Josh Adams
![](https://github.global.ssl.fastly.net/images/modules/logos_page/GitHub-Mark.png)

knewter


# Finite State Machines
## Josh Adams

[twitters] - @knewter
[githubs]  - /knewter
[work]     - http://isotope11.com
[videos]   - http://elixirsips.com


# Finite State Machines

- What a Finite State Machine (FSM) is.
- An example FSM diagram that we'll implement.
- How to implement an FSM in Elixir using OTP's GenFSM.

Let's get started.


## What are FSMs?

A Finite State Machine is a means of modelling some computation:

- It can be in one of a limited number of states;
- It has an initial state;
- It can transition from one state to another based on some event or condition.

They can be used to solve a wide range of problems, and often they make
thinking about the problem more clear than it would be with other available
solutions.  For example, I've used FSMs in the past to help less experienced
developers change a black box, scary-looking regular expression from doom into a
tight, meaningful class in which the error in their logic became glaringly
obvious.


## Our example FSM

It's always good to have a problem domain, so we're going to build a Finite
State Machine to match some input and see if it contains the string 'sips'
anywhere in it.  Let's see what that machine would look like:

![](diagram.png)

This is known as an acceptor state machine.  We'll consider a given machine as
'successful' if it ends up in the `got_sips` state, and anything else we
consider unsuccessful.  If it's fed the string 'sips' at any point, it falls
into the `got_sips` state, and can't get out.

It start out in `starting` and proceeds if it is passed an `s` as input.  Any
other input from that state will just transition it into the `starting` state
again.  An `s` takes it to the `got_s` state.

From `got_s`, anything but an `i` will transition it back to the `starting`
state.  An `i` will make it proceed to the `got_si` state.

This repeats for `p`.

Finally, from `got_sip`, if another `s` is received it proceeds to the
`got_sips` state.  At that point, any other input doesn't affect the state of
the machine.

Anyway, let's go forward with the FSM implementation.


## Implementing an FSM using GenFSM

Now that we've got the theory and the domain for our project out of the way,
let's go ahead and start implementing.  Make a new project:

```sh
mix new gen_fsm_playground && cd gen_fsm_playground
```

Now open up a new test file, `test/sips_matcher_test.exs` and add the following:

```elixir
defmodule SipsMatcherTest do
  use ExUnit.Case

  test "[:starting] it successfully consumes the string 's'" do
    fsm = SipsMatcher.start_link
    assert SipsMatcher.consume_s(fsm) == :got_s
  end

  test "[:starting] it successfully consumes strings other than 's'" do
    fsm = SipsMatcher.start_link
    assert SipsMatcher.consume_not_s(fsm) == :starting
  end
end
```

Here we're just defining the beginnings of our `SipsMatcher` GenFSM.  We expect
our public api to consist of `start_link/0`, `consume_s/1`, and
`consume_not_s/1` at the very least.  If we were to run the tests now, we know
they would fail as there's no `SipsMatcher` module, so let's go ahead and define
that module at the top of the file.

```elixir
defmodule SipsMatcher do
  use GenFSM.Behaviour

  # Public API
  def start_link do
    {:ok, fsm} = :gen_fsm.start_link(__MODULE__, [], [])
    fsm
  end

  def consume_s(fsm) do
    :gen_fsm.sync_send_event(fsm, :s)
  end

  def consume_not_s(fsm) do
    :gen_fsm.sync_send_event(fsm, :not_s)
  end
end
```

Now, this is a little bit to take in.  First, we make ourselves a nice
`start_link` function that hides some of the `gen_fsm` interface from our
consumers.  Next, we define a couple of functions for consuming `s` and `not_s`.
Here, we're using the `gen_fsm` `sync_send_event/2` interface.  Generally, you
want to use async here (just `send_event/2`).  However, it's a bit harder to
test async things, so for the sake of demonstration and testability we'll make
this synchronous.  You can look into the docs to find an async example.  No
one's really documented this synchronous-style example anywhere as far as I
could find.


Anyway, this won't work yet because we aren't supporting the GenFSM expected
behaviours yet.  Let's see what that looks like:

```elixir
  # GenFSM API
  def init(_) do
    { :ok, :starting, [] }
  end

  def starting(:s, _from, state_data) do
    { :reply, :got_s, :got_s, state_data }
  end
  def starting(:not_s, _from, state_data) do
    { :reply, :starting, :starting, state_data }
  end
```

Here we're defining an `init/1` function, which is called when the FSM is
initialized, and then we're defining two functions for handling different
transitions out of the `starting` state.  In those transitions, we're replying
to the caller with the next state, then specifying the next state and passing on
our (unused, really) `state_data`.  You can find the full range of return values
that GenFSM knows how to deal with in the docs for GenFSM.Behaviour, which are
linked in the episode notes.

Let's go ahead and run our tests, and they should be passing.

In the interest of time, I'm only going to follow up with two more tests - one
for success, and one for failure.  Let's see what that looks like:

```elixir
  test "it successfully consumes the string 'sips'" do
    fsm = SipsMatcher.start_link
    SipsMatcher.consume_s(fsm)
    SipsMatcher.consume_i(fsm)
    SipsMatcher.consume_p(fsm)
    assert SipsMatcher.consume_s(fsm) == :got_sips
  end

  test "it successfully consumes strings without a match" do
    fsm = SipsMatcher.start_link
    SipsMatcher.consume_s(fsm)
    SipsMatcher.consume_i(fsm)
    SipsMatcher.consume_p(fsm)
    assert SipsMatcher.consume_not_s(fsm) == :starting
  end
```

If you go ahead and run the tests, they fail because we don't have `consume_i`
functions, etc.  Let's define those and their corresponding state machine
handling functions for the GenFSM.Behaviour:

```elixir
  def consume_i(fsm) do
    :gen_fsm.sync_send_event(fsm, :i)
  end

  def consume_p(fsm) do
    :gen_fsm.sync_send_event(fsm, :p)
  end

  def got_s(:i, _from, state_data) do
    { :reply, :got_si, :got_si, state_data }
  end

  def got_si(:p, _from, state_data) do
    { :reply, :got_sip, :got_sip, state_data }
  end

  def got_sip(:s, _from, state_data) do
    { :reply, :got_sips, :got_sips, state_data }
  end
  def got_sip(:not_s, _from, state_data) do
    { :reply, :starting, :starting, state_data }
  end
```

If you run the tests now, they should pass.  We can also add a test real quick
to verify that after consuming 'sips', it can successfully consume anything else
and stay in the successfully accepting state (`got_sips`).  Let's see what that
looks like:

```elixir
  test "it can't fall out of the `got_sips` state" do
    fsm = SipsMatcher.start_link
    SipsMatcher.consume_s(fsm)
    SipsMatcher.consume_i(fsm)
    SipsMatcher.consume_p(fsm)
    SipsMatcher.consume_s(fsm)
    assert SipsMatcher.consume_i(fsm) == :got_sips
  end
```

If you run the tests, it fails because it expects a `got_sips` function to be
defined for the GenFSM.Behaviour.  Let's define that:

```elixir
  def got_sips(_, _from, state_data) do
    { :reply, :got_sips, :got_sips, state_data }
  end
```

Go ahead and run the tests, and they'll pass.


## Take Home Exercise
It would also be nice to know at what point in the input string the first
occurrence of `sips` happened at.  I'll leave that as an exercise for you,
because this is already going to take longer than our ideal episode length.

If you're going to do it, I'd suggest tracking the number of characters
encountered, incrementing it at each step regardless.  Then you'd track the
first `s` you ran into in an `occurence` field, and only update that field (to
match the `number_of_characters` field) in the transition from `starting` to
`got_s`.


## Summary
Anyway, we successfully implement an FSM in Elixir.  Nice.


## Resources
- [Wikipedia page for Finite State Machines](http://en.wikipedia.org/wiki/Finite-state_machine)
- [GenFSM.Behaviour Elixir Documentation](http://elixir-lang.org/docs/master/GenFSM.Behaviour.html)
