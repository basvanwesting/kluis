defmodule KluisWeb.VaultLive.Index do
  use KluisWeb, :live_view

  alias Kluis.Vault

  @impl true
  def mount(_params, _session, socket) do
    {:ok, reset_tally(socket)}
  end

  @impl true
  def handle_event("keypress", %{"key" => key}, socket) do
    case Vault.handle_key(socket.assigns.tally, key) do
      {:ok, tally}     ->
        {
          :noreply,
          assign(socket,
            tally: tally,
            correct: Vault.correct?(tally),
            characters_left: Vault.characters_left(tally),
          )
        }
      {:ignored, _tally} ->
        {:noreply, socket}
      {:wrong, _tally} ->
        Process.send_after(self(), "reset", 500)
        {:noreply, assign(socket, pending_reset: true)}
    end
  end

  def handle_event("reset", _params, socket) do
    {:noreply, reset_tally(socket)}
  end

  @impl true
  def handle_info("reset", socket) do
    {:noreply, reset_tally(socket)}
  end

  def reset_tally(socket, tally \\ "") do
    assign(
      socket,
      tally: tally,
      correct: false,
      pending_reset: false,
      characters_left: Vault.characters_left(tally),
    )
  end

end
