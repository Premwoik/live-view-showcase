defmodule ExampleLiveViewAppWeb.CountersLiveTest do
  use ExampleLiveViewAppWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/counters")
    assert disconnected_html =~ "Counters"
    assert render(page_live) =~ "Counters"
  end

  test "add new counter", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/counters")
    assert disconnected_html =~ "Counters"
    assert render(page_live) =~ "Counters"

    html =
      page_live
      |> element("button", "Add counter")
      |> render_click()

    assert html =~ "Counter 0"

    html =
      page_live
      |> element("button", "Add counter")
      |> render_click()

    assert html =~ "Counter 0"
    assert html =~ "Counter 1"
  end

  test "remove counter", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/counters")
    assert disconnected_html =~ "Counters"
    assert render(page_live) =~ "Counters"

    refute disconnected_html =~ "Counter 0"

    html =
      page_live
      |> element("button", "Add counter")
      |> render_click()

    assert html =~ "Counter 0"

    html =
      page_live
      |> element("button", "Add counter")
      |> render_click()

    assert html =~ "Counter 0"
    assert html =~ "Counter 1"

    html =
      page_live
      |> element("button", "Remove counter")
      |> render_click()

    assert html =~ "Counter 0"
    refute html =~ "Counter 1"
  end

  test "increase counter", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/counters")

    html =
      page_live
      |> element("button", "Add counter")
      |> render_click()

    assert html =~ "<p>0</p>"

    html =
      page_live
      |> element("button", "Increase")
      |> render_click()

    assert html =~ "<p>1</p>"

    html =
      page_live
      |> element("button", "Increase")
      |> render_click()

    assert html =~ "<p>2</p>"
  end

  test "reset counter", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/counters")

    html =
      page_live
      |> element("button", "Add counter")
      |> render_click()

    assert html =~ "<p>0</p>"

    html =
      page_live
      |> element("button", "Increase")
      |> render_click()

    assert html =~ "<p>1</p>"

    html =
      page_live
      |> element("#counter_0 button", "Reset")
      |> render_click()

    assert html =~ "<p>0</p>"
  end

  test "reset all counters", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/counters")

    html =
      page_live
      |> element("button", "Add counter")
      |> render_click()

    assert html =~ "<p>0</p>"

    html =
      page_live
      |> element("button", "Increase")
      |> render_click()

    assert html =~ "<p>1</p>"

    page_live
    |> element(".management button", "Reset all")
    |> render_click()

    assert render(page_live) =~ "<p>0</p>"
  end

  test "multiple counters", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/counters")

    page_live
    |> element("button", "Add counter")
    |> render_click()

    page_live
    |> element("button", "Add counter")
    |> render_click()

    page_live
    |> element("#counter_0 button", "Increase")
    |> render_click()

    page_live
    |> element("#counter_1 button", "Increase")
    |> render_click()

    html =
      page_live
      |> element("#counter_1 button", "Increase")
      |> render_click()

    {:ok, document} = Floki.parse_document(html)
    assert Floki.find(document, "#counter_0 p") |> Floki.text() == "1"
    assert Floki.find(document, "#counter_1 p") |> Floki.text() == "2"

    page_live
    |> element(".management button", "Reset all")
    |> render_click()

    {:ok, document} =
      render(page_live)
      |> Floki.parse_document()

    assert Floki.find(document, "#counter_0 p") |> Floki.text() == "0"
    assert Floki.find(document, "#counter_1 p") |> Floki.text() == "0"
  end
end
