// P56 Instruction-mix counters
// Keep the module name and the port list exactly as they are.
// You may change 'output wire' to 'output reg' if you assign an output in an always block.
// Delete the placeholder assigns and write your design.
module p56_class_stats (
    input  wire clk,
    input  wire rst,
    input  wire sel,
    input  wire we,
    input  wire re,
    input  wire [3:0] ridx,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    input  wire commit,
    input  wire is_load,
    input  wire is_store,
    input  wire is_branch,
    input  wire taken,
    input  wire is_jump
);

    // CHECK these numbers against the register map in docs/
    localparam [3:0] R_CLEAR    = 4'd0;
    localparam [3:0] R_LOADS    = 4'd1;
    localparam [3:0] R_STORES   = 4'd2;
    localparam [3:0] R_BRANCHES = 4'd3;
    localparam [3:0] R_TAKEN    = 4'd4;
    localparam [3:0] R_JUMPS    = 4'd5;
    localparam [3:0] R_PKG      = 4'd15;

    reg [31:0] loads, stores, branches, taken_cnt, jumps;

    wire clr = rst | (sel & we & (ridx == R_CLEAR));

    always @(posedge clk) begin
        if (clr) begin
            loads     <= 32'd0;
            stores    <= 32'd0;
            branches  <= 32'd0;
            taken_cnt <= 32'd0;
            jumps     <= 32'd0;
        end else if (commit) begin
            if (is_load)           loads     <= loads + 1;
            if (is_store)          stores    <= stores + 1;
            if (is_branch)         branches  <= branches + 1;
            if (is_branch & taken) taken_cnt <= taken_cnt + 1;
            if (is_jump)           jumps     <= jumps + 1;
        end
    end

    reg [31:0] rd;
    always @(*) begin
        case (ridx)
            R_LOADS:    rd = loads;
            R_STORES:   rd = stores;
            R_BRANCHES: rd = branches;
            R_TAKEN:    rd = taken_cnt;
            R_JUMPS:    rd = jumps;
            R_PKG:      rd = 32'd56;
            default:    rd = 32'd0;
        endcase
    end
    assign rdata = rd;
endmodule
