{naive_time, naive_set} = :timer.tc(fn ->
  for x <- 1..99,
      y <- 1..99,
      z <- 1..99,
      (x < y),
      (x * x) + (y * y) == (z * z),
      do: {x, y, z}
end)

{optim_time, optim_set} = :timer.tc(fn ->
  for x <-       1..98,
      y <- (1 + x)..98,
      z <- (1 + y)..min(x + y - 1, 99),
      (x < y),
      (x * x) + (y * y) == (z * z),
      do: {x, y, z}
end)

IO.puts "Standard time: #{naive_time} µs"
IO.puts "Optimised time: #{optim_time} µs"
IO.puts "Equal? #{naive_set == optim_set}"