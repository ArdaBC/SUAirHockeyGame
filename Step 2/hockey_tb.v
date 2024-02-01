module hockey_tb();


parameter HP = 5;       // Half period of our clock signal
parameter FP = (2*HP);  // Full period of our clock signal

reg clk, rst, BTN_A, BTN_B;
reg [1:0] DIR_A;
reg [1:0] DIR_B;
reg [2:0] Y_in_A;
reg [2:0] Y_in_B;

wire [2:0] X_COORD, Y_COORD;

// Our design-under-test is the DigiHockey module
hockey dut(clk, rst, BTN_A, BTN_B, DIR_A, DIR_B, Y_in_A, Y_in_B, X_COORD,Y_COORD);

// This always statement automatically cycles between clock high and clock low in HP (Half Period) time. Makes writing test-benches easier.
always #HP clk = ~clk;

initial begin

    $dumpfile("hockey.vcd"); // Our waveform is saved under this file.
    $dumpvars(0,hockey_tb); // * Get the variables from the module.

    $display("Simulation started.");

    clk = 0; 
    rst = 0;
    BTN_A = 0;
    BTN_B = 0;
    DIR_A = 0;
    DIR_B = 0;
    Y_in_A = 0;
    Y_in_B = 0;

    rst=1;
    #(200 * FP);
    rst=0;

    // Here, you are asked to write your test scenario.

    //A starts

    BTN_A=1;
    #(200 * FP);
    BTN_A=0;
    #(200 * FP);

    //A hits
    DIR_A=0;
    Y_in_A=3;
    BTN_A=1;
    #(200 * FP);
    BTN_A=0;

    //Puck moves
    #(600 * FP);

    DIR_B=2;
    Y_in_B=2; //B missses
    BTN_B=1;
    #(200 * FP);
    BTN_B=0;

    //A scores

    #(200 * FP);

    //B starts
    DIR_B=1;
    Y_in_B=1; 
    BTN_B=1;
    #(200 * FP);
    BTN_B=0;

    //Puck moves
    #(800 * FP);

    DIR_A=0;
    Y_in_A=3; //A hits
    BTN_A=1;
    #(200 * FP);
    BTN_A=0;

    //Puck moves
    #(500 * FP);

    DIR_B=2;
    Y_in_B=2; //B hits
    BTN_B=1;
    #(200 * FP);
    BTN_B=0;

    //Puck moves
    #(500 * FP);

    DIR_A=1;
    Y_in_A=0; //A misses
    BTN_A=1;
    #(200 * FP);
    BTN_A=0;

    //B scores

    #(200 * FP);
    
    //A starts

    DIR_A=1;
    Y_in_A=1; 
    BTN_A=1;
    #(200 * FP);
    BTN_A=0;

    //Puck moves
    #(600 * FP);

    DIR_B=0;
    Y_in_B=1; //B misses
    BTN_B=1;
    #(200 * FP);
    BTN_B=0;

    //A scores

    #(200 * FP);

    //B starts

    DIR_B=1;
    Y_in_B=2; 
    BTN_B=1;

    #(200 * FP);
    BTN_B=0;

    //Puck moves
    #(800 * FP);

    DIR_A=2;
    Y_in_A=2; //A hits
    BTN_A=1;

    #(200 * FP);
    BTN_A=0;

    //Puck moves
    #(500 * FP);

    DIR_B=2;
    Y_in_B=2; //B hits
    BTN_B=1;

    #(200 * FP);
    BTN_B=0;
    
    //Puck moves
    #(500 * FP);

    DIR_A=1;
    Y_in_A=0; //A hits
    BTN_A=1;

    #(200 * FP);
    BTN_A=0;

    //Puck moves
    #(500 * FP);

    DIR_B=1;
    Y_in_B=1; //B misses
    BTN_B=1;
    #(200 * FP);
    BTN_B=0;

    //A scores

    #(200 * FP);
    
    #(200 * FP);

    //Game over

    //Try giving inputs despite game ending (it will not work)

    DIR_B=1;
    Y_in_B=2; 
    BTN_B=1;
    #(200 * FP);
    BTN_B=0;

    #(200 * FP);

    $display("Simulation finished.");
    $finish(); 
end



endmodule