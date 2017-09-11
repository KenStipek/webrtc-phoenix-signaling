defmodule VideoChatWeb.CallChannel do
  use Phoenix.Channel
  alias VideoChatWeb.Presence
  alias VideoChatWeb.CallStatus

  def join("call", _auth_msg, socket) do
    IO.puts "Somebody joined call channel"
    {:ok, socket}
  end

  def join("call:" <> id, _auth_msg, socket) do
    send(self(), :after_join)
    IO.puts(socket.assigns.nickname <> " joined channel")
    {:ok, assign(socket, :user_id, id)}
  end

  def handle_info(:after_join, socket) do
    IO.puts "handle_info INVOKED"
    # push socket, "presence_state", Presence.list("topic:hello")
    CallStatus.add(socket.assigns.nickname)
    # push socket, "occupants", %{users: CallStatus.get()}
    {:ok, _} = Presence.track(socket, socket.assigns.nickname, %{
      online_at: inspect(System.system_time(:seconds))
    })
    {:noreply, socket}
  end

  def handle_in("webrtc_message", %{"body" => body}, socket) do
    broadcast! socket, "webrtc_message", %{body: body}
    {:noreply, socket}
  end

  def handle_in("typing_message", %{"body" => body}, socket) do
    broadcast! socket, "typing_message", %{body: body}
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    IO.puts("user closed connection: " <> socket.assigns.nickname)
  end
end