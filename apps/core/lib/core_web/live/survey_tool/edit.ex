defmodule CoreWeb.SurveyTool.Edit do
  @moduledoc """
  The home screen.
  """
  use CoreWeb, :live_view

  alias Surface.Components.Form
  alias EyraUI.Form.{TextInput}
  use EyraUI.AutoSave, :survey_tool

  alias Core.SurveyTools

  data(path_provider, :any)

  def load(%{"id" => id}, _session, _socket) do
    SurveyTools.get_survey_tool!(id)
  end

  @impl true
  defdelegate get_changeset(survey_tool, type, attrs \\ %{}),
    to: SurveyTools,
    as: :change_survey_tool

  @impl true
  defdelegate save(changeset), to: SurveyTools, as: :update_survey_tool

  def render(assigns) do
    ~H"""
    <h1>Edit Survey tool</h1>
    <Form for={{ @changeset }} change="save">
      <TextInput field={{:title}} label_text={{dgettext("eyra-account", "title.label")}} />
      <TextInput field={{:survey_url}} label_text={{dgettext("eyra-account", "survey_url.label")}} />
    </Form>
    <span><Surface.Components.Link to={{ @path_provider.live_path(@socket, CoreWeb.SurveyTool.Index) }} >Back</Surface.Components.Link></span>
    """
  end
end
