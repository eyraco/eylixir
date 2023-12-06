defmodule Systems.Assignment.CrewWorkView do
  use CoreWeb, :live_component_fabric
  use Fabric.LiveComponent

  import Frameworks.Pixel.Line

  alias Systems.{
    Assignment,
    Crew,
    Workflow,
    Project
  }

  def update(%{work_items: work_items}, socket) do
    {
      :ok,
      socket
      |> assign(work_items: work_items)
      |> update_selected_item_id()
      |> update_selected_item()
      |> compose_child(:work_list_view)
      |> compose_child(:start_view)
      |> update_child(:tool_ref_view)
    }
  end

  defp update_selected_item_id(
         %{assigns: %{work_items: work_items, selected_item_id: selected_item_id}} = socket
       )
       when not is_nil(selected_item_id) do
    if Enum.find(work_items, fn {%{id: id}, _} -> id == selected_item_id end) do
      socket
    else
      socket
      |> assign(selected_item_id: nil)
      |> update_selected_item_id()
    end
  end

  defp update_selected_item_id(%{assigns: %{work_items: []}} = socket) do
    socket |> assign(selected_item_id: nil)
  end

  defp update_selected_item_id(%{assigns: %{work_items: [{%{id: id}, _}]}} = socket) do
    socket |> assign(selected_item_id: id)
  end

  defp update_selected_item_id(%{assigns: %{work_items: work_items}} = socket) do
    {%{id: selected_item_id}, _} =
      Enum.find(work_items, List.first(work_items), fn {_, %{status: status}} ->
        status == :pending
      end)

    socket |> assign(selected_item_id: selected_item_id)
  end

  defp update_selected_item(
         %{assigns: %{selected_item_id: selected_item_id, work_items: work_items}} = socket
       ) do
    selected_item = Enum.find(work_items, fn {%{id: id}, _} -> id == selected_item_id end)

    socket |> assign(selected_item: selected_item)
  end

  @impl true
  def compose(:start_view, %{selected_item: selected_item}) when not is_nil(selected_item) do
    %{module: Assignment.StartView, params: %{work_item: selected_item}}
  end

  @impl true
  def compose(:start_view, _assigns), do: nil

  @impl true
  def compose(:work_list_view, %{
        work_items: [_one, _two | _] = work_items,
        selected_item_id: selected_item_id
      })
      when not is_nil(selected_item_id) do
    work_list = %{
      items: Enum.map(work_items, &map_item/1),
      selected_item_id: selected_item_id
    }

    %{module: Workflow.WorkListView, params: %{work_list: work_list}}
  end

  @impl true
  def compose(:work_list_view, _assigns), do: nil

  @impl true
  def compose(:tool_ref_view, %{selected_item: {%{tool_ref: tool_ref}, task}}) do
    %{module: Project.ToolRefView, params: %{tool_ref: tool_ref, task: task}}
  end

  @impl true
  def compose(:tool_ref_view, _assigns), do: nil

  defp map_item({%{id: id, title: title, group: group}, task}) do
    %{id: id, title: title, icon: group, status: task_status(task)}
  end

  defp task_status(%{status: status}), do: status
  defp task_status(_), do: :pending

  defp lock_task(socket, task) do
    Crew.Public.lock_task(task)
    socket
  end

  @impl true
  def handle_event(
        "complete_task",
        _,
        %{assigns: %{work_items: work_items, selected_item: {%{id: selected_item_id}, _}}} =
          socket
      ) do
    {_, task} = Enum.find(work_items, fn {%{id: id}, _} -> id == selected_item_id end)

    Crew.Public.activate_task(task)

    {:noreply, socket |> hide_child(:tool_ref_view)}
  end

  @impl true
  def handle_event(
        "work_item_selected",
        %{"item" => item_id},
        socket
      ) do
    item_id = String.to_integer(item_id)

    {
      :noreply,
      socket
      |> assign(selected_item_id: item_id)
      |> update_selected_item()
      |> update_child(:start_view)
      |> update_child(:work_list_view)
    }
  end

  @impl true
  def handle_event("start", _, %{assigns: %{selected_item: {_, task}}} = socket) do
    {
      :noreply,
      socket
      |> compose_child(:tool_ref_view)
      |> lock_task(task)
    }
  end

  @impl true
  def handle_event("feldspar_event", event, socket) do
    {
      :noreply,
      socket |> handle_feldspar_event(event)
    }
  end

  defp handle_feldspar_event(%{assigns: %{selected_item: {_, task}}} = socket, %{
         "__type__" => "CommandSystemExit",
         "code" => code,
         "info" => _info
       }) do
    if code == 0 do
      Crew.Public.activate_task(task)
      socket |> hide_child(:tool_ref_view)
    else
      Frameworks.Pixel.Flash.put_info(socket, "Application stopped")
    end
  end

  defp handle_feldspar_event(socket, %{
         "__type__" => "CommandSystemDonate",
         "key" => key,
         "json_string" => json_string
       }) do
    socket
    |> send_event(:parent, "store", %{key: key, data: json_string})
    |> Frameworks.Pixel.Flash.put_info("Donated")
  end

  defp handle_feldspar_event(socket, %{"__type__" => type}) do
    socket |> Frameworks.Pixel.Flash.put_error("Unsupported event " <> type)
  end

  defp handle_feldspar_event(socket, _) do
    socket |> Frameworks.Pixel.Flash.put_error("Unsupported event")
  end

  @impl true
  def render(assigns) do
    ~H"""
      <div class="w-full h-full flex flex-row">
        <%= if exists?(@fabric, :tool_ref_view) do %>
          <.child name={:tool_ref_view} fabric={@fabric} />
        <% else %>
          <%= if exists?(@fabric, :work_list_view) do %>
            <div class="w-left-column flex flex-col py-6 gap-6">
              <div class="px-6">
                <Text.title2 margin=""><%= dgettext("eyra-assignment", "work.list.title") %></Text.title2>
              </div>
              <div>
                <.line />
              </div>
              <div class="flex-grow">
                <div class="px-6 h-full overflow-y-scroll">
                  <.child name={:work_list_view} fabric={@fabric} />
                </div>
              </div>
            </div>
            <div class="border-l border-grey4">
            </div>
          <% end %>
          <div class="h-full w-full">
            <.child name={:start_view} fabric={@fabric} />
          </div>
        <% end %>
      </div>
    """
  end
end
