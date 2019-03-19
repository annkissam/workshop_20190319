defmodule PokemonBox do
  @moduledoc """
  In-memory storage for pokemon

  Sorted by latest added
  """

  use GenServer

  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add(%PokemonApi.Pokemon{} = pokemon) do
    GenServer.call(__MODULE__, {:add, pokemon})
  end

  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
  end

  def list do
    GenServer.call(__MODULE__, :list)
  end

  # Callbacks

  @impl true
  def init(pokemon_list) do
    {:ok, pokemon_list}
  end

  @impl true
  def handle_call({:add, pokemon}, _from, pokemon_list) do
    {:reply, pokemon, [pokemon | pokemon_list]}
  end

  @impl true
  def handle_call({:get, id}, _from, pokemon_list) do
    pokemon = Enum.find(pokemon_list, & &1.id == id)
    {:reply, pokemon, pokemon_list}
  end

  @impl true
  def handle_call(:list, _from, pokemon_list) do
    {:reply, pokemon_list, pokemon_list}
  end
end
