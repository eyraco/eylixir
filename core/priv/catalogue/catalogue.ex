defmodule Frameworks.Pixel.Catalogue do
  @moduledoc """
  Catalogue implementation.
  """

  use Surface.Catalogue

  load_asset("../../priv/static/js/app.js", as: :app_js)
  load_asset("../../priv/static/css/app.css", as: :app_css)

  @impl true
  def config() do
    [
      head_css: """
      <script type="text/javascript">#{@app_js}</script>
      <style>#{@app_css}</style>
      """,
      playground: [
        body: [
          style: "padding: 1.5rem; height: 100%;",
          class: "has-background-light"
        ]
      ]
    ]
  end
end