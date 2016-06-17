defmodule Scraper do
  use GenServer

  # ------- Client API

  def start do
    GenServer.start(__MODULE__, :ok, [])
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, [name: name])
  end

  def titles(server, url) do
    GenServer.call(server, {:fetch_titles, url})
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:fetch_titles, url}, _from, state) do
    case _fetch_titles(url) do
      {:ok, titles} -> {:reply, {:ok, titles}, state}
      {:error, reason} -> {:reply, {:error, reason}, state}
    end

  end

  # ------- Private
  defp _fetch_titles(url) do
    url
    |> HTTPoison.get!
    |> parse_headers
  end

  defp parse_headers(%HTTPoison.Response{status_code: status_code, body: body}) do
    case status_code do
      200 ->
        titles = Enum.flat_map ["h1", "h2", "h3"], fn selector ->
          body
          |> Floki.find(selector)
          |> Enum.map(&element_text/1)
        end
        {:ok, titles}
      500 ->
        {:error, "Internal Server Error"}
    end
  end

  defp element_text({_tag, _attributes, [text]}) do
    text
  end

  def handle_info(msg, state) do
    IO.puts "Message not understood :("
    {:noreply, state}
  end
end
