defmodule CoreWeb.Live.SupportTest do
  use CoreWeb.ConnCase, async: true
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  alias Core.Helpdesk
  alias CoreWeb.Support

  setup [:login_as_member]

  describe "create support ticket" do
    test "a member can submit a new ticket", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, Support))

      view
      |> element("form")
      |> render_submit(%{ticket: %{title: "my ticket", description: "a ticket description"}})

      assert %{description: "a ticket description"} =
               Helpdesk.list_open_tickets() |> Enum.find(&(&1.title == "my ticket"))
    end
  end
end
