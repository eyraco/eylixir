defmodule Systems.Pool.Builders.ParticipantItem do
  import CoreWeb.Gettext
  alias CoreWeb.Router.Helpers, as: Routes

  def view_model(
        %{
          id: user_id,
          email: email,
          inserted_at: inserted_at,
          profile: %{
            fullname: fullname,
            photo_url: photo_url
          },
          features: features
        },
        socket
      ) do
    subtitle = email

    tag = get_tag(features)
    photo_url = get_photo_url(photo_url, features)
    image = %{type: :avatar, info: photo_url}

    quick_summery =
      inserted_at
      |> CoreWeb.UI.Timestamp.apply_timezone()
      |> CoreWeb.UI.Timestamp.humanize()

    %{
      path: Routes.live_path(socket, Systems.Student.DetailPage, user_id),
      title: fullname,
      subtitle: subtitle,
      quick_summary: quick_summery,
      tag: tag,
      image: image
    }
  end

  def get_tag(%{study_program_codes: [_ | _]}) do
    %{type: :success, text: dgettext("link-citizen", "citizen.tag.complete")}
  end

  def get_tag(_) do
    %{type: :delete, text: dgettext("link-citizen", "citizen.tag.incomplete")}
  end

  def get_photo_url(nil, %{gender: :man}), do: "/images/profile_photo_default_male.svg"
  def get_photo_url(nil, %{gender: :woman}), do: "/images/profile_photo_default_female.svg"
  def get_photo_url(nil, _), do: "/images/profile_photo_default.svg"
  def get_photo_url(photo_url, _), do: photo_url
end
