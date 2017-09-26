defmodule VideoChatWeb.RoomControllerTest do
    use VideoChatWeb.ConnCase
  
    # test "GET /", %{conn: conn} do
    #   conn = get conn, "/"
    #   assert html_response(conn, 200) =~ "Welcome to Phoenix!"
    # end
    describe "create/2" do
      test "create/2 responds with created user and token" do

        response = build_conn()
        |> post(room_path(build_conn(), :create, %{"nickname" => "testname"}))
        |> json_response(200)

        %{"nickname" => "testname", "token" => token} = response
        assert response == %{"nickname" => "testname", "token" => token}

      end
    end
  end
  