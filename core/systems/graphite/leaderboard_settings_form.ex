defmodule Systems.Graphite.LeaderboardSettingsForm do
  use CoreWeb.LiveForm, :fabric
  use Fabric.LiveComponent

  import Frameworks.Pixel.Form

  alias Frameworks.Pixel.Text

  alias Systems.{
    Graphite
  }

  @visibility_options [
    %{id: "public", value: "public", active: true},
    %{id: "private", value: "private", active: false},
    %{id: "private with date", value: "private with date", active: false}
  ]

  @allow_anonymous_options [
    %{id: "false", value: false, active: true},
    %{id: "true", value: true, active: false}
  ]

  @impl true
  def update(%{id: id, leaderboard: leaderboard}, socket) do
    changeset = Graphite.LeaderboardModel.changeset(leaderboard, %{})

    {
      :ok,
      socket
      |> assign(
        id: id,
        leaderboard: leaderboard,
        changeset: changeset,
        visibility_options: @visibility_options,
        allow_anonymous_options: @allow_anonymous_options
      )
    }
  end

  @impl true
  def handle_event("save", %{"leaderboard_model" => attrs}, socket) do
    %{assigns: %{leaderboard: leaderboard}} = socket

    attrs =
      if attrs["metrics"] do
        Map.put(attrs, "metrics", string_to_metrics(attrs["metrics"]))
      else
        attrs
      end

    {
      :noreply,
      socket
      |> save(leaderboard, attrs)
    }
  end

  defp save(socket, entity, attrs) do
    changeset = Graphite.LeaderboardModel.changeset(entity, attrs)

    socket
    |> save(changeset)
  end

  defp metrics_to_string(nil), do: ""
  defp metrics_to_string(metrics), do: Enum.join(metrics, ",")

  defp string_to_metrics(metric_str) do
    metric_str
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form id={"#{@id}_settings"} :let={form} for={@changeset} phx-change="save" phx-target={@myself} >
        <.spacing value="L" />
        <Text.title2>Settings</Text.title2>
        <.text_input form={form} field={:name} label_text="Name" />
        <.text_input form={form} field={:version} label_text="Version" />
        <.number_input form={form} field={:tool_id} label_text="Challenge ID" />
        <.list_input form={form} field={:metrics} label_text="Metrics" value={metrics_to_string(@changeset.data.metrics)} />
        <.radio_group form={form} field={:visibility} items={@visibility_options} label_text="Visibility" />
        <.radio_group form={form} field={:allow_anonymous} items={@allow_anonymous_options} label_text="Allow anonymous" />
      </.form>
    </div>
    """
  end
end
