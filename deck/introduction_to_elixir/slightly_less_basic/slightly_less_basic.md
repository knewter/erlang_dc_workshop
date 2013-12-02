# Slightly Less Basic Elixir

But still pretty basic...


# Slightly Less Basic Elixir

- List Comprehensions
- Records
- Processes
- Pipe Operator


## List Comprehensions

- What are List Comprehensions for?
- Combining multiple lists


## What are List Comprehensions for?

The general idea behind List Comprehensions is to create a list from one or more
other lists.  Let's look at some basic examples:

From this we get the general principle - for each x in some list, return an
element for a new list.  We also might create a filter to filter out some
potential elements.  From what we've seen so far, this doesn't seem like much
more than some syntactic sugar for mapping lists.  It gets better though :)

```elixir
iex(1)> lc x inlist [1, 2, 3, 4], do: x*2
[2, 4, 6, 8]

iex(3)> lc x inlist [1, 2, 3, 4], do: [x, x*2]  
[[1, 2], [2, 4], [3, 6], [4, 8]]

iex(6)> lc x inlist [1, 2, 3, 4], rem(x, 2) == 0, do: x
[2, 4]
```


## Combining multiple lists

Let's look at combining a couple of lists:

```elixir
iex(1)> lc x inlist [1, 2, 3], y inlist [4, 5, 6], do: x*y
[4, 5, 6, 8, 10, 12, 12, 15, 18]
```

.note ignore this

So what happened there?  For each x in the first list, it generated an element
for the output list that consisted of that x * each y in the list.  Of course,
the output for a list comprehension can get more interesting.


## Combining multiple lists (cont)

For instance, you might want to generate a list of tuples:

```elixir
iex(3)> lc x inlist [1, 2, 3], y inlist [4, 5, 6], do: {x, y}         
[{1, 4}, {1, 5}, {1, 6}, {2, 4}, {2, 5}, {2, 6}, {3, 4}, {3, 5}, {3, 6}]
```


## Combining multiple lists (cont)

You can of course get a bit fancy.  Let's find all the numbers based on the
first five odd numbers and the first five even numbers where the product minus 1
is divisible by 9:

```elixir
iex(13)> lc x inlist [1, 3, 5, 7, 9], y inlist [2, 4, 6, 8, 10], rem((x*y)-1, 9)
== 0, do: [x, y] [[1, 10], [5, 2], [7, 4]]  
```

.note ignore this line

This is, of course, a contrived example, but it was a pretty comprehensive use
of the features provided by list comprehensions.  Let's go a little bit further.
Let's test drive a module that will generate a deck of cards.

I've gone ahead and provided a test case shell for this for you.  You can find
it at http://github.com/knewter/elixir_card_deck.
We're going to pull that up and see about making the tests pass:


## LIVE CODING LIVE
## CODING LIVE CODING
## LIVE CODING LIVE
## CODING LIVE CODING
## LIVE CODING LIVE
## CODING LIVE CODING


## Summary
Zomg that's it for the first section guys.


## Records
TODO: This section
TODO: Show how to pattern match on a record with a particular value...not sure
how to do that in elixir yet.


## Processes
TODO: This section


## Pipe Operator
TODO: This section


## Resources

- [Elixir Koans](https://github.com/dojo-toulouse/elixir-koans)
- Etudes for Elixir
  - [Book](http://chimera.labs.oreilly.com/books/1234000001642)
  - [Code](https://github.com/oreillymedia/etudes-for-elixir)
