defmodule VideoChatWeb.RoomController do
    use VideoChatWeb, :controller
    alias VideoChatWeb.Presence

    @doc """
    Creates the username, unless username is taken or room has already 2 people.
    Responds to POST request that the router directs to this module
    """
    def create(conn, %{"nickname" => nickname}) do

        if VideoChatWeb.Presence.list("call:hello") |> Map.has_key?(nickname) do
            json conn, %{
                error_nickname: "Nickname taken"
            }

        else 
            case VideoChatWeb.Presence.list("call:hello") |> map_size do
                x when x < 2 ->
                    json conn, %{
                        nickname: nickname, 
                        token: Phoenix.Token.sign(conn, "user salt", nickname)
                        }
                x when x >= 2 -> 
                    json conn, %{
                        error_room: "Room is full", 
                        nicknames: VideoChatWeb.Presence.list("call:hello") |> Map.keys
                        }
            end
        end
    end
end