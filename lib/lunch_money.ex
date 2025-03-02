defmodule LunchMoney do
  @type id :: non_neg_integer()
  @type t :: %__MODULE__{
          config: LunchMoney.Config.t()
        }

  @enforce_keys [:config]
  defstruct [:config]

  alias LunchMoney.Config

  def new(attrs) do
    attrs =
      attrs
      |> Keyword.validate!(config: [])

    %__MODULE__{
      config: Config.new(attrs[:config])
    }
  end
end
