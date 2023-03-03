defmodule Systems.Assignment.LandingPageTest do
  use CoreWeb.ConnCase, async: false
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  alias Systems.{
    Assignment,
    Crew,
    Budget
  }

  describe "show landing page for: campaign -> assignment -> survey_tool" do
    setup [:login_as_member]

    setup do
      campaign_auth_node = Factories.insert!(:auth_node)
      promotion_auth_node = Factories.insert!(:auth_node, %{parent: campaign_auth_node})
      assignment_auth_node = Factories.insert!(:auth_node, %{parent: campaign_auth_node})
      experiment_auth_node = Factories.insert!(:auth_node, %{parent: assignment_auth_node})

      currency = Budget.Factories.create_currency("test_1234", :legal, "ƒ", 2)
      budget = Budget.Factories.create_budget("test_1234", currency)

      pool =
        Factories.insert!(:pool, %{name: "test_1234", director: :citizen, currency: currency})

      survey_tool =
        Factories.insert!(
          :survey_tool,
          %{
            survey_url: "https://eyra.co/fake_survey",
            director: :campaign
          }
        )

      experiment =
        Factories.insert!(
          :experiment,
          %{
            auth_node: experiment_auth_node,
            survey_tool: survey_tool,
            subject_count: 10,
            duration: "10",
            language: "en",
            devices: [:desktop],
            director: :campaign
          }
        )

      assignment =
        Factories.insert!(
          :assignment,
          %{
            auth_node: assignment_auth_node,
            budget: budget,
            experiment: experiment,
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

      submission = Factories.insert!(:submission, %{reward_value: 500, pool: pool})
      researcher = Factories.build(:researcher)
      author = Factories.build(:author, %{researcher: researcher})

      campaign =
        Factories.insert!(:campaign, %{
          auth_node: campaign_auth_node,
          assignment: assignment,
          promotion: promotion,
          submissions: [submission],
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

      _member = Assignment.Public.apply_member(assignment, user, 500)

      {:ok, _view, html} =
        live(conn, Routes.live_path(conn, Assignment.LandingPage, assignment.id))

      assert html =~ "This is a test title"
      assert html =~ "Instructies"
      assert html =~ "These are the expectations for the participants"
      assert html =~ "Beloning"
      assert html =~ "Duur"
      assert html =~ "Taal"
      assert html =~ "Doorgaan"
    end

    test "Member starting assignment", %{
      conn: %{assigns: %{current_user: user}} = conn,
      campaign: campaign,
      assignment: assignment
    } do
      Core.Authorization.assign_role(user, campaign, :owner)

      {:ok, %{member: member}} = Assignment.Public.apply_member(assignment, user, 500)
      task = Crew.Public.get_task(assignment.crew, member)

      {:ok, view, _html} =
        live(conn, Routes.live_path(conn, Assignment.LandingPage, assignment.id))

      html =
        view
        |> element("[phx-click=\"open\"]")
        |> render_click()

      assert {:error, {:redirect, %{to: "https://eyra.co/fake_survey?panl_id=1"}}} = html

      task = Crew.Public.get_task!(task.id)
      assert %Systems.Crew.TaskModel{started_at: started_at, updated_at: updated_at} = task
      assert started_at == updated_at
    end

    test "Member started assignment", %{
      conn: %{assigns: %{current_user: user}} = conn,
      campaign: campaign,
      assignment: assignment
    } do
      Core.Authorization.assign_role(user, campaign, :owner)

      {:ok, %{member: member}} = Assignment.Public.apply_member(assignment, user, 500)
      task = Crew.Public.get_task(assignment.crew, member)
      Crew.Public.lock_task(task)

      {:ok, _view, html} =
        live(conn, Routes.live_path(conn, Assignment.LandingPage, assignment.id))

      assert html =~ "This is a test title"
      assert html =~ "Instructies"
      assert html =~ "These are the expectations for the participants"
      assert html =~ "Beloning"
      assert html =~ "Duur"
      assert html =~ "Taal"
      assert html =~ "Doorgaan"
    end

    test "Member completed assignment", %{
      conn: %{assigns: %{current_user: user}} = conn,
      campaign: campaign,
      assignment: assignment
    } do
      Core.Authorization.assign_role(user, campaign, :owner)

      {:ok, %{member: member}} = Assignment.Public.apply_member(assignment, user, 500)
      task = Crew.Public.get_task(assignment.crew, member)
      Crew.Public.lock_task(task)
      Crew.Public.activate_task(task)

      {:ok, _view, html} =
        live(conn, Routes.live_path(conn, Assignment.LandingPage, assignment.id))

      assert html =~ "This is a test title"
      assert html =~ "Je hebt bijgedragen aan deze studie"
      assert html =~ "Jouw bijdrage wordt door de auteur van deze studie beoordeeld"
      assert html =~ "Beloning"
      assert html =~ "Duur"
      assert html =~ "Taal"
      assert html =~ "Ga naar console"
    end
  end
end
