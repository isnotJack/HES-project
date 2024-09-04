module Hash_light_top(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic [7:0] m [0:3],
    output logic [7:0] d [0:3],
    output logic done
);

    logic [2:0] state, next_state;
    logic [4:0] round;
    logic [7:0] H_intermediate [0:3];
    logic [7:0] H_fpx [0:3];
    logic [7:0] H_out [0:3];
    logic [7:0] IV [0:3] = '{8'h34, 8'h55, 8'h0F, 8'h14};

    parameter [2:0] IDLE = 3'b000;
    parameter [2:0] CALC_SA = 3'b001;
    parameter [2:0] CALC_ROUND = 3'b010;
    parameter [2:0] CALC_FINAL = 3'b011;
    parameter [2:0] DONE = 3'b100;



    // Module port connection
    round round_inst (.H_in(H_intermediate), .IV(IV), .H_out(H_out), .state(state));
    FPX fpx_inst (.H(H_fpx), .IV(IV), .d(d));

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            round <= 0;
        end else begin
            state <= next_state;
            if (state == IDLE && start)
                H_intermediate <= m;
            else if (state == CALC_SA)
            begin
                H_intermediate <= H_out;
                round <= round +1;
            end
            else if (state == CALC_ROUND)
            begin
                round <= round + 1;
                H_intermediate <= H_out;
                if(round==23)
                    H_fpx <= H_out;
            end
            else 
                round<=0;
        end
    end

    // FSM logic
    always_comb begin
        next_state = state;
		done=0;
        case (state)
            IDLE: begin
                if (start)
                    next_state = CALC_SA;
            end
            CALC_SA: begin
                next_state = CALC_ROUND;
            end
            CALC_ROUND: begin
                if (round >= 1 && round < 23) begin
                    next_state = CALC_ROUND;
                end else begin
                    next_state = CALC_FINAL;
                end
            end
            CALC_FINAL: begin
                next_state = DONE;
            end
            DONE: begin
                done = 1;
                next_state = IDLE;
            end
        endcase
    end
endmodule
