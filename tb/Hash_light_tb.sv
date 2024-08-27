module hash_function_tb;

    // Parametri di ingresso
    logic clk;
    logic rst_n;
    logic start;
    logic [7:0] m [0:3];
    logic [7:0] IV [0:3];

    // Parametri di uscita
    logic [7:0] d [0:3];
    logic done;

    // Istanziare il DUT (Device Under Test)
    Hash_light_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .m(m),
        .IV(IV),
        .d(d),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Procedura iniziale
    initial begin
        // Inizializzazione
        clk = 0;
        rst_n = 0;
        start = 0;
        m[0] = 8'h00;
        m[1] = 8'h00;
        m[2] = 8'h00;
        m[3] = 8'h00;
        IV[0] = 8'h00;
        IV[1] = 8'h00;
        IV[2] = 8'h00;
        IV[3] = 8'h00;

        // Reset deassertion
        #10;
        rst_n = 1;

        // Test Case 1 --> standard model
        $readmemh("../modelsim/tv/Test_Vector1.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;
        // Avviare l'hashing
        #10;
        start = 1;
        #10;
        start = 0;

        // Aspetta che il processo di hashing finisca
        wait(done) @ (posedge clk);

        // Mostra l'output del digest
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);

        // Test Case 2: Altro set di valori
        #10;
        $readmemh("../modelsim/tv/Test_Vector2.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;

        // Avviare l'hashing
        #10;
        start = 1;
        #10;
        start = 0;

        // Aspetta che il processo di hashing finisca
        wait(done)@ (posedge clk);

        // Mostra l'output del digest
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);

        // Test Case 3: 1st Corner Case
        #10;
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;

        // Avviare l'hashing
        #10;
        start = 1;
        #5;
        $readmemh("../modelsim/tv/Test_Vector1.hex",m);
        #5
        start = 0;
        

        // Aspetta che il processo di hashing finisca
        wait(done)@ (posedge clk);

        // Mostra l'output del digest
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);

        // Fine della simulazione
        #10;
        $stop;
    end

endmodule
