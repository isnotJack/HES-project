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
        // Prova con valori noti
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
        //Prova con valori noti
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

        #10;
        // Test Case 3: 1st Corner Case
        // Lettura di valori noti di m dopo l'attivazione di start
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

        #10;
        // Test Case 4: 2nd Corner Case
        // Attivazione di reset durante un round
        #10;
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

        #50
        rst_n = 0;
        #10
        rst_n =1;
        
        #10;
        start = 1;
        #10;
        start = 0;
        
        // Aspetta che il processo di hashing finisca
        wait(done)@ (posedge clk);

        // Mostra l'output del digest
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);

        #10;
        // Test Case 5: 3rd Corner Case
        // Input più grande di 4 byte
        #10;
        $readmemh("../modelsim/tv/Test_Vector3.hex",m);
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

        #10;
        // Test Case 6: 4th Corner Case
        // start riattivato per errore
        #10;
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
        #40;
        start = 1 ;
        // Aspetta che il processo di hashing finisca
        wait(done)@ (posedge clk);
        #10;
        wait(done)@ (posedge clk);
        start=0;
        // Mostra l'output del digest
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);
        
        //  Test Case 7a: 5th Corner Case
        // reset e start attivati contemporaneamente, disabilitati sul rising edge
        #10;
        $readmemh("../modelsim/tv/Test_Vector1.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;
        // Avviare l'hashing
        #10;
        rst_n = 0;
        start = 1;
        #20;
        rst_n=1;
        start = 0;
        // Aspetta che il processo di hashing finisca
        wait(done)@ (posedge clk);
        // Mostra l'output del digest
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);
        //  Test Case 7b: 5th Corner Case
        // reset e start attivati contemporaneamente,disabilitati sul falling edge
        #10;
        $readmemh("../modelsim/tv/Test_Vector1.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;
        // Avviare l'hashing
        #5;
        rst_n = 0;
        start = 1;
        #20;
        rst_n=1;
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
