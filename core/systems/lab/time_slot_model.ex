defmodule Systems.Lab.TimeSlotModel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Systems.{
    Lab
  }

  schema "lab_time_slots" do
    belongs_to(:tool, Lab.ToolModel)

    field(:enabled?, :boolean)
    field(:location, :string)
    field(:start_time, :utc_datetime)
    field(:number_of_seats, :integer)

    has_many(:reservations, Lab.ReservationModel, foreign_key: :time_slot_id)

    timestamps()
  end

  @doc false
  def changeset(time_slot, attrs \\ %{}) do
    time_slot
    |> cast(attrs, [:enabled?, :location, :start_time, :number_of_seats])
  end

  def message(%{start_time: start_time, location: location}) do
    date =
      start_time
      |> CoreWeb.UI.Timestamp.to_date()
      |> CoreWeb.UI.Timestamp.humanize_date()

    time =
      start_time
      |> CoreWeb.UI.Timestamp.humanize_time()

    " #{date}  |  #{time}  |  #{location}" |> Macro.camelize()
  end
end
