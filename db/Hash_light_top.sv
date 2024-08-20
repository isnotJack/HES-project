module hash_function(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic [7:0] m [0:3],
    input  logic [7:0] IV [0:3],
    output logic [7:0] d [0:3],
    output logic done
);

    logic [7:0] H [0:3];
    logic [2:0] state, next_state;
    logic [4:0] round;
    logic [7:0] H_intermediate [0:3];
    logic [7:0] H_fpx [0:3];
    logic [7:0] H_out [0:3];


    // Stati della FSM
    /*typedef enum logic [2:0] {
        IDLE,
        CALC_SA,
        CALC_ROUND,
        CALC_FINAL,
        DONE
    } state_t;*/

    parameter [2:0] IDLE = 3'b000;
    parameter [2:0] CALC_SA = 3'b001;
    parameter [2:0] CALC_ROUND = 3'b010;
    parameter [2:0] CALC_FINAL = 3'b011;
    parameter [2:0] DONE = 3'b100;

    //state_t state, next_state;

    // Istanziare i moduli
    round round_inst (.H_in(H_intermediate), .IV(IV), .H_out(H_out), .state(state));
    FPX fpx_inst (.H(H_fpx), .IV(IV), .d(d));
 
    // Multiplexer per selezionare il segnale corretto
     always_comb begin
         case (state)
             CALC_SA: H_intermediate = m;
             CALC_ROUND: H_intermediate = H_out;
             CALC_FINAL: H_fpx = H_out;
             default:    for (int i = 0; i < 4; i++) begin
        	 		H_intermediate[i] = 8'b0;
                         H_fpx[i] = 8'b0;
     			end
                       
          endcase
     end

    // Registro di stato
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            round <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            if (state == CALC_ROUND)
                round <= round + 1;
            if (state == DONE)
                done <= 1;
        end
    end

    // Logica della FSM
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start)
                    next_state = CALC_SA;
            end
            CALC_SA: begin
                next_state = CALC_ROUND;
            end
            CALC_ROUND: begin
                if (round >= 0 && round < 23) begin
                    next_state = CALC_ROUND;
                end else begin
                    next_state = CALC_FINAL;
                end
            end
            CALC_FINAL: begin
                next_state = DONE;
            end
            DONE: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule
