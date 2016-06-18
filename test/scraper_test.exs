defmodule ScraperTest do
  use ExUnit.Case

  test "start supervised worker and get results" do
    titles = [ "Lo más importante del día",
      "Una nena ganó un concurso de princesas vestida de pancho",
      "¿Es peligroso comer huevos todos los días?",
      "¿Cómo maquillarte para una cita?"]
    {:ok, sup_pid} = Scraper.Supervisor.start_link
    {:ok, worker_pid} = Supervisor.start_child(sup_pid, [:server])
    assert Scraper.titles(:server, "http://localhost:3000/foo") == {:ok, titles}
  end

  test "start supervised worker and get error" do
    {:ok, sup_pid} = Scraper.Supervisor.start_link
    {:ok, worker_pid} = Supervisor.start_child(sup_pid, [:server])
    assert Scraper.titles(:server, "http://localhost:3000/bar") == {:error, "Internal Server Error"}
  end

  test "broke supervised worker" do
    {:ok, sup_pid} = Scraper.Supervisor.start_link
    {:ok, worker_pid} = Supervisor.start_child(sup_pid, [:server])

    # Finish the server in an abnormal way
    GenServer.stop(:server, :kill)
    :timer.sleep(500)
    assert Process.alive?(Process.whereis(:server))

    # Finish the server in a normal way
    GenServer.stop(:server, :normal)
    :timer.sleep(500)
    assert Process.whereis(:server) == nil
  end

end
