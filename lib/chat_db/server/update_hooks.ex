defmodule ChatDb.Server.UpdateHooks do
  @moduledoc """
  GenServer for managing the sqlite `chat.db` connection.
  """

  use GenServer

  alias Sqlitex.Server

  alias ChatDb.Config
  # alias ChatDb.Server.Listener

  @type state() :: %{config: Config.t()}

  @type action() :: :insert | :update | :delete
  @type table() :: iolist()
  @type rowid() :: any()

  @type update() :: {action(), table(), rowid()}

  @db ChatDb.IMessageChatDb
  @actions [:insert, :update, :delete]

  @spec cast_state(Keyword.t()) :: state()
  def cast_state(opts) when is_list(opts) do
    %{config: Keyword.get(opts, :config)}
  end

  @spec start_link(Keyword.t()) :: {:ok, pid()} | {:error, any()} | :ignore
  def start_link(opts \\ []) when is_list(opts) do
    GenServer.start_link(__MODULE__, cast_state(opts), name: __MODULE__)
  end

  @impl true
  @spec init(state()) :: {:ok, state()}
  def init(%{config: %Config{}} = state) do
    {:ok, schedule_hooks(state)}
  end

  @impl true
  def handle_info(:schedule_hooks, state) do
    {:noreply, register_hooks(state)}
  end

  @impl true
  def handle_info({action, table, _rowid} = update, state)
      when action in @actions and is_list(table) do
    {:noreply, dispatch_update(state, update)}
  end

  # @impl true
  # def handle_call(:schedule_hooks, _from, state) do
  #   Process.send_after(self(), :schedule_hooks, state.config.update_hook_wait_ms)
  # end

  @spec schedule_hooks(state()) :: state()
  defp schedule_hooks(%{config: %Config{} = config} = state) do
    Process.send_after(self(), :schedule_hooks, config.update_hook_wait_ms)
    state
  end

  @spec register_hooks(state()) :: state()
  defp register_hooks(state) do
    Server.set_update_hook(@db, self())
    state
  end

  @spec dispatch_update(state(), update()) :: state()
  defp dispatch_update(%{config: %Config{} = config} = state, update) do
    # Listener.handle(update)

    case config.update_hook_mfa do
      {module, fun} when is_atom(module) and is_atom(fun) -> apply(module, fun, [update])
      :noop -> :noop
    end

    state
  end
end
