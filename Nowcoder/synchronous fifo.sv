`timescale 1ns/1ns

module dual_port_RAM #(parameter DEPTH=16, parameter WIDTH=8)(
	input wclk,
	input rclk,
	input wenc,
	input renc,
	input [$clog2(DEPTH)-1:0]waddr,
	input [$clog2(DEPTH)-1:0]raddr,
	input [WIDTH-1:0]wdata,
	output reg [WIDTH-1:0] rdata
);

	reg [WIDTH-1:0] RAM_MEM[0:DEPTH-1];

	always @(posedge wclk) begin
		if(wenc) begin
			RAM_MEM[waddr] <= wdata;
		end
	end

	always @(posedge rclk) begin
		if(renc) begin
			rdata <= RAM_MEM[raddr];
		end
	end
endmodule


module sfifo #(parameter DEPTH=16, parameter WIDTH=8)(
	input clk,
	input rst_n,
	input winc,
	input rinc,
	input [WIDTH-1:0]wdata,
	output reg wfull,
	output reg rempty,
	output wire [WIDTH-1:0] rdata
);

	localparam ADDR_DEPTH=$clog2(DEPTH);
	reg [ADDR_DEPTH:0] waddr;
	reg [ADDR_DEPTH:0] raddr;

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			wfull <= 'b0;
			rempty <= 'b0;
		end
		else begin
			wfull <= (raddr == {~waddr[ADDR_DEPTH],waddr[ADDR_DEPTH-1:0]});
			rempty <= (raddr == waddr);
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			waddr <= 'b0;
		end
		else if(winc && ~wfull) begin
			waddr <= waddr+1'b1;
		end
		else begin
			waddr <= waddr;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			raddr <= 'b0;
		end
		else if(rinc && ~rempty) begin
			raddr <= raddr+1'b1;
		end
		else begin
			raddr <= raddr;
		end
	end

	dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH))dual_port_RAM_U0(
		.wclk(clk),
		.rclk(clk),
		.wenc(winc&&~wfull),
		.renc(rinc&&~rempty),
		.waddr(waddr[ADDR_DEPTH-1:0]),
		.raddr(raddr[ADDR_DEPTH-1:0]),
		.wdata(wdata),
		.rdata(rdata)
	);

endmodule
