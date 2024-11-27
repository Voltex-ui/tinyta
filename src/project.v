module traffic_light (
    input clk,             // Clock signal
    input reset,           // Reset signal
    output reg [2:0] lights // Output for traffic lights: [Red, Yellow, Green]
);
    reg [1:0] state;        // 2-bit register to store the current state

    // State transition logic: triggered on clock edge or reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Reset to Green state
        end else begin
            case (state)
                2'b00: state <= 2'b01; // Green to Yellow
                2'b01: state <= 2'b10; // Yellow to Red
                2'b10: state <= 2'b00; // Red to Green
                default: state <= 2'b00; // Default to Green
            endcase
        end
    end

    // Output logic: assign lights based on the current state
    always @(state) begin
        case (state)
            2'b00: lights = 3'b001; // Green ON
            2'b01: lights = 3'b010; // Yellow ON
            2'b10: lights = 3'b100; // Red ON
            default: lights = 3'b000; // All lights OFF
        endcase
    end

endmodule


`timescale 1ns/1ps  // Set time unit and precision

module traffic_light_tb;
    reg clk;               // Clock signal
    reg reset;             // Reset signal
    wire [2:0] lights;     // Output for traffic lights from the DUT (Device Under Test)

    // Instantiate the traffic_light module
    traffic_light uut (
        .clk(clk),
        .reset(reset),
        .lights(lights)
    );

  

    // Testbench procedure
    initial begin
          clk=0;
        // Initialize reset signal and assert reset
        reset = 1;           // Assert reset initially to initialize the FSM
        #10 reset = 0;       // Deassert reset after 10ns to allow FSM to start transitioning

        // Let the FSM run and observe the transitions
        #200;                // Simulate for 200ns to observe multiple FSM transitions

        // End simulation after enough transitions
        $finish;
    end
