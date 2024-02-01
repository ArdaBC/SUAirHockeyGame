module hockey(

    input clk,
    input rst,
    
    input BTN_A,
    input BTN_B,
    
    input [1:0] DIR_A,
    input [1:0] DIR_B,
    
    input [2:0] Y_in_A,
    input [2:0] Y_in_B,
   
    /*
    output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,
    
    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4, 
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0   
    */
	
	output reg [2:0] X_COORD,
	output reg [2:0] Y_COORD
	
    );

    reg [7:0]timer; //max deger 199 olcak 2^8
    reg [2:0]scoreA;
    reg [2:0]scoreB;
    reg [1:0]lastTurn;
    reg turn;
    reg [1:0]dir;

    //List of states
    localparam IDLE = 4'd0;
    localparam DISPLAY = 4'd1;
    localparam HIT_A = 4'd2;
    localparam HIT_B = 4'd3;
    localparam SEND_A = 4'd4;
    localparam SEND_B = 4'd5;
    localparam RESP_A = 4'd6;
    localparam RESP_B = 4'd7;
    localparam GOAL_A = 4'd8;
    localparam GOAL_B = 4'd9;
    localparam GAMEOVER = 4'd10;

    reg [4:0] currentstate;
    
    always @(posedge clk or posedge rst)
    begin
        if(rst) begin
            X_COORD<=3'b000;
            Y_COORD<=3'b000;
            timer<=0;
            scoreA<=0;
            scoreB<=0;
            lastTurn<=0;
            currentstate <= IDLE;
        end
        else if(currentstate != GAMEOVER)begin
        
            case(currentstate)

                IDLE:begin

                    if((BTN_A || BTN_B))begin

                        if(BTN_A)begin
                            turn<=0;
                            currentstate <= DISPLAY;
                        end
                        else if(BTN_B)begin
                            turn<=1;
                            currentstate <= DISPLAY;
                        end
        
                    end
                
                end

                DISPLAY:begin

                    if(timer<199)begin
                        timer<=timer+1;
                    end
                    else begin
                        timer<=0;
                        if(turn == 1)begin
                            currentstate <= HIT_B;
                        end
                        else begin
                            currentstate <= HIT_A;
                        end
                    end
        
                end

                //MIRROR STARTS HERE

                HIT_B:begin

                    if(BTN_B && Y_in_B < 5)begin
                        X_COORD <= 4;
                        Y_COORD <= Y_in_B;
                        dir <= DIR_B;
                        currentstate <= SEND_A;
                    end
                    else begin
                        currentstate <= HIT_B;
                    end
                    
                end

                SEND_A:begin

                    if(timer<199)begin
                        timer<=timer+1;
                    end
                    else begin
                        timer<=0;

                        case(dir)

                            2'b10:begin

                                if(Y_COORD == 0)begin
                                    dir <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;                                   
                                end
                                else begin
                                    Y_COORD <= Y_COORD - 1;
                                end
                            
                            end

                            2'b01:begin

                                if(Y_COORD == 4)begin
                                    dir <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;                                   
                                end
                                else begin
                                    Y_COORD <= Y_COORD + 1;
                                end

                            end

                            2'b00:begin
                            
                            end

                        endcase

                        if(X_COORD > 1)begin
                            X_COORD <= X_COORD - 1;
                            currentstate <= SEND_A;
                        end
                        else begin
                            X_COORD <= 0;
                            currentstate <= RESP_A;
                        end

                    end
                    
                end

                RESP_A:begin

                    if(timer<199)begin

                        if(BTN_A && (Y_COORD == Y_in_A))begin
                            X_COORD <= 1;
                            timer <= 0;

                            case(dir)

                                2'b10:begin

                                    if(Y_COORD == 0)begin
                                        dir <= 2'b01;
                                        Y_COORD <= Y_COORD + 1;  
                                        currentstate <= SEND_B;                                 
                                    end
                                    else begin
                                        dir <= DIR_A;
                                        Y_COORD <= Y_COORD - 1;
                                        currentstate <= SEND_B;
                                    end
                                
                                end

                                2'b01:begin

                                    if(Y_COORD == 4)begin
                                        dir <= 2'b10;
                                        Y_COORD <= Y_COORD - 1;  
                                        currentstate <= SEND_B;                                 
                                    end
                                    else begin
                                        dir <= DIR_A;
                                        Y_COORD <= Y_COORD + 1;
                                        currentstate <= SEND_B;
                                    end

                                end

                                2'b00:begin

                                    dir <= DIR_B;
                                    currentstate <= SEND_B;
                                
                                end

                            endcase

                        end
                        else begin
                            timer <= timer + 1;
                        end
                    end
                    else begin
                        timer<=0;
                        scoreB <= scoreB + 1;
                        currentstate <= GOAL_B;
                    end
                end

                GOAL_B:begin

                    if(timer<199)begin
                        timer<=timer+1;
                    end
                    else begin
                        timer<=0;
                        if(scoreB == 3)begin
                            turn <= 1;
                            currentstate <= GAMEOVER;
                        end
                        else begin
                            currentstate <= HIT_A;
                        end
                    end
                end

                //MIRROR ENDS HERE

                //START OF THE COPIED CODE

                HIT_A:begin

                    if(BTN_A && Y_in_A < 5)begin
                        X_COORD <= 0;
                        Y_COORD <= Y_in_A;
                        dir <= DIR_A;
                        currentstate <= SEND_B;
                    end
                    else begin
                        currentstate <= HIT_A;
                    end
                    
                end

                SEND_B:begin

                    if(timer<199)begin
                        timer<=timer+1;
                    end
                    else begin
                        timer<=0;

                        case(dir)

                            2'b10:begin

                                if(Y_COORD == 0)begin
                                    dir <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;                                   
                                end
                                else begin
                                    Y_COORD <= Y_COORD - 1;
                                end
                            
                            end

                            2'b01:begin

                                if(Y_COORD == 4)begin
                                    dir <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;                                   
                                end
                                else begin
                                    Y_COORD <= Y_COORD + 1;
                                end

                            end

                            2'b00:begin
                            
                            end

                        endcase

                        if(X_COORD < 3)begin
                            X_COORD <= X_COORD + 1;
                            currentstate <= SEND_B;
                        end
                        else begin
                            X_COORD <= 4;
                            currentstate <= RESP_B;
                        end

                    end
                    
                end

                RESP_B:begin

                    if(timer<199)begin

                        if(BTN_B && (Y_COORD == Y_in_B))begin
                            X_COORD <= 3;
                            timer <= 0;

                            case(dir)

                                2'b10:begin

                                    if(Y_COORD == 0)begin
                                        dir <= 2'b01;
                                        Y_COORD <= Y_COORD + 1;  
                                        currentstate <= SEND_A;                                 
                                    end
                                    else begin
                                        dir <= DIR_B;
                                        Y_COORD <= Y_COORD - 1;
                                        currentstate <= SEND_A;
                                    end
                                
                                end

                                2'b01:begin

                                    if(Y_COORD == 4)begin
                                        dir <= 2'b10;
                                        Y_COORD <= Y_COORD - 1;  
                                        currentstate <= SEND_A;                                 
                                    end
                                    else begin
                                        dir <= DIR_B;
                                        Y_COORD <= Y_COORD + 1;
                                        currentstate <= SEND_A;
                                    end

                                end

                                2'b00:begin

                                    dir <= DIR_A;
                                    currentstate <= SEND_A;
                                
                                end

                            endcase

                        end
                        else begin
                            timer <= timer + 1;
                        end
                    end
                    else begin
                        timer<=0;
                        scoreA <= scoreA + 1;
                        currentstate <= GOAL_A;
                    end
                end

                GOAL_A:begin

                    if(timer<199)begin
                        timer<=timer+1;
                    end
                    else begin
                        timer<=0;
                        if(scoreA == 3)begin
                            turn <= 1;
                            currentstate <= GAMEOVER;
                        end
                        else begin
                            currentstate <= HIT_B;
                        end
                    end
                end

                //END OF THE COPIED CODE
                
            endcase
  
        end
    end

endmodule