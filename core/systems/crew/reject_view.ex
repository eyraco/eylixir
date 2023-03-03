defmodule Systems.Crew.RejectView do
  use CoreWeb.UI.LiveComponent

  require Logger

  alias Frameworks.Pixel.Button.DynamicButton
  alias Frameworks.Pixel.Selector.Selector
  alias Frameworks.Pixel.Form.{Form, TextInput}
  alias Frameworks.Pixel.Spacing

  alias Systems.{
    Crew
  }

  import CoreWeb.Gettext

  prop(target, :map, required: true)

  data(title, :string)
  data(text, :string)
  data(note, :string)
  data(message_input_label, :string)
  data(categories, :list)
  data(category, :atom)
  data(model, :map)
  data(changeset, :map)

  def update(%{active_item_id: category, selector_id: :category}, socket) do
    {
      :ok,
      socket
      |> assign(category: category)
    }
  end

  def update(%{id: id, target: target}, socket) do
    title = dgettext("link-campaign", "reject.title")
    text = dgettext("link-campaign", "reject.text")
    note = dgettext("link-campaign", "reject.note")
    category = Crew.RejectCategories.values() |> List.first()
    categories = Crew.RejectCategories.labels(category)

    model = %Crew.RejectModel{category: category}
    changeset = Crew.RejectModel.changeset(model, :init, %{})

    {
      :ok,
      socket
      |> assign(
        id: id,
        target: target,
        title: title,
        text: text,
        note: note,
        category: category,
        categories: categories,
        model: model,
        changeset: changeset
      )
    }
  end

  @impl true
  def handle_event(
        "update",
        %{"reject_model" => reject_model},
        %{assigns: %{model: model}} = socket
      ) do
    changeset = Crew.RejectModel.changeset(model, :submit, reject_model)
    {:noreply, socket |> assign(changeset: changeset)}
  end

  @impl true
  def handle_event(
        "reject",
        %{"reject_model" => %{"message" => message}},
        %{assigns: %{model: model, target: target, category: category}} = socket
      ) do
    attrs = %{category: category, message: message}
    changeset = Crew.RejectModel.changeset(model, :submit, attrs)

    case Ecto.Changeset.apply_action(changeset, :update) do
      {:ok, model} ->
        update_target(target, %{reject: :submit, rejection: model})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        Enum.each(changeset.errors, fn {key, {error, _}} ->
          Logger.warn("Reject failed: #{key} -> #{error}")
        end)

        {:noreply, socket |> assign(changeset: changeset)}
    end
  end

  @impl true
  def handle_event("cancel", _params, %{assigns: %{target: target}} = socket) do
    update_target(target, %{reject: :cancel})
    {:noreply, socket}
  end

  defp buttons(target) do
    [
      %{
        action: %{type: :submit},
        face: %{
          type: :primary,
          label: dgettext("link-campaign", "reject.button"),
          bg_color: "bg-delete"
        }
      },
      %{
        action: %{type: :send, event: "cancel", target: target},
        face: %{type: :label, label: dgettext("eyra-ui", "cancel.button")}
      }
    ]
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="p-8 bg-white shadow-2xl rounded">
      <div class="flex flex-col gap-4 gap-8">
        <div class="text-title5 font-title5 sm:text-title3 sm:font-title3">
          {@title}
        </div>
        <div class="text-bodymedium font-body sm:text-bodylarge">
          {@text}
        </div>
        <div class="flex flex-row gap-3 items-center">
          <div class="w-6 h-6 flex-shrink-0 font-caption text-caption text-white rounded-full flex items-center bg-warning">
            <span class="text-center w-full mt-1px">!</span>
          </div>
          <div class="text-button font-button text-warning leading-6">
            {@note}
          </div>
        </div>
        <Form
          id="reject_form"
          changeset={@changeset}
          change_event="update"
          submit="reject"
          target={@myself}
        >
          <Selector
            id={:category}
            items={@categories}
            type={:radio}
            optional?={false}
            parent={%{type: __MODULE__, id: @id}}
          />
          <Spacing value="M" />
          <TextInput
            field={:message}
            label_text={dgettext("link-campaign", "reject.message.label")}
            debounce="0"
          />
          <Spacing value="XXS" />
          <div class="flex flex-row gap-4">
            <DynamicButton :for={button <- buttons(@myself)} vm={button} />
          </div>
        </Form>
      </div>
    </div>
    """
  end
end

defmodule Systems.Crew.RejectView.Example do
  use Surface.Catalogue.Example,
    subject: Systems.Crew.RejectView,
    catalogue: Frameworks.Pixel.Catalogue,
    title: "Reject view",
    height: "640px",
    direction: "vertical",
    container: {:div, class: ""}

  def render(assigns) do
    ~F"""
    <RejectView id={:reject_view_example} target={self()} />
    """
  end

  def update(%{reject: :submit, rejection: rejection}, socket) do
    IO.puts("submit: rejection=#{rejection}")
    {:ok, socket}
  end

  def update(%{reject: :cancel}, socket) do
    IO.puts("cancel")
    {:ok, socket}
  end
end
