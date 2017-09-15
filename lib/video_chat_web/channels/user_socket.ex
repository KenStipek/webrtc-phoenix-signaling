defmodule VideoChatWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", VideoChatWeb.RoomChannel
  channel "call:*", VideoChatWeb.CallChannel
  channel "call", VideoChatWeb.CallChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket,
    timeout: 45_000
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"nickname" => nickname, "token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user salt", token, max_age: 86400) do
      {:ok, nickname} -> 
        IO.puts "ACCEPTED"
        {:ok, assign(socket, :nickname, nickname)}
      {:error, _} ->
        IO.puts "REJECTED"
        :error
    end
  end

  def connect(_, socket) do
    {:error, :no_auth}
  end
  # def connect(%{"nickname" => nickname}, socket) do
  #   IO.puts "UserSocket replied :ok"
  #   {:ok, assign(socket, :nickname, nickname)}
  # end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     VideoChatWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket), do: "user_socket:#{socket.assigns.nickname}"
end
