defmodule VideoChatWeb.RoomController do
    use VideoChatWeb, :controller
    alias VideoChatWeb.Presence

    def create(conn, %{"nickname" => nickname}) do

        json conn, %{
            nickname: nickname, 
            token: Phoenix.Token.sign(conn, "user salt", nickname)
        }
    end
end