defmodule VideoChatWeb.CallController do
  use VideoChatWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def offer(conn, _params) do
    render conn, "offer.html"
  end

  def answer(conn, _params) do
    render conn, "answer.html"
  end
end