defmodule ExampleLiveViewApp.Repo.Migrations.CreateLights do
  use Ecto.Migration

  def change do
    create table(:lights) do
      add :name, :string
      add :state, :boolean, default: false, null: false

      timestamps()
    end
  end
end
