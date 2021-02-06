defmodule EyraUI.Form.TextArea do
  @moduledoc false
  use Surface.Component
  alias Surface.Components.Form.TextArea
  alias EyraUI.Form.Field

  prop field, :atom, required: true
  prop label_text, :string

  def render(assigns) do
    ~H"""
    <Field field={{@field}} label_text={{@label_text}}>
      <TextArea field={{@field}} opts={{class: "text-grey1 text-bodymedium font-body pl-3 pt-2 w-full h-64 border-2 border-solid border-grey3 focus:outline-none focus:border-primary rounded"}} />
    </Field>
    """
  end
end
