defmodule VideoChatWeb.CallStatus do
    use GenServer

    # API

    def start_link(state, room) do
        GenServer.start(__MODULE__, state, name: room)
    end

    def add(user) do
        IO.puts "CallStatus add called"
        # sync:
        GenServer.cast(:first_room, {:add, user})
        # async:
        # GenServer.cast(:first_room, {:add, user})
    end

    def get() do
        GenServer.call(:first_room, :get)
    end

    def offer() do
        
    end


    # Callbacks

    def init(state) do
        {:ok, state}
    end

    # always reply
    def handle_call(:get, _from, [user | state]) do
        IO.puts "HANDLE CALL :get INVOKED"
        IO.inspect user
        IO.inspect state
        {:reply, user, state}
    end

    # def handle_call({:add, user}, _from, state) do
    #     IO.puts "HANDLE CALL :add INVOKED"
    #     {:reply, state, state}
    # end

    # no reply, async
    def handle_cast({:add, user}, state) do
        IO.puts "HANDLE CAST INVOKED"
        {:noreply, [user | state]}
    end

end


# When person enters room, add to user_list
# state = [
#     tuomo: %{isHost: true, offer: "ASFas212%"},
#     yuli: %{isHost: false, answer: }
# ]

# 1. User joins channel as first -> GenServer spawned
# 2. 