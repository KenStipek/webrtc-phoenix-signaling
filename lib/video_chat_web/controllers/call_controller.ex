defmodule VideoChatWeb.CallController do
  use VideoChatWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, params) do
    
  end

end