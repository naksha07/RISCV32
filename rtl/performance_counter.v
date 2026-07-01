`timescale 1ns/1ps

module performance_counter(

    input wire clk,
    input wire rst_n,

    output reg [31:0] cycle_count

);

always @(posedge clk or negedge rst_n)
begin

    if(!rst_n)
        cycle_count <= 32'd0;

    else
        cycle_count <= cycle_count + 1;

end

endmodule