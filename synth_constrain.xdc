## This is the main system clock constraint.
## It defines a 50 MHz clock (20 nanosecond period) on the 'clk' port of the top-level module.

# Create a clock object with a 20.0 ns period.
create_clock -period 20.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports clk]
