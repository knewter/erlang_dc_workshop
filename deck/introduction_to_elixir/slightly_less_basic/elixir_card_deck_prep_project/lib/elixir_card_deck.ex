defmodule ElixirCardDeck do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    ElixirCardDeck.Supervisor.start_link
  end

  def make_deck do
    []
  end
end
