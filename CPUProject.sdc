#This file must have the same name as your project

#Make input CLK a clock and set frequency to 110MHz (9.1ns period)
create_clock -name {CLK} -period 9.1 [get_ports {CLK}]
