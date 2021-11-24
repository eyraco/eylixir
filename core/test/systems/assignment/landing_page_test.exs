defmodule Systems.Assignment.LandingPageTest do
  use CoreWeb.ConnCase
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  alias Systems.{
    Assignment,
    Crew
  }

  describe "show landing page for: campaign -> assignment -> survey_tool" do
    setup [:login_as_member]

    setup do
      survey_tool =
        Factories.insert!(
          :survey_tool,
          %{
            survey_url: "https://eyra.co/fake_survey",
            subject_count: 10,
            duration: "10",
            language: "en",
            devices: [:desktop]
          }
        )

      campaign_auth_node = Factories.insert!(:auth_node)
      assignment_auth_node = Factories.insert!(:auth_node, %{parent: campaign_auth_node})
      promotion_auth_node = Factories.insert!(:auth_node, %{parent: campaign_auth_node})

      assignment =
        Factories.insert!(
          :assignment,
          %{
            auth_node: assignment_auth_node,
            survey_tool: survey_tool,
            director: :campaign
          }
        )

      promotion =
        Factories.insert!(
          :promotion,
          %{
            auth_node: promotion_auth_node,
            director: :campaign,
            title: "This is a test title",
            themes: ["marketing", "econometrics"],
            expectations: "These are the expectations for the participants",
            banner_title: "Banner Title",
            banner_subtitle: "Banner Subtitle",
            banner_photo_url: "https://eyra.co/image/1",
            banner_url: "https://eyra.co/member/1",
            marks: ["vu"]
          }
        )

      _submission = Factories.insert!(:submission, %{reward_value: 5, promotion: promotion})
      author = Factories.build(:author)

      campaign =
        Factories.insert!(:campaign, %{
          auth_node: campaign_auth_node,
          assignment: assignment,
          promotion: promotion,
          authors: [author]
        })

      %{campaign: campaign, assignment: assignment}
    end

    test "Member applied", %{
      conn: %{assigns: %{current_user: user}} = conn,
      campaign: campaign,
      assignment: assignment
    } do
      Core.Authorization.assign_role(user, campaign, :owner)

      _member = Crew.Context.apply_member!(assignment.crew, user)

      {:ok, _view, html} =
        live(conn, Routes.live_path(conn, Assignment.LandingPage, assignment.id))

      assert html =~ "This is a test title"
      assert html =~ "Instructions"
      assert html =~ "These are the expectations for the participants"
      assert html =~ "Reward"
      assert html =~ "Duration"
      assert html =~ "Language"
      assert html =~ "Proceed"
    end

    test "Member starting assignment", %{
      conn: %{assigns: %{current_user: user}} = conn,
      campaign: campaign,
      assignment: assignment
    } do
      Core.Authorization.assign_role(user, campaign, :owner)

      member = Crew.Context.apply_member!(assignment.crew, user)
      task = Crew.Context.get_task(assignment.crew, member)

      {:ok, view, _html} =
        live(conn, Routes.live_path(conn, Assignment.LandingPage, assignment.id))

      assert %Systems.Crew.TaskModel{started_at: started_at} = task
      assert started_at == nil

      html =
        view
        |> element("[phx-click=\"call-to-action\"]")
        |> render_click()

      assert html == {:error, {:redirect, %{to: "https://eyra.co/fake_survey?panl_id=1"}}}

      task = Crew.Context.get_task!(task.id)
      assert %Systems.Crew.TaskModel{started_at: started_at, updated_at: updated_at} = task
      assert started_at == updated_at
    end

    test "Member started assignment", %{
      conn: %{assigns: %{current_user: user}} = conn,
      campaign: campaign,
      assignment: assignment
    } do
      Core.Authorization.assign_role(user, campaign, :owner)

      member = Crew.Context.apply_member!(assignment.crew, user)
      task = Crew.Context.get_task(assignment.crew, member)
      Crew.Context.start_task(task)

      {:ok, _view, html} =
        live(conn, Routes.live_path(conn, Assignment.LandingPage, assignment.id))

      assert html =~ "This is a test title"
      assert html =~ "Instructions"
      assert html =~ "These are the expectations for the participants"
      assert html =~ "Reward"
      assert html =~ "Duration"
      assert html =~ "Language"
      assert html =~ "Proceed"
    end

    test "Member completed assignment", %{
      conn: %{assigns: %{current_user: user}} = conn,
      campaign: campaign,
      assignment: assignment
    } do
      Core.Authorization.assign_role(user, campaign, :owner)

      member = Crew.Context.apply_member!(assignment.crew, user)
      task = Crew.Context.get_task(assignment.crew, member)
      Crew.Context.start_task(task)
      Crew.Context.complete_task(task)

      {:ok, _view, html} =
        live(conn, Routes.live_path(conn, Assignment.LandingPage, assignment.id))

      assert html =~ "This is a test title"
      assert html =~ "You have completed this survey"
      assert html =~ "Your contribution will be reviewed by the author of this study."
      assert html =~ "Reward"
      assert html =~ "Duration"
      assert html =~ "Language"
      assert html =~ "Go to dashboard"
    end
  end
end
