module max_min(a, b, maximum, minimum);

input unsigned [7:0] a;
input unsigned [7:0] b;
output unsigned [7:0] maximum;
output unsigned [7:0] minimum;

assign minimum = (a<b) ? a:b;
assign maximum = (a>b) ? a:b;

endmodule