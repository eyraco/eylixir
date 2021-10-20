defmodule CoreWeb.ViewModel.Card do
  import CoreWeb.Gettext

  alias Systems.Campaign

  alias Core.ImageHelpers
  alias CoreWeb.Router.Helpers, as: Routes

  def primary_campaign(
        %{
          id: id,
          data_donation_tool: %{
            id: edit_id,
            script: _script,
            reward_currency: reward_currency,
            reward_value: reward_value,
            promotion: %{
              id: open_id,
              title: title,
              image_id: image_id,
              themes: themes,
              marks: marks
            }
          }
        } = campaign,
        socket
      ) do
    reward_value = if reward_value === nil, do: 0, else: reward_value
    reward_currency = if reward_currency === nil, do: :eur, else: reward_currency

    open_spot_count = Campaign.Context.count_open_spots(campaign)

    reward_string = CurrencyFormatter.format(reward_value, reward_currency, keep_decimals: true)

    reward_label = dgettext("eyra-promotion", "reward.title")
    open_spots_label = dgettext("eyra-promotion", "open.spots.label", count: "#{open_spot_count}")
    deadline_label = dgettext("eyra-promotion", "deadline.label", days: "3")

    info = [
      "#{reward_label}: #{reward_string}",
      "#{open_spots_label}",
      "#{deadline_label}"
    ]

    label = nil

    icon_url = get_icon_url(marks, socket)
    image_info = ImageHelpers.get_image_info(image_id)
    tags = get_tags(themes)

    %{
      id: id,
      edit_id: edit_id,
      open_id: open_id,
      title: title,
      image_info: image_info,
      tags: tags,
      duration: nil,
      info: info,
      icon_url: icon_url,
      label: label
    }
  end

  def get_tags(nil), do: []

  def get_tags(themes) do
    themes
    |> Enum.map(&Core.Enums.Themes.translate(&1))
  end

  def get_icon_url(marks, socket) do
    case marks do
      [mark] -> Routes.static_path(socket, "/images/#{mark}.svg")
      _ -> nil
    end
  end
end
