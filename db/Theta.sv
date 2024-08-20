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
