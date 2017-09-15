defmodule VideoChatWeb.CallChannel do
  use Phoenix.Channel
  alias VideoChatWeb.Presence
  alias VideoChatWeb.CallStatus

  # def join("call", _auth_msg, socket) do
  #   IO.puts "Somebody joined call channel"
  #   {:ok, socket}
  # end

  def join("call:" <> id, _auth_msg, socket) do
    send(self(), :after_join)
    IO.puts(socket.assigns.nickname <> " joined channel")
    {:ok, assign(socket, :user_id, id)}
  end

  def handle_info(:after_join, socket) do
    IO.puts "handle_info INVOKED"
    CallStatus.add(socket.assigns.nickname)
    {:ok, _} = Presence.track(socket, socket.assigns.nickname, %{
      online_at: inspect(System.system_time(:seconds))
    })
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  # defp state_parser(socket) do
  #   case Presence.list(socket) |> map_size do
  #     x when x == 1 ->
  #       %{""
  #     x when x == 2 -> 
  #       IO.puts "map_size == 2"
  #     _ -> 
  #       :error_empty
  #   end
  # end

  def handle_in("webrtc_message", %{"body" => body}, socket) do
    broadcast! socket, "webrtc_message", %{body: body}
    {:noreply, socket}
  end

  # def handle_in("typing_message", %{"body" => body}, socket) do
  #   broadcast! socket, "typing_message", %{body: body}
  #   {:noreply, socket}
  # end

  def handle_in("typing_message", %{"message" => message}, socket) do
    # def handle_in("typing_message", message, socket) do
    # IO.puts "--------typing_message--------"
    IO.inspect message
    broadcast! socket, "typing_message", %{
      nickname: socket.assigns.user_id,
      message: message
    }
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    IO.puts("user closed connection: " <> socket.assigns.nickname)
  end
end