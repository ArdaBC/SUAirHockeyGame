module hockey(

    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
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
    
    );
    
    reg [2:0]X_COORD;
    reg [2:0]Y_COORD;
    reg [7:0]timer; //max deger 199 olcak 2^8
    reg [2:0]scoreA;
    reg [2:0]scoreB;
    reg [1:0]lastTurn;
    reg start;
    reg xVisible;
    reg turn;
    reg [1:0]dir;

    //List of states
    parameter IDLE = 4'd0;
    parameter DISPLAY = 4'd1;
    parameter HIT_A = 4'd2;
    parameter HIT_B = 4'd3;
    parameter SEND_A = 4'd4;
    parameter SEND_B = 4'd5;
    parameter RESP_A = 4'd6;
    parameter RESP_B = 4'd7;
    parameter GOAL_A = 4'd8;
    parameter GOAL_B = 4'd9;
    parameter GAMEOVER = 4'd10;

    //List of SSD states
    parameter SSDEmpty = 7'b1111111;
    parameter SSDCharA=7'b0001000;
    parameter SSDCharB=7'b1100000;
    parameter SSDNum0=7'b0000001;
    parameter SSDNum1=7'b1001111;
    parameter SSDNum2=7'b0010010;
    parameter SSDNum3=7'b0000110;
    parameter SSDNum4=7'b1001100;
    parameter SSDDiv=7'b1111110;



        
    reg [4:0] currentstate;
    
    // you may use additional always blocks or drive SSDs and LEDs in one always block
    // for state machine and memory elements 
    always @(posedge clk or posedge rst)
    begin
           if(rst) begin
            LEDA<=0;
            LEDB<=0;
            X_COORD<=3'b000;
            Y_COORD<=3'b000;
            xVisible<=0;
            start<=0;
            timer<=0;
            scoreA<=0;
            scoreB<=0;
            lastTurn<=0;
            currentstate <= IDLE;
            SSD0<=SSDEmpty;
            SSD1<=SSDEmpty;
            SSD2<=SSDEmpty;
            SSD3<=SSDEmpty;
            SSD5<=SSDEmpty;
            SSD6<=SSDEmpty;
            SSD7<=SSDEmpty;
        end
        else if(currentstate != GAMEOVER)begin
        
            case(currentstate)

                IDLE:begin

                    if((BTNA || BTNB))begin
                        SSD0<=SSDEmpty;
                        SSD1<=SSDEmpty;
                        SSD2<=SSDEmpty;
                        SSD3<=SSDEmpty;
                        SSD5<=SSDEmpty;
                        SSD6<=SSDEmpty;
                        SSD7<=SSDEmpty;
                        if(BTNA)begin
                            turn<=0;
                            currentstate <= DISPLAY;
                        end
                        else if(BTNB)begin
                            turn<=1;
                            currentstate <= DISPLAY;
                        end
                    end
                    else begin

                        SSD0<=SSDCharB;
                        SSD1<=SSDDiv;
                        SSD2<=SSDCharA;
                        //currentstate <= IDLE;
                    end
                
                end

                DISPLAY:begin

                    if(timer<99)begin
                        SSD0<=SSDNum0;
                        SSD1<=SSDDiv;
                        SSD2<=SSDNum0;
                        timer<=timer+1;
                    end
                    else begin
                        SSD0<=SSDEmpty;
                        SSD1<=SSDEmpty;
                        SSD2<=SSDEmpty;
                        start<=1;
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
                    xVisible<=0;
                    X_COORD <= 4;
                    Y_COORD <= YB; 
                    LEDB<=1;
                    if(BTNB && YB < 5)begin
                        dir <= DIRB;
                        currentstate <= SEND_A;
                        LEDB<=0;
                    end
                    else begin
                        currentstate <= HIT_B;
                    end
                    
                end

                SEND_A:begin
                    xVisible<=1;
                    if(timer<99)begin
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
                                //YCOORD=YOCCUR
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

                    if(timer<99)begin
                        LEDA<=1;
                        dir<=DIRA;
                        if(BTNA && (Y_COORD == YA))begin
                            X_COORD <= 1;
                            timer <= 0;
                            LEDA<=0;
                            
                                case(dir)
    
                                    2'b10:begin
    
                                        if(Y_COORD == 0)begin
                                            dir <= 2'b01;
                                            Y_COORD <= Y_COORD + 1;  
                                            currentstate <= SEND_B;                                 
                                        end
                                        else begin
                                            dir <= DIRA;
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
                                            dir <= DIRA;
                                            Y_COORD <= Y_COORD + 1;
                                            currentstate <= SEND_B;
                                        end
    
                                    end
    
                                    2'b00:begin
    
                                        dir <= DIRB;
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
                        LEDA<=0;
                        scoreB <= scoreB + 1;
                        currentstate <= GOAL_B;
                    end
                end

                GOAL_B:begin
                    
                    if(timer<99)begin
                        
                        timer<=timer+1;
                        case(scoreA)
                        0:begin
                            SSD2<=SSDNum0;
                        end
                        1:begin
                            SSD2<=SSDNum1;
                        end
                        2:begin
                            SSD2<=SSDNum2;
                        end
                        3:begin
                            SSD2<=SSDNum3;
                        end
                        endcase
                    case(scoreB)
                        0:begin
                            SSD0<=SSDNum0;
                        end
                        1:begin
                            SSD0<=SSDNum1;
                        end
                        2:begin
                            SSD0<=SSDNum2;
                        end
                        3:begin
                            SSD0<=SSDNum3;
                        end
                        endcase
                        SSD1<=SSDDiv;
                        X_COORD<=7;
                        timer<=timer+1;
                        //GOAL B DISPLAY
                    end
                    else begin
                        timer<=0;
                        Y_COORD<=7;
                        if(scoreB == 3)begin
                            turn <= 1;
                            currentstate <= GAMEOVER;
                        end
                        else begin
                            SSD0<=SSDEmpty;
                            SSD1<=SSDEmpty;
                            SSD2<=SSDEmpty;
                            currentstate <= HIT_A;
                        end
                    end
                end

                //MIRROR ENDS HERE

                //START OF THE COPIED CODE

                HIT_A:begin
                    xVisible<=0;
                    X_COORD <= 0;
                    Y_COORD <= YA;
                    LEDA<=1;
                    if(BTNA && YA < 5)begin
                       dir <= DIRA;
                        LEDA<=0;
                        currentstate <= SEND_B;
                    end
                    else begin
                        currentstate <= HIT_A;
                    end
                    
                end

                SEND_B:begin
                    xVisible<=1;
                    if(timer<99)begin
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

                    if(timer<99)begin
                        LEDB<=1;
                        dir<=DIRB;//EDIT LATER T
                        if(BTNB && (Y_COORD == YB))begin
                            X_COORD <= 3;
                            timer <= 0;
                            
                            LEDB<=0;
                            //dir<=DIRA;
                            case(dir)//EDIT LATER

                                2'b10:begin

                                    if(Y_COORD == 0)begin
                                        dir <= 2'b01;
                                        Y_COORD <= Y_COORD + 1;  
                                        currentstate <= SEND_A;                                 
                                    end
                                    else begin
                                        dir <= DIRB;
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
                                        dir <= DIRB;
                                        Y_COORD <= Y_COORD + 1;
                                        currentstate <= SEND_A;
                                    end

                                end

                                2'b00:begin

                                    dir <= DIRA;
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
                        LEDB<=0;
                        scoreA <= scoreA + 1;
                        currentstate <= GOAL_A;
                    end
                end

                GOAL_A:begin

                    if(timer<99)begin
                        //DISPALY A SCORE
                        case(scoreA)
                        0:begin
                            SSD2<=SSDNum0;
                        end
                        1:begin
                            SSD2<=SSDNum1;
                        end
                        2:begin
                            SSD2<=SSDNum2;
                        end
                        3:begin
                            SSD2<=SSDNum3;
                        end
                        endcase
                    case(scoreB)
                        0:begin
                            SSD0<=SSDNum0;
                        end
                        1:begin
                            SSD0<=SSDNum1;
                        end
                        2:begin
                            SSD0<=SSDNum2;
                        end
                        3:begin
                            SSD0<=SSDNum3;
                        end
                        endcase
                        SSD1<=SSDDiv;
                        X_COORD<=7;
                        timer<=timer+1;
                    end
                    else begin
                        timer<=0;
                        if(scoreA == 3)begin
                            turn <= 1;
                            Y_COORD<=6;
                            currentstate <= GAMEOVER;
                        end
                        else begin
                            SSD0<=SSDEmpty;
                            SSD1<=SSDEmpty;
                            SSD2<=SSDEmpty;
                            currentstate <= HIT_B;
                        end
                    end
                end
                
            endcase
        end
        else begin //ELSE IF (currenState==GAMEOVER)
            if(timer<29)begin
                X_COORD<=5;
            end
            else if(timer<59)begin
                X_COORD<=6;
            end
            else begin
                timer<=0;
            end
            timer<=timer+1;
        end
    end
    
    // for SSDs
    always @ (*)
    begin
    case(Y_COORD)
        3'b000:begin
            if(start)begin
                SSD4<=SSDNum0;
            end
            else begin
                SSD4<=SSDEmpty;
            end
        end
        3'b001:begin
            SSD4<=SSDNum1;
        end
        3'b010:begin
            SSD4<=SSDNum2;
        end
        3'b011:begin
            SSD4<=SSDNum3;
        end
        3'b100:begin
            SSD4<=SSDNum4;
        end
        3'b110:begin
            SSD4<=SSDCharA;
        end
        3'b111:begin
            SSD4<=SSDCharB;
        end
        default:begin
            SSD4<=SSDDiv;
        end
      endcase
    
    
    end
    
    //for LEDs
    always @ (*)
    begin
    if(xVisible)begin
      case(X_COORD)
        3'b000:begin
            LEDX[0]<=0;
            LEDX[1]<=0;
            LEDX[2]<=0;
            LEDX[3]<=0;
            LEDX[4]<=1;
        end
        3'b001:begin
            LEDX[0]<=0;
            LEDX[1]<=0;
            LEDX[2]<=0;
            LEDX[3]<=1;
            LEDX[4]<=0;
        end
        3'b010:begin
            LEDX[0]<=0;
            LEDX[1]<=0;
            LEDX[2]<=1;
            LEDX[3]<=0;
            LEDX[4]<=0;
        end
        3'b011:begin
            LEDX[0]<=0;
            LEDX[1]<=1;
            LEDX[2]<=0;
            LEDX[3]<=0;
            LEDX[4]<=0;
        end
        3'b100:begin
            LEDX[0]<=1;
            LEDX[1]<=0;
            LEDX[2]<=0;
            LEDX[3]<=0;
            LEDX[4]<=0;
        end
        3'b101:begin
            LEDX[0]<=1;
            LEDX[1]<=0;
            LEDX[2]<=1;
            LEDX[3]<=0;
            LEDX[4]<=1;
        end  
        3'b110:begin
            LEDX[0]<=0;
            LEDX[1]<=1;
            LEDX[2]<=0;
            LEDX[3]<=1;
            LEDX[4]<=0;
        end    
        3'b111:begin
            LEDX[0]<=1;
            LEDX[1]<=1;
            LEDX[2]<=1;
            LEDX[3]<=1;
            LEDX[4]<=1;
        end  
        endcase
    end
    else begin
        LEDX[0]<=0;
        LEDX[1]<=0;
        LEDX[2]<=0;
        LEDX[3]<=0;
        LEDX[4]<=0;
    end
    
    end
endmodule
