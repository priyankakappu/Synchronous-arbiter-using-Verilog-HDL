// Verilog code for synchronous arbiter state machine 
// using one hot encoding 

module arbiter(clock, 
reset, 
req0, 
req1, 
req2, 
req3,
gnt0, 
gnt1, 
gnt2, 
gnt3);
//input ports
input clock, reset, req0, req1, req2, req3;
//output ports
output gnt0, gnt1, gnt2, gnt3;
reg gnt0, gnt1, gnt2, gnt3; 
parameter IDLE = 4'b0000, GRANT0 = 4'b0001, GRANT1 = 4'b0010, GRANT2 = 4'b0100, GRANT3 = 4'b1000;
reg [3:0] state;
reg [3:0] next_state;

//Next state logic
always @ (state or req0 or req1 or req2 or req3)
begin
next_state = 4'b0000;
case(state)
	IDLE: if(req3 == 1'b1)begin
			next_state = GRANT3;
		end else if (req2 == 1'b1)begin
			next_state = GRANT2;
		end else if (req1 == 1'b1)begin
			next_state = GRANT1;	
		end else if (req0 == 1'b1)begin
			next_state = GRANT0;	
		end
	
	GRANT0: if(req0 == 1'b1)begin
			next_state = GRANT0;
		end else begin
			next_state = IDLE;
		end
		
	GRANT1: if(req1 == 1'b1)begin
			next_state = GRANT1;
		end else begin
			next_state = IDLE;
		end
		
	GRANT2: if(req2 == 1'b1)begin
			next_state = GRANT2;
		end else begin
			next_state = IDLE;
		end
		
	GRANT3: if(req3 == 1'b1)begin
			next_state = GRANT3;
		end else begin
			next_state = IDLE;
		end
endcase
end 

//sequential logic
always @ (posedge clock)
begin
	if(reset == 1'b0) begin
		state <= #1 IDLE;
	end else begin
		state <= #1 next_state;
	end
end 

//Output logic	
always @ (posedge clock)
begin
	if(reset == 1'b0) begin
		state <= #1 IDLE;
		gnt3 <= #1 1'b0;
		gnt2 <= #1 1'b0;
		gnt1 <= #1 1'b0;
		gnt0 <= #1 1'b0;
	end 
	else begin 
		state <= #1 next_state;
		case(state)
			IDLE: begin
					gnt3 <= #1 1'b0;
					gnt2 <= #1 1'b0;
					gnt1 <= #1 1'b0;
					gnt0 <= #1 1'b0;
				end	
				
			GRANT0: begin
					gnt3 <= #1 1'b0;
					gnt2 <= #1 1'b0;
					gnt1 <= #1 1'b0;
					gnt0 <= #1 1'b1;
				end

			GRANT1: begin
					gnt3 <= #1 1'b0;
					gnt2 <= #1 1'b0;
					gnt1 <= #1 1'b1;
					gnt0 <= #1 1'b0;
				end
				
			GRANT2: begin
					gnt3 <= #1 1'b0;
					gnt2 <= #1 1'b1;
					gnt1 <= #1 1'b0;
					gnt0 <= #1 1'b0;
				end
				
			GRANT3: begin
					gnt3 <= #1 1'b1;
					gnt2 <= #1 1'b0;
					gnt1 <= #1 1'b0;
					gnt0 <= #1 1'b0;
				end
				
			default: begin
					gnt3 <= #1 1'b0;
					gnt2 <= #1 1'b0;
					gnt1 <= #1 1'b0;
					gnt0 <= #1 1'b0;
				end
		endcase
	end
end					
			
endmodule


//Testbench to test the functionality of the arbiter

module test_arbiter;
reg CLOCK, RESET, REQ0, REQ1, REQ2, REQ3;
wire GNT0, GNT1, GNT2, GNT3;

arbiter ARBITER(CLOCK, 
RESET, 
REQ0, 
REQ1, 
REQ2, 
REQ3,
GNT0, 
GNT1, 
GNT2, 
GNT3);

initial 
	begin
		REQ0 = 1'b0;
		REQ1 = 1'b0;
		REQ2 = 1'b0;
		REQ3 = 1'b0; //State idle
				
		#20 REQ0 = 1'b1;
		#20 REQ0 = 1'b0; //State grant 0
		
		#50 REQ1 = 1'b1;
		REQ2 = 1'b1; //State grant 2
		#20 REQ1 = 1'b0;
		#20 REQ2 = 1'b0;
	
		#50 REQ3 = 1'b1; //State grant 3
		REQ2 = 1'b1;
		 
		#40 REQ2 = 1'b0;
		REQ3 = 1'b0; //State idle
	end				
initial  
	begin   
		CLOCK = 1'b1;   
		forever #10 CLOCK = ~ CLOCK; 
	end
initial
	begin
		RESET = 1'b0;
		#15 RESET = 1'b1;
		#250 RESET = 1'b0;
	end

always @ (REQ3 or REQ2 or REQ1 or REQ0 or GNT0 or GNT1 or GNT2 or GNT3) 
	begin
		$display ("time =%0t INPUT VALUES: REQ = %b%b%b%b GRANT = %b%b%b%b RESET = %b", 
					$time, REQ3, REQ2, REQ1, REQ0, GNT3, GNT2, GNT1, GNT0, RESET);
	end
	
endmodule		
	