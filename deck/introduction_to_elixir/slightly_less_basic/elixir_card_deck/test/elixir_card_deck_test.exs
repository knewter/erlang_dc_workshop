defmodule ElixirCardDeckTest do
  use ExUnit.Case

  test "generates the first card appropriately" do
    [first_card | _rest] = ElixirCardDeck.make_deck
    assert first_card == {:card, :a, :spades}
  end

  test "generates the whole deck appropriately" do
    proper_deck = [
      {:card, :a, :spades},
      {:card, :a, :clubs},
      {:card, :a, :diamonds},
      {:card, :a, :hearts},
      {:card, 2,  :spades},
      {:card, 2,  :clubs},
      {:card, 2,  :diamonds},
      {:card, 2,  :hearts},
      {:card, 3,  :spades},
      {:card, 3,  :clubs},
      {:card, 3,  :diamonds},
      {:card, 3,  :hearts},
      {:card, 4,  :spades},
      {:card, 4,  :clubs},
      {:card, 4,  :diamonds},
      {:card, 4,  :hearts},
      {:card, 5,  :spades},
      {:card, 5,  :clubs},
      {:card, 5,  :diamonds},
      {:card, 5,  :hearts},
      {:card, 6,  :spades},
      {:card, 6,  :clubs},
      {:card, 6,  :diamonds},
      {:card, 6,  :hearts},
      {:card, 7,  :spades},
      {:card, 7,  :clubs},
      {:card, 7,  :diamonds},
      {:card, 7,  :hearts},
      {:card, 8,  :spades},
      {:card, 8,  :clubs},
      {:card, 8,  :diamonds},
      {:card, 8,  :hearts},
      {:card, 9,  :spades},
      {:card, 9,  :clubs},
      {:card, 9,  :diamonds},
      {:card, 9,  :hearts},
      {:card, 10, :spades},
      {:card, 10, :clubs},
      {:card, 10, :diamonds},
      {:card, 10, :hearts},
      {:card, :j, :spades},
      {:card, :j, :clubs},
      {:card, :j, :diamonds},
      {:card, :j, :hearts},
      {:card, :q, :spades},
      {:card, :q, :clubs},
      {:card, :q, :diamonds},
      {:card, :q, :hearts},
      {:card, :k, :spades},
      {:card, :k, :clubs},
      {:card, :k, :diamonds},
      {:card, :k, :hearts}
    ]
    assert ElixirCardDeck.make_deck == proper_deck
  end
end
