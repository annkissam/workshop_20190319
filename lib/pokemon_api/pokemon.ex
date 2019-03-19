defmodule PokemonApi.Pokemon do
  @moduledoc """
  Data representation for Pokemon
  """

  defstruct ~w(id types name be)a

  @type t ::
      %__MODULE__{
        id: integer(),
        types: [String.t()],
        name: String.t(),
        be: integer()
      }
end
