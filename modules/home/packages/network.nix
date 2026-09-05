{ pkgs }:

with pkgs;
[
  mtr
  iperf3
  k6
  # Provides redis-cli.
  redis
]
