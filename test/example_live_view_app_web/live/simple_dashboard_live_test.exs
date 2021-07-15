defmodule ExampleLiveViewAppWeb.SimpleDashboardLiveTest do
  use ExampleLiveViewAppWeb.ConnCase

  import Phoenix.LiveViewTest

  alias ExampleLiveViewApp.Data.Dimmer
  alias ExampleLiveViewApp.Data.Light

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/dash")
    assert disconnected_html =~ "Dashboard"
    assert render(page_live) =~ "Dashboard"
  end

  describe "edition" do
    test "edit button activates edition mode and shows forms", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/dash")

      html =
        view
        |> element("button", "Edit")
        |> render_click()

      assert html =~ "type_select_form"
      assert html =~ "item_edit_form"
    end

    test "abort button deactivates edition mode and hides forms", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/dash")

      view
      |> element("button", "Edit")
      |> render_click()

      html =
        view
        |> element("button", "Abort")
        |> render_click()

      refute html =~ "type_select_form"
      refute html =~ "item_edit_form"
    end

    test "edit light form shows correctly", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/dash")

      view
      |> element("button", "Edit")
      |> render_click()

      html =
        view
        |> form("#type_select_form", %{"item_create_data" => %{"item_type" => "light"}})
        |> render_change()

      {:ok, doc} = Floki.parse_document(html)
      edit_form = Floki.find(doc, "#item_edit_form")
      assert Floki.find(edit_form, "#item_name") != []
      assert Floki.find(edit_form, "#item_state") != []
      refute Floki.find(edit_form, "#item_brightness") != []
    end

    test "edit dimmer form shows correctly", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/dash")

      view
      |> element("button", "Edit")
      |> render_click()

      html =
        view
        |> form("#type_select_form", %{"item_create_data" => %{"item_type" => "dimmer"}})
        |> render_change()

      {:ok, doc} = Floki.parse_document(html)
      edit_form = Floki.find(doc, "#item_edit_form")
      assert Floki.find(edit_form, "#item_name") != []
      assert Floki.find(edit_form, "#item_state") != []
      assert Floki.find(edit_form, "#item_brightness") != []
      assert Floki.find(edit_form, "#item_white") != []
      assert Floki.find(edit_form, "#item_red") != []
      assert Floki.find(edit_form, "#item_green") != []
      assert Floki.find(edit_form, "#item_blue") != []
    end

    test "add new dimmer", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/dash")

      view
      |> element("button", "Edit")
      |> render_click()

      view
      |> form("#type_select_form", %{"item_create_data" => %{"item_type" => "dimmer"}})
      |> render_change()

      html =
        view
        |> form("#item_edit_form", %{
          item: %{
            name: "Test dimmer 1",
            state: false,
            brightness: 100,
            white: 255,
            red: 255,
            green: 255,
            blue: 255
          }
        })
        |> render_submit()

      assert html =~ "Saved!"

      refute html =~ "type_select_form"
      refute html =~ "item_edit_form"

      assert [%Dimmer{name: "Test dimmer 1"}] = Dimmer.list_all()
    end

    test "add new light", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/dash")

      view
      |> element("button", "Edit")
      |> render_click()

      view
      |> form("#type_select_form", %{item_create_data: %{item_type: "light"}})
      |> render_change()

      html =
        view
        |> form("#item_edit_form", %{
          item: %{
            name: "Test light 1",
            state: true
          }
        })
        |> render_submit()

      assert html =~ "Saved!"

      assert [%Light{name: "Test light 1", state: true}] = Light.list_all()
    end

    test "items are allowed to edit when in edition mode", %{conn: conn} do
      [l1, l2, l3] = insert_lights()
      [d1, d2] = insert_dimmers()

      {:ok, view, _html} = live(conn, "/dash")

      html =
        view
        |> element("button", "Edit")
        |> render_click()

      edit_text = "edit"
      {:ok, doc} = Floki.parse_document(html)
      assert edit_text == Floki.find(doc, "#light_#{l1.id} a") |> Floki.text()
      assert edit_text == Floki.find(doc, "#light_#{l2.id} a") |> Floki.text()
      assert edit_text == Floki.find(doc, "#light_#{l3.id} a") |> Floki.text()
      assert edit_text == Floki.find(doc, "#dimmer_#{d1.id} a") |> Floki.text()
      assert edit_text == Floki.find(doc, "#dimmer_#{d2.id} a") |> Floki.text()
    end

    test "edit exist light", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/dash")

      view
      |> element("button", "Edit")
      |> render_click()

      view
      |> form("#type_select_form", %{item_create_data: %{item_type: "light"}})
      |> render_change()

      html =
        view
        |> form("#item_edit_form", %{
          item: %{
            name: "Test light 1",
            state: true
          }
        })
        |> render_submit()

      assert html =~ "Saved!"

      assert [%Light{name: "Test light 1", state: true}] = Light.list_all()
    end
  end

  def insert_lights() do
    {:ok, l1} = Light.insert(%{name: "Test light 1", state: false})
    {:ok, l2} = Light.insert(%{name: "Test light 2", state: true})
    {:ok, l3} = Light.insert(%{name: "Test light 3", state: false})
    [l1, l2, l3]
  end

  def insert_dimmers() do
    {:ok, d1} =
      Dimmer.insert(%{
        name: "Test dimmer 1",
        state: false,
        brightness: 100,
        white: 255,
        red: 255,
        green: 255,
        blue: 255
      })

    {:ok, d2} =
      Dimmer.insert(%{
        name: "Test dimmer 2",
        state: false,
        brightness: 100,
        white: 255,
        red: 255,
        green: 255,
        blue: 255
      })

    [d1, d2]
  end
end
