`timescale 1ns/1ns

module dual_port_RAM #(parameter DEPTH=16, parameter WIDTH=8)(
	input wclk,
	input wenc,
	input [$clog2(DEPTH)-1:0]waddr,
	input [WIDTH-1:0]wdata,
	input rclk,
	input renc,
	input [$clog2(DEPTH)-1:0]raddr,
	output reg [WIDTH-1:0]rdata
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


module asyn_fifo #(parameter DEPTH=16, parameter WIDTH=8)(
	input wclk,
	input wrstn,
	input winc,
	output wire wfull,
	input [WIDTH-1:0] wdata,
	input rclk,
	input rrstn,
	input rinc,
	output wire rempty,
	output wire [WIDTH-1:0] rdata	
);

	localparam ADDR_WIDTH = $clog2(DEPTH);
	reg [ADDR_WIDTH:0] waddr;
	reg [ADDR_WIDTH:0] raddr;

	always @(posedge wclk or negedge wrstn) begin
		if(~wrstn) begin
			waddr <= 'b0;
		end
		else if(winc && ~wfull) begin
			waddr <= waddr+1'b1;
		end
		else begin
			waddr <= waddr;
		end		
	end

	always @(posedge rclk or negedge rrstn) begin
		if(~rrstn) begin
			raddr <= 'b0;
		end
		else if(rinc && ~rempty) begin
			raddr <= raddr+1'b1;
		end
		else begin
			raddr <= raddr;
		end		
	end

	wire [ADDR_WIDTH:0] waddr_gray;
	wire [ADDR_WIDTH:0] raddr_gray;
	assign waddr_gray = waddr ^(waddr>>1);
	assign raddr_gray = raddr ^(raddr>>1);

	reg [ADDR_WIDTH:0] reg_waddr;
	reg [ADDR_WIDTH:0] reg_raddr;

	always @(posedge wclk or negedge wrstn) begin
		if(!wrstn) begin
			reg_waddr <= 'd0;
		end
		else begin
			reg_waddr <= waddr_gray;
		end
	end

	always @(posedge rclk or negedge rrstn) begin
		if(!rrstn) begin
			reg_raddr <= 'd0;
		end
		else begin
			reg_raddr <= raddr_gray;
		end
	end

	reg [ADDR_WIDTH:0] gray_w2r_temp;
	reg [ADDR_WIDTH:0] gray_w2r;
	reg [ADDR_WIDTH:0] gray_r2w_temp;
	reg [ADDR_WIDTH:0] gray_r2w;

	always @(posedge wclk or negedge wrstn) begin
		if(!wrstn) begin
			gray_r2w_temp <= 'b0;
			gray_r2w <= 'b0;
		end
		else begin
			gray_r2w_temp <= reg_raddr;
			gray_r2w <= gray_r2w_temp;
		end
	end

	always @(posedge rclk or negedge rrstn) begin
		if(!rrstn) begin
			gray_w2r_temp <= 'd0;
			gray_w2r <= 'd0;
		end
		else begin
			gray_w2r_temp <= reg_waddr;
			gray_w2r <= gray_w2r_temp;
		end
	end

	assign wfull =(reg_waddr=={~gray_r2w[ADDR_WIDTH:ADDR_WIDTH-1],gray_r2w[ADDR_WIDTH-2:0]});
	assign rempty = (reg_raddr==gray_w2r);

	dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH))dual_port_RAM_U0(
		.wclk(wclk),
		.wenc(winc && ~wfull),
		.waddr(waddr[ADDR_WIDTH-1:0]),
		.wdata(wdata),
		.rclk(rclk),
		.renc(rinc && ~rempty),
		.raddr(raddr[ADDR_WIDTH-1:0]),
		.rdata(rdata)		
	);

endmodule
