defmodule ExampleLiveViewApp.Data.Light do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExampleLiveViewApp.Data.Light
  alias ExampleLiveViewApp.Repo

  schema "lights" do
    field :name, :string
    field :state, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(light, attrs) do
    light
    |> cast(attrs, [:name, :state])
    |> validate_required([:name, :state])
  end

  def insert(attrs) do
    changeset(%Light{}, attrs)
    |> Repo.insert()
  end

  def update(light, attrs) do
    changeset(light, attrs)
    |> Repo.update()
  end

  def delete(light) do
    Repo.delete(light)
  end

  def list_all() do
    Repo.all(Light)
  end
end
