defmodule KluisWeb.VaultLive.Index do
  use KluisWeb, :live_view

  alias Kluis.Vault

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, tally: "", correct: false)}
  end

  @impl true
  def handle_event("keypress", %{"key" => key}, socket) do
    case Vault.add_key(socket.assigns.tally, key) do
      {:ok, tally}     ->
        {:noreply, assign(socket, tally: tally, correct: Vault.correct?(tally))}
      {:error, _tally} ->
        {:noreply, socket}
    end
  end
end
