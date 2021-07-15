defmodule ExampleLiveViewAppWeb.PageLiveTest do
  use ExampleLiveViewAppWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Hello All!"
    assert render(page_live) =~ "Hello All!"
  end
end
