defmodule VideoChatWeb.CallStatus do
    use GenServer

    # API

    def start_link(state, room) do
        GenServer.start(__MODULE__, state, name: room)
    end

    def add(user) do
        IO.puts "CallStatus add called"
        current_state = GenServer.call(:first_room, :get)
        # entrance = {current_state |> length, current_state |> Enum.member?(user)}
        if !Enum.member?(current_state, user) do
             case current_state do
                x when x |> length < 2 -> GenServer.cast(:first_room, {:add, user})
                x when x |> length >= 2 -> :room_full
             end
        end
        
        # case user_check(user) do
        #     :has_user ->
        #         IO.puts "Room has username already"
        #     :ok and  ->
        #         IO.puts "Room not full"
        #         GenServer.cast(:first_room, {:add, user})
        # end

        # if Enum.member?(current_state, user) do
        #     {:error, "Nickname already there"}
        # else
        #     case length(current_state) do
        #         x when x < 2 ->
        #             IO.puts "welcome"
        #             GenServer.cast(:first_room, {:add, user})
        #     end
        # end
    end

    # defp user_check(user) do
    #     if GenServer.call(:first_room, :get) |> Enum.member?(user), do: :has_user, else: :ok
    # end

    def get() do
        GenServer.call(:first_room, :get)
    end

    def offer() do

    end
        
    def remove(user) do
        GenServer.cast(:first_room, {:remove, user})
    end


    # Callbacks

    def init(state) do
        {:ok, state}
    end

    # always reply
    def handle_call(:get, _from, state) do
        {:reply, state, state}
    end

    # def handle_call({:add, user}, _from, state) do
    #     IO.puts "HANDLE CALL :add INVOKED"
    #     {:reply, state, state}
    # end

    # no reply, async
    def handle_cast({:add, user}, state) do
        IO.puts "HANDLE CAST INVOKED"
        IO.inspect state
        {:noreply, [user | state]}
    end

    def handle_cast({:remove, user}, state) do
        {:noreply, List.delete(state, user)}
    end

end


# When person enters room, add to user_list
# state = [
#     tuomo: %{isHost: true, offer: "ASFas212%"},
#     yuli: %{isHost: false, answer: }
# ]

# 1. User joins channel as first -> GenServer spawned
# 2. 


# cast = async, no reply
# call = sync, reply