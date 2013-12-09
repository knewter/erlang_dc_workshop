defmodule ElixirCardDeck do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    ElixirCardDeck.Supervisor.start_link
  end

  def make_deck do
    lc value inlist values, suit inlist suits, do: {:card, value, suit}
  end

  defp suits do
    [:spades, :clubs, :diamonds, :hearts]
  end

  def values do
    [:a, 2, 3, 4, 5, 6, 7, 8, 9, 10, :j, :q, :k]
  end
end
