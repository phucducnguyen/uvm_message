/*
San Jose State University
EE 273 - Logic Verification with UVM
Assignment - Message - Due: Feb 14 2024 at 10pm
Name: Phuc Nguyen
studentID: 016797092
*/
package assignment_message;
	import uvm_pkg::*;
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
	class sender_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(sender_scoreboard)
	uvm_analysis_port #(string) message_to_send; 

	function new(string name="Sender Scoreboard", uvm_component par=null);
		super.new(name,par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		$display("----------Build phase of sender scoreboard----------");
		`uvm_info("sending","Sender",UVM_MEDIUM)
		$display("----------Build message to send----------");
		message_to_send=new("message_to_send",this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		for(int ix=0; ix<20; ix+=1) begin
			message_to_send.write($sformatf("Phuc Nguyen -- message number %d",ix));
			#1;
		end
    	phase.drop_objection(this);
	endtask : run_phase

	endclass : sender_scoreboard
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
	class receive_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(receive_scoreboard)

	uvm_tlm_analysis_fifo #(string) store_message;
	// uvm_analysis_port #(string) display_message;
	string message;

	function new(string name="Receive Scoreboard", uvm_component par=null);
		super.new(name,par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		$display("----------Build phase of receive scoreboard----------");
		`uvm_info("receiving","Receiver",UVM_MEDIUM)
		$display("----------Build store message----------");
		store_message=new("store_message",this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		#5.5;
		forever begin
			store_message.get(message);
			`uvm_info("stored",message,UVM_MEDIUM);
		end
	endtask : run_phase

	endclass : receive_scoreboard
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class my_env extends uvm_env;
	`uvm_component_utils(my_env)
	sender_scoreboard b1;
	receive_scoreboard b2;

	function new(string name="my_env", uvm_component par=null);
		super.new(name,par);
		$display("----------------I'm an environment---------------------");
		$display("---------------Beginning of The environment---------------------");
	endfunction : new
	function void build_phase(uvm_phase phase);
	    b1=sender_scoreboard::type_id::create("SCOREBOARD1",this);
	    b2=receive_scoreboard::type_id::create("SCOREBOARD2",this);
	endfunction : build_phase
	function void connect_phase(uvm_phase phase);
		$display("--------------Connect Phase of Environment------------------\n");
	    b1.message_to_send.connect(b2.store_message.analysis_export);
	endfunction : connect_phase
endclass : my_env
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class test extends uvm_test;
	`uvm_component_utils(test)
	my_env envv;

	function new(string name="test",uvm_component par);
		super.new(name,par);
		$display("--------------------I'm a test-------------------------");
		$display("---------------Beginning of The Test---------------------");
	endfunction : new

	function void build_phase(uvm_phase phase);
	    // b1=sender_scoreboard::type_id::create("SCOREBOARD1",this);
	    // b2=receive_scoreboard::type_id::create("SCOREBOARD2",this);
		envv=my_env::type_id::create("my_env",this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		$display("------------------Test Class = Run_Phase ---------------------\n");
		uvm_top.print_topology();
	endtask : run_phase

endclass : test
endpackage : assignment_message
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
module top;
	import uvm_pkg::*;
	initial begin
    	run_test("test");
	end
endmodule : top