defmodule Systems.Observatory.Switch do
  use Frameworks.Signal.Handler

  alias Systems.{
    Observatory
  }

  def intercept({:page, page}, %{id: id} = message) do
    Observatory.Public.local_dispatch(page, [id], message)
  end
end
