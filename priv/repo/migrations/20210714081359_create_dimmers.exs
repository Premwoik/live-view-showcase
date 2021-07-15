defmodule ExampleLiveViewApp.Repo.Migrations.CreateDimmers do
  use Ecto.Migration

  def change do
    create table(:dimmers) do
      add :name, :string
      add :state, :boolean, default: false, null: false
      add :brightness, :integer
      add :white, :integer
      add :red, :integer
      add :green, :integer
      add :blue, :integer

      timestamps()
    end
  end
end
