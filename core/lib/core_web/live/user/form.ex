defmodule CoreWeb.User.Form do
  use CoreWeb, :html

  import Frameworks.Pixel.Form

  attr(:changeset, :map, required: true)

  def password_signup(assigns) do
    ~H"""
      <.form id="signup_form" :let={form} for={@changeset} phx-submit="signup" phx-change="form_change" >
        <.email_input form={form} field={:email} label_text={dgettext("eyra-account", "email.label")} reserve_error_space={false} />
        <.spacing value="S" />
        <.password_input form={form} field={:password} label_text={dgettext("eyra-account", "password.label")} reserve_error_space={false} />
        <.spacing value="S" />
        <Button.submit_wide label={dgettext("eyra-account", "signup.button")} bg_color="bg-grey1" />
      </.form>
    """
  end

  attr(:for, :any, default: %{})

  def password_signin(assigns) do
    ~H"""
    <.form id="signin_form" :let={form} for={@for} action={~p"/user/session"} >
      <.email_input form={form} field={:email} label_text={dgettext("eyra-account", "email.label")} reserve_error_space={false} />
      <.spacing value="S" />
      <.password_input form={form} field={:password} label_text={dgettext("eyra-account", "password.label")} reserve_error_space={false} />
      <.spacing value="S" />
      <Button.submit_wide label={dgettext("eyra-account", "signin.button")} bg_color="bg-grey1" />
      <.spacing value="S" />
      <%!--
      <.checkbox form={form} field={:remember_me} label_text={dgettext("link-survey", "rememberme.label")} />
      <.spacing value="XS" />
      --%>

      <div class="flex flex-row" >
        <.spacing value="M" />
        <Button.dynamic
          action={%{type: :redirect, to: ~p"/user/signup"}}
          face={%{type: :link, text: dgettext("eyra-user", "register.link")}}
        />
        <div class="ml-2"></div>|<div class="ml-2"></div>
        <Button.dynamic
          action={%{type: :redirect, to: ~p"/user/reset-password"}}
          face={%{type: :link, text: dgettext("eyra-user", "reset.link")}}
        />
      </div>
      </.form>
    """
  end

  attr(:conn, :map, required: true)

  def apple_signin(%{conn: conn} = assigns) do
    config = Application.fetch_env!(:core, SignInWithApple)
    button = {:safe, SignInWithApple.Helpers.html_sign_in_button(conn, config)}

    assigns = Map.put(assigns, :button, button)

    ~H"""
    <div class="flex w-full h-12 bg-apple rounded justify-center items-center hover:opacity-80">
        <div class="w-full h-full pl-4 pr-4 focus:outline-none" id="appleid-signin" data-color="black" data-border="false" data-type="sign in" data-logo-size="small" data-label-position="10" ></div>
        <%= @button %>
    </div>
    """
  end

  def google_signin(assigns) do
    ~H"""
      <a href="/google-sign-in">
      <div class="pt-2px pb-2px active:pt-3px active:pb-1px active:shadow-top4px bg-google rounded pl-4 pr-4">
        <div class="flex w-full justify-center items-center">
          <div>
            <img class="mr-3 -mt-1" src={~p"/images/google.svg"} alt="">
          </div>
          <div class="h-11 focus:outline-none">
            <div class="flex flex-col justify-center h-full items-center rounded">
              <div class="text-white text-button font-button">
                <%= dgettext("eyra-account", "login.google.button") %>
              </div>
            </div>
          </div>
        </div>
      </div>
    </a>
    """
  end
end
