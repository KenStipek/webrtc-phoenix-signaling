defmodule VideoChatWeb.CallChannel do
  use Phoenix.Channel

  def join("call", _auth_msg, socket) do
    IO.puts "Somebody joined call channel"
    {:ok, socket}
  end

  def handle_in("message", %{"body" => body}, socket) do
    broadcast! socket, "message", %{body: body}
    {:noreply, socket}
  end
end