defmodule Systems.Graphite.Presenter do
  @behaviour Frameworks.Concept.Presenter

  alias Systems.{
    Graphite
  }

  @impl true
  def view_model(page, %Graphite.ToolModel{} = tool, assigns) do
    builder(page).view_model(tool, assigns)
  end

  defp builder(Graphite.ToolPage), do: Graphite.ToolPageBuilder
end