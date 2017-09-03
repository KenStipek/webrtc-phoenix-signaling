defmodule VideoChatWeb.CallChannel do
  use Phoenix.Channel

  def join("call", _auth_msg, socket) do
    IO.puts "Somebody joined call channel"
    {:ok, socket}
  end

  def handle_in("webrtc_message", %{"body" => body}, socket) do
    broadcast! socket, "webrtc_message", %{body: body}
    {:noreply, socket}
  end

  def handle_in("typing_message", %{"body" => body}, socket) do
    broadcast! socket, "typing_message", %{body: body}
    {:noreply, socket}
  end
end