defmodule Core.Accounts.Features do
  @moduledoc """
  This schema contains features of members.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Core.Accounts.User

  alias Core.Enums.{Genders, DominantHands, NativeLanguages, StudyProgramCodes}
  require Core.Enums.{Genders, DominantHands, NativeLanguages, StudyProgramCodes}

  schema "user_features" do
    field(:gender, Ecto.Enum, values: Genders.schema_values())
    field(:dominant_hand, Ecto.Enum, values: DominantHands.schema_values())
    field(:native_language, Ecto.Enum, values: NativeLanguages.schema_values())
    field(:study_program_codes, {:array, Ecto.Enum}, values: StudyProgramCodes.schema_values())

    belongs_to(:user, User)
    timestamps()
  end

  @fields ~w(gender dominant_hand native_language study_program_codes)a
  @required_fields ~w()a

  @doc false
  def changeset(tool, :mount, params) do
    tool
    |> cast(params, @fields)
  end

  def changeset(tool, :auto_save, params) do
    tool
    |> cast(params, @fields)
    |> validate_required(@required_fields)
  end
end
