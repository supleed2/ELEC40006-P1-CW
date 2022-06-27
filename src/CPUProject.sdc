#This file must have the same name as your project

#Make input CLK a clock and set frequency to 100MHz (10ns period)
create_clock -name {CLK} -period 10.0 [get_ports {CLK}]
