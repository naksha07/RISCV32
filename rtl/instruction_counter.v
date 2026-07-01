`timescale 1ns/1ps

module instruction_counter(

    input wire clk,
    input wire rst_n,
    input wire reg_write,

    output reg [31:0] instruction_count

);

always @(posedge clk or negedge rst_n)
begin

    if(!rst_n)
        instruction_count <= 32'd0;

    else if(reg_write)
        instruction_count <= instruction_count + 1;

end

endmodule