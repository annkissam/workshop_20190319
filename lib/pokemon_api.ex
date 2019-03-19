defmodule PokemonApi do
  @moduledoc """
  API for interacting with Pokemon
  """

  @base_url ~s(https://pokeapi.co/api/v2/pokemon)

  def get(id) do
    id
    |> format_id()
    |> _do_get(times: 10)
    |> to_pokemon()
  end

  defp format_id(id) when is_integer(id), do: Integer.to_string(id)
  defp format_id(id), do: id

  defp _do_get(id, times: times) when times < 1 do
    case HTTPoison.get(complete_url(id)) do
      {:ok, response} -> response
      {:error, %HTTPoison.Error{reason: reason}} ->
        raise """
        Tried a lot, but no results for #{complete_url(id)}:
        #{reason}
        """
    end
  end
  defp _do_get(id, times: times) do
    case HTTPoison.get(complete_url(id)) do
      {:ok, response} -> response
      _ -> _do_get(id, times: times - 1)
    end
  end


  defp to_pokemon(%HTTPoison.Response{body: body}) do
    # trusting pokeapi's response
    map = Jason.decode!(body)

    %PokemonApi.Pokemon{
      be: map["base_experience"],
      id: map["id"],
      name: map["name"],
      types: Enum.map(map["types"], & &1["type"]["name"])
    }
  end

  defp complete_url(id) do
    Path.join(@base_url, id)
  end
end
