defmodule KluisWeb.VaultLiveTest do
  use KluisWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Index" do
    test "renders", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.vault_index_path(conn, :index))

      assert html =~ "De Kluis"
    end
  end
end
