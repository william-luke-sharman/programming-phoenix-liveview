defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess:", time: time(), answer: answer())}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
        It's <%= @time %>
        <br>
        <%= @message %>
    </h2>
    <br/>
    <h2>
        <%= for n <- 1..10 do %>
            <.link class="bg-blue-500 hover:bg-blue-700
            text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
            phx-click="guess" phx-value-number= {n} >
                <%= n %>
            </.link>
        <% end %>
    </h2>
    <br>
    <h2>
        <.link class="bg-blue-500 hover:bg-blue-700
        text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
        phx-click="restart" >
            Restart
        </.link>
    </h2>
    """
  end

  def handle_event("restart", socket) do
    {
      :noreply,
      push_patch(
        socket,
        score: 0,
        message: "Coward!",
        answer: answer()
      )
    }
  end

  def handle_event("guess", %{"number" => guess}, socket) when socket.assigns.answer == guess do
    {
      :noreply,
      assign(
        socket,
        score: socket.assigns.score + 1,
        message: "You got it, way to go!",
        time: time()
      )
    }
  end

  def handle_event("guess", %{"number" => guess}, socket) when socket.assigns.answer != guess do
    {
      :noreply,
      assign(
        socket,
        score: socket.assigns.score - 1,
        message: "Your guess: #{guess}. Wrong. Guess again.",
        time: time()
      )
    }
  end

  def time(), do: DateTime.utc_now |> to_string

  def answer(), do: :rand.uniform(10) |> to_string
end
