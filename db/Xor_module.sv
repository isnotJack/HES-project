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