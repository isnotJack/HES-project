module SA(
    input  logic [7:0] m [0:3],
    input  logic [7:0] IV [0:3],
    output logic [7:0] H [0:3]
);
    always_comb begin
        for (int i = 0; i < 4; i++) begin
            H[i] = m[i] ^ IV[i];
        end
    end
endmodule

module XOR_Module(
    input  logic [7:0] H_in [0:3],
    input  logic [7:0] IV [0:3],
    output logic [7:0] H_out [0:3]
);
    always_comb begin
        for (int i = 0; i < 4; i++) begin
            H_out[i] = H_in[i] ^ IV[i];
        end
    end
endmodule

module Theta(
    input  logic [7:0] H_in [0:3],
    output logic [7:0] H_out [0:3]
);
    // Implementazione di permutazione custom
    always_comb begin
        for (int i = 0; i < 4; i++) begin
            H_out[i] = H_in[3-1];
        end
    end
endmodule

module rho(
    input  logic [7:0] H_in [0:3],
    output logic [7:0] H_out [0:3]
);
    always_comb begin
        for (int i = 0; i < 4; i++) begin
            H_out[i] = (H_in[3-i] + 8'h85) % 8'hFD;
        end
    end
endmodule

module FPX(
    input  logic [7:0] H [0:3],
    input  logic [7:0] IV [0:3],
    output logic [7:0] d [0:3]
);
    always_comb begin
        for (int i = 0; i < 4; i++) begin
            d[i] = H[3-i] ^ IV[i];
        end
    end
endmodule

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
    logic [7:0] H_intermediate_SA [0:3];
    logic [7:0] H_intermediate_XOR [0:3];
    logic [7:0] H_intermediate_Theta [0:3];
    logic [7:0] H_intermediate_rho [0:3];
    logic [7:0] H_intermediate [0:3];

    // Stati della FSM
    /*typedef enum logic [2:0] {
        IDLE,
        CALC_SA,
        CALC_ROUND,
        CALC_FINAL,
        DONE
    } state_t;*/

    parameter [2:0] IDLE;
    parameter [2:0] CALC_SA;
    parameter [2:0] CALC_ROUND;
    parameter [2:0] CALC_FINAL;
    parameter [2:0] DONE;

    //state_t state, next_state;

    // Istanziare i moduli
    SA sa_inst (.m(m), .IV(IV), .H(H_intermediate_SA));
    XOR_Module xor_inst (.H_in(H), .IV(IV), .H_out(H_intermediate_XOR));
    Theta theta_inst (.H_in(H_intermediate), .H_out(H_intermediate_Theta));
    rho rho_inst (.H_in(H_intermediate_Theta), .H_out(H_intermediate_rho));
    FPX fpx_inst (.H(H), .IV(IV), .d(d));
 
    // Multiplexer per selezionare il segnale corretto
    always_comb begin
        case (state)
            CALC_SA: H_intermediate = H_intermediate_SA;
            CALC_ROUND: H_intermediate = H_intermediate_XOR;
            default: H_intermediate = H_intermediate_SA; // Default case
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
                if (round >= 0 && round < 24) begin
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
