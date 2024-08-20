
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
