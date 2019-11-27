defmodule DemoWeb.TestLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <div>
        <div id="list" phx-update="append">
          <%= for {v, id} <- @values do %>
            <div id="item-<%= id %>">
              <hr />
              <form id="form-<%= id %>" phx-submit="submit">
                <input type="hidden" name="id" value="<%= id %>" />
                <textarea name="text"><%= v %></textarea>
                <button type="submit">Submit</button>
              </form>
              <p>Block <%= id %>'s value is <%= v %>
            </div>
          <% end %>
        </div>
      </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, %{values: [{"", 0}], current_id: 0}), temporary_assigns: [values: []]}
  end

  def handle_event("submit", %{"text" => text, "id" => id}, socket) do
    id = String.to_integer(id)
    current_id = socket.assigns[:current_id]
    value = {text, id}

    {values, next_id} =
      if text != "" && current_id == id do
        # submitting a block so append a new blank one
        next_id = current_id + 1
        {[value, {"", next_id}], next_id}
      else
        # editing a block
        {[value], current_id}
      end

    socket =
      socket
      |> assign(:values, values)
      |> assign(:current_id, next_id)

    {:noreply, socket}
  end
end
