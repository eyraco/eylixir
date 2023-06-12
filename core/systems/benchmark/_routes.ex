defmodule Systems.Benchmark.Routes do
  defmacro routes() do
    quote do
      scope "/benchmark", Systems.Benchmark do
        pipe_through([:browser, :require_authenticated_user])

        get("/:id", ToolController, :ensure_spot)
        live("/:id/:spot", ToolPage)
      end
    end
  end
end
