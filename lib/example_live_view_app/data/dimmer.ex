defmodule ExampleLiveViewApp.Data.Dimmer do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExampleLiveViewApp.Data.Dimmer
  alias ExampleLiveViewApp.Repo

  schema "dimmers" do
    field :blue, :integer
    field :brightness, :integer
    field :green, :integer
    field :name, :string
    field :red, :integer
    field :state, :boolean, default: false
    field :white, :integer

    timestamps()
  end

  @doc false
  def changeset(dimmer, attrs) do
    dimmer
    |> cast(attrs, [:name, :state, :brightness, :white, :red, :green, :blue])
    |> validate_required([:name, :state, :brightness, :white, :red, :green, :blue])
  end

  def insert(attrs) do
    changeset(%Dimmer{}, attrs)
    |> Repo.insert()
  end

  def update(light, attrs) do
    changeset(light, attrs)
    |> Repo.update()
  end

  def delete(dimmer) do
    Repo.delete(dimmer)
  end

  def list_all() do
    Repo.all(Dimmer)
  end
end
