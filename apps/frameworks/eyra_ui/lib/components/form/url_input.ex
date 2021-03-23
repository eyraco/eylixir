defmodule EyraUI.Form.UrlInput do
  @moduledoc false
  use Surface.Component
  alias Surface.Components.Form.UrlInput
  alias EyraUI.Form.Field

  prop(field, :atom, required: true)
  prop(label_text, :string)
  prop(label_color, :css_class, default: "text-grey1")
  prop(read_only, :boolean, default: false)

  def render(assigns) do
    ~H"""
    <Field field={{@field}} label_text={{@label_text}} label_color={{@label_color}} read_only={{@read_only}}>
      <UrlInput field={{@field}} opts={{class: "text-grey1 text-bodymedium font-body pl-3 w-full border-2 border-solid border-grey3 focus:outline-none focus:border-primary rounded h-44px"}} />
    </Field>
    """
  end
end
