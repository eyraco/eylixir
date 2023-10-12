defmodule Systems.Assignment.CrewPage do
  use CoreWeb, :live_view
  use Systems.Observatory.Public
  use CoreWeb.Layouts.Stripped.Component, :projects

  alias Frameworks.Concept

  alias Systems.{
    Assignment,
    Project,
    Workflow,
    Crew
  }

  import Assignment.StartView
  import Project.ToolRefView
  import Workflow.ItemViews, only: [work_list: 1]

  @impl true
  def get_authorization_context(%{"id" => id}, _session, _socket) do
    %{crew: crew} = Assignment.Public.get!(String.to_integer(id), [:crew])
    crew
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    model = Assignment.Public.get!(id, Assignment.Model.preload_graph(:down))

    {
      :ok,
      socket
      |> assign(
        id: id,
        model: model,
        tool_ref_view: nil
      )
      |> observe_view_model()
      |> update_selected_item()
      |> update_start_view()
      |> update_work_list()
      |> update_menus()
    }
  end

  defoverridable handle_view_model_updated: 1

  def handle_view_model_updated(socket) do
    socket
    |> update_selected_item()
    |> update_start_view()
    |> update_work_list()
    |> update_menus()
  end

  defp update_selected_item(%{assigns: %{selected_item: {_, _}}} = socket) do
    socket
  end

  defp update_selected_item(%{assigns: %{vm: %{items: []}}} = socket) do
    socket |> assign(selected_item: nil)
  end

  defp update_selected_item(%{assigns: %{vm: %{items: [item]}}} = socket) do
    socket |> assign(selected_item: item)
  end

  defp update_selected_item(%{assigns: %{vm: %{items: items}}} = socket) do
    selected_item =
      Enum.find(items, List.first(items), fn {_, %{status: status}} -> status == :pending end)

    socket |> assign(selected_item: selected_item)
  end

  defp update_start_view(
         %{
           assigns: %{
             selected_item:
               {%{title: title, description: description, group: group}, _task} = selected_item
           }
         } = socket
       ) do
    button = %{
      action: start_action(selected_item),
      face: %{type: :primary, label: "Start"}
    }

    start_view = %{
      title: title,
      description: description,
      icon: group,
      button: button
    }

    socket |> assign(start_view: start_view)
  end

  defp update_start_view(socket), do: socket |> assign(start_view: nil)

  defp start_action({%{tool_ref: tool_ref}, _task} = item) do
    Project.ToolRefModel.tool(tool_ref)
    |> Concept.ToolModel.launcher()
    |> start_action(item)
  end

  defp start_action(%{function: _, props: _}, {%{id: id}, _}) do
    %{type: :send, event: "start", item: id}
  end

  defp start_action(%{url: url}, _) do
    %{type: :http_get, to: url, target: "_blank"}
  end

  defp start_action(_, {%{id: id}, _}) do
    %{type: :send, event: "start", item: id}
  end

  defp update_work_list(
         %{assigns: %{vm: %{items: items}, selected_item: {%{id: selected_item_id}, _}}} = socket
       ) do
    work_list = %{
      items: Enum.map(items, &map_item/1),
      selected_item_id: selected_item_id
    }

    socket |> assign(work_list: work_list)
  end

  defp map_item({%{id: id, title: title, group: group}, task}) do
    %{id: id, title: title, icon: group, status: task_status(task)}
  end

  defp task_status(%{status: status}), do: status
  defp task_status(_), do: :pending

  @impl true
  def handle_info(
        {:complete_task, _},
        %{assigns: %{vm: %{items: items}, selected_item: {%{id: selected_item_id}, _}}} = socket
      ) do
    {_, task} = Enum.find(items, fn {%{id: id}, _} -> id == selected_item_id end)

    Crew.Public.activate_task(task)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "work_item_selected",
        %{"item" => item_id},
        %{assigns: %{vm: %{items: items}}} = socket
      ) do
    item_id = String.to_integer(item_id)
    item = Enum.find(items, fn {%{id: id}, _} -> id == item_id end)

    {
      :noreply,
      socket
      |> assign(
        selected_item: item,
        tool_ref_view: nil
      )
      |> update_start_view()
      |> update_work_list()
    }
  end

  @impl true
  def handle_event("start", %{"item" => item_id}, %{assigns: %{vm: %{items: items}}} = socket) do
    item_id = String.to_integer(item_id)
    {%{tool_ref: tool_ref}, task} = Enum.find(items, fn {%{id: id}, _} -> id == item_id end)

    tool_ref_view = %{
      tool_ref: tool_ref,
      task: task
    }

    Crew.Public.lock_task(task)

    {
      :noreply,
      socket |> assign(tool_ref_view: tool_ref_view, start_view: nil)
    }
  end

  @impl true
  def handle_event("app_event", event, socket) do
    {
      :noreply,
      socket |> handle_app_event(event)
    }
  end

  defp handle_app_event(%{assigns: %{selected_item: {_, task}}} = socket, %{
         "__type__" => "CommandSystemExit",
         "code" => code,
         "info" => _info
       }) do
    if code == 0 do
      Crew.Public.activate_task(task)
      socket
    else
      Frameworks.Pixel.Flash.put_error(socket, "Application stopped")
    end
  end

  defp handle_app_event(socket, %{
         "__type__" => "CommandSystemDonate",
         "json_string" => _json_string
       }) do
    socket |> Frameworks.Pixel.Flash.put_info("Donation received")
  end

  defp handle_app_event(socket, %{"__type__" => type}) do
    socket |> Frameworks.Pixel.Flash.put_error("Unsupported event " <> type)
  end

  defp handle_app_event(socket, _) do
    socket |> Frameworks.Pixel.Flash.put_error("Unsupported event")
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.stripped menus={@menus} footer?={false}>
      <div class="w-full h-full flex flex-row">
        <div class="w-left-column">
          <.work_list {@work_list} />
        </div>
        <div class="border-l border-grey4">
        </div>
        <div class="flex-1">
          <%= if @tool_ref_view do %>
            <.tool_ref_view {@tool_ref_view}/>
          <% else %>
            <%= if @start_view do %>
              <.start_view {@start_view} />
            <% else %>
              Empty
            <% end %>
          <% end %>
        </div>
      </div>
    </.stripped>
    """
  end
end