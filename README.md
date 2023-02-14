# Anagrammar

Implementation of the anagram example for Elixir processes from:
https://samuelmullen.com/articles/elixir-processes-send-and-receive

## Usage

```sh
mix compile
iex -S mix
```

```elixir
iex(1)> pid = spawn Accumulator, :loop, []
iex(1)> Anagrammar.build_list pid
iex(1)> Anagrammar.get_list pid
```

To apply code changes, you can also keep `iex` running and call `recompile()`.
