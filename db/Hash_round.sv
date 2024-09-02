module round(
    input  logic [7:0] H_in [0:3],
    input  logic [7:0] IV [0:3],
    input logic [2:0] state,
    output logic [7:0] H_out [0:3]
);
    logic [7:0] H_intermediate_SA [0:3];
    logic [7:0] H_intermediate_XOR [0:3];
    logic [7:0] H_intermediate_Theta [0:3];
    logic [7:0] H_intermediate_rho [0:3];
    logic [7:0] H_intermediate [0:3];

    parameter [2:0] IDLE = 3'b000;
    parameter [2:0] CALC_SA = 3'b001;
    parameter [2:0] CALC_ROUND = 3'b010;
    parameter [2:0] CALC_FINAL = 3'b011;
    parameter [2:0] DONE = 3'b100;
 
    // Module port connection
    SA sa_inst (.m(H_in), .IV(IV), .H(H_intermediate_SA));
    XOR_Module xor_inst (.H_in(H_in), .IV(IV), .H_out(H_intermediate_XOR));
    Theta theta_inst (.H_in(H_intermediate), .H_out(H_intermediate_Theta));
    rho rho_inst (.H_in(H_intermediate_Theta), .H_out(H_intermediate_rho));

always_comb begin
    case (state)
        CALC_SA:    begin
                    H_intermediate = H_intermediate_SA;                       
                    end
        CALC_ROUND: begin 
                    H_intermediate = H_intermediate_XOR;
                    end
        default:    for (int i = 0; i < 4; i++)
            begin
            H_intermediate[i] = 8'b0;
            end
    endcase
end

assign H_out = H_intermediate_rho;

endmodule
