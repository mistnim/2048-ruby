#!/usr/bin/env ruby

# (1..16).map{ |i| [2**i, i**3.5] }
#   .map{ |i| "sum_power_weight(#{i[0]},#{i[1].to_i})." }
#   .each{ |i| puts i }


(1..16).map{ |i| [2**i, i**4] }
  .map{ |i| "mono_power_weight(#{i[0]},#{i[1].to_i})." }
  .each{ |i| puts i }
