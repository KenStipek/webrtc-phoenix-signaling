defmodule VideoChat.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(VideoChatWeb.Endpoint, []),
      # Start your own worker by calling: VideoChat.Worker.start_link(arg1, arg2, arg3)
      # worker(VideoChat.Worker, [arg1, arg2, arg3]),
      supervisor(VideoChatWeb.Presence, []),
      # Start Call Status worker
      worker(VideoChatWeb.CallStatus, [[], :first_room], [name: CallStatus])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VideoChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    VideoChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
