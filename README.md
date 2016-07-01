# Synchronous-arbiter-using-Verilog-HDL
Designed a synchronous arbiter state machine with four requests.
Developed the Verilog behavioral model for the arbiter using one-hot state encoding.
Created a Verilog testbench to test its functionality. 

The arbiter is sensitive to the rising edge of the clock.
It has one active LOW reset input.
It has 4 active HIGH data inputs, namely req3, req2, req1 and req0. Each of these inputs represents a request to the arbiter from a different hardware unit, for permission to access a common bus within a larger system. 
It has 4 active HIGH outputs, namely grant3, grant2, grant1, and grant0, each representing the status for the request arriving on lines req3, req2, req1 and req0, respectively. If only req3 = 1, then only grant3 = 1 and all the other outputs will be 0. If only req2 = 1, then only grant2 = 1 and all the other outputs will be 0.  
Only one of the 4 outputs can be HIGH at any given time 
If multiple data inputs are asserted, then priority is given to the highest numbered req input among the asserted inputs. For example, if req3 = 0, req2 = 1, req 1= 1, req0 = 0, then only grant2 will be HIGH.
The arbiter has an initial state where all outputs are LOW. 
