defmodule Spawn.Chain do
  def counter(next_pid) do
    receive do
      n -> send next_pid, n + 1
    end
  end

  def create_processes(n) do
    last = Enum.reduce 1..n, self,
            fn (_, send_to) ->
              spawn(__MODULE__, :counter, [send_to])
            end
    send last, 0
    receive do
      final_answer when is_integer(final_answer) ->
        "Result is #{inspect(final_answer)}"
    end
  end

  def main(n) do
    IO.puts inspect :timer.tc(__MODULE__, :create_processes, [n])
  end
end
