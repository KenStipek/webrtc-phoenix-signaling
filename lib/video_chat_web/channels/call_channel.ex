defmodule VideoChatWeb.CallChannel do
  use Phoenix.Channel
  alias VideoChatWeb.Presence
  alias VideoChatWeb.CallStatus
  alias Integer

  @moduledoc """
  This is the main channel module for setting up a bidirectional WebRTC connection.
  """

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
    broadcast socket, "presence_state", %{:users => Presence.list(socket) |> Map.keys}
    case VideoChatWeb.Presence.list("call:hello") |> Map.keys |> length do
      x when x == 2 ->
        push socket, "SEND_OFFER", %{type: "SEND_OFFER"}
      x when x < 2 ->
        IO.puts "I'm the first user here"
    end
    {:noreply, socket}
  end

  def handle_in("webrtc_message", %{"body" => body}, socket) do
    IO.puts "-------------WebRTC message received from: " <> socket.assigns.nickname
    IO.inspect Poison.Parser.parse!(body)
    broadcast_from socket, "webrtc_message", %{"body" => body, "sender" => socket.assigns.nickname}
    {:noreply, socket}

    # IO.puts "-----let's see socket.assigns-------"
    # IO.inspect socket.assigns
    # IO.puts "--------Poison parse---------"
    # IO.inspect Poison.Parser.parse!(body)

    # case Poison.Parser.parse!(body) do
    #   %{"candidate" => _} ->
    #     if socket.assigns["candidate1"] do
    #       candidate_adder(socket, body, 2)
    #     else 
    #       {:noreply, assign(socket, "candidate1", body)}
    #     end
    #   %{"sdp" => %{"sdp" => _, "type" => "offer"}} -> {:noreply, assign(socket, :sdp_offer, body)}
    #   _ -> IO.puts "something else from case"
    # end
  end

  # defp candidate_adder(socket, body, i) do
  #   if Map.has_key?(socket.assigns, "candidate" <> to_string(i)) do
  #     candidate_adder(socket, body, i + 1)
  #   else 
  #     {:noreply, assign(socket, "candidate" <> to_string(i), body)}
  #   end
  # end


  @doc """
  Handles the incoming type_message messages.
  """
  def handle_in("typing_message", %{"message" => message}, socket) do
    # def handle_in("typing_message", message, socket) do
    # IO.puts "--------typing_message--------"
    IO.inspect message
    broadcast! socket, "typing_message", %{
      nickname: socket.assigns.nickname,
      message: message
    }
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    IO.puts("user closed connection: " <> socket.assigns.nickname)
  end
end