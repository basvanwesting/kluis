defmodule KluisWeb.VaultLive.Index do
  use KluisWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, tally: [])}
  end

  @impl true
  def handle_event("keypress", %{"key" => key}, socket) do
    socket = socket
      |> update(
          :tally,
          fn keys -> [key | keys] end
        )

    {:noreply, socket}
  end
end
