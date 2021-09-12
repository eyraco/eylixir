defmodule EyraUI.Button.Action.Href do
  @moduledoc """
  Triggers js code after click to show specified div
  """
  use EyraUI.Component

  prop(vm, :map, required: true)

  defviewmodel(href: nil)

  slot(default, required: true)

  def render(assigns) do
    ~H"""
    <a href={{href(@vm)}}>
      <slot />
    </a>
    """
  end
end
