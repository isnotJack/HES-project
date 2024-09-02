module hash_function_tb;

    // Input Parameters
    logic clk;
    logic rst_n;
    logic start;
    logic [7:0] m [0:3];
    logic [7:0] IV [0:3];

    //  Output Parameters
    logic [7:0] d [0:3];
    logic done;

    //DUT (Device Under Test)
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

    initial begin
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
        // Test with known values
        $readmemh("../modelsim/tv/Test_Vector1.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;
        // starting hash computation
        #10;
        start = 1;
        #10;
        start = 0;

        // waiting for the end of computation
        wait(done) @ (posedge clk);

        // shows digest output
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);

        // Test Case 2 --> standard model, different input
        //test with kwown value
        #10;
        $readmemh("../modelsim/tv/Test_Vector2.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;

        // starting hash computation
        #10;
        start = 1;
        #10;
        start = 0;

        // waiting for the end of computation
        wait(done) @ (posedge clk);

        // shows digest output
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);


        #10;
    
        // Test Case 3: 1st Corner Case
        // reading of known value but after the rise of start signal
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;

        // starting hash computation
        #10;
        start = 1;
        #5;
        $readmemh("../modelsim/tv/Test_Vector1.hex",m);
        #5
        start = 0;
        

        // waiting for the end of computation
        wait(done) @ (posedge clk);

        // shows digest output
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);


        #10;
        // Test Case 4: 2nd Corner Case
        // Reset activation during a round and then restart
        #10;
        $readmemh("../modelsim/tv/Test_Vector1.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;
        // starting hash computation
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
         // waiting for the end of computation
        wait(done) @ (posedge clk);
        // shows digest output
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);


        #10;
        // Test Case 5: 3rd Corner Case
        // Input larger then 4 bytes
        #10;
        $readmemh("../modelsim/tv/Test_Vector3.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;
        // starting hash computation
        #10;
        start = 1;
        #10;
        start = 0;
        
         // waiting for the end of computation
        wait(done) @ (posedge clk);

        // shows digest output
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);

        #10;
        // Test Case 6: 4th Corner Case
        // Start signal reactivated and left active
        #10;
        $readmemh("../modelsim/tv/Test_Vector1.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;
        // starting hash computation
        #10;
        start = 1;
        #10;
        start = 0;
        #40;
        start = 1 ;
        // waiting for the end of computation
        wait(done)@ (posedge clk);
        #10;
        wait(done)@ (posedge clk);
        start=0;
        // shows digest output
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);
        
        //  Test Case 7a: 5th Corner Case
        // Reset and start activated simoultaneously, disabled on rising edge
        #10;
        $readmemh("../modelsim/tv/Test_Vector1.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;
        // starting hash computation
        #10;
        rst_n = 0;
        start = 1;
        #20;
        rst_n=1;
        start = 0;
        // waiting for the end of computation
        wait(done) @ (posedge clk);

        // shows digest output
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);

        //  Test Case 7b: 5th Corner Case
        // Reset and start activated simoultaneously, disabled on falling edge
        #10;
        $readmemh("../modelsim/tv/Test_Vector1.hex",m);
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;
        // starting hash computation
        #5;
        rst_n = 0;
        start = 1;
        #20;
        rst_n=1;
        start = 0;
        // waiting for the end of computation
        wait(done) @ (posedge clk);

        // shows digest output
        $display("Digest: %h %h %h %h", d[0], d[1], d[2], d[3]);


        // end of simulation
        #10;
        $stop;
    end

endmodule
