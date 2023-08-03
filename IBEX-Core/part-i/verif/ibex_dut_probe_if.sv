// Interface for special core signals

interface ibex_dut_probe_if(input logic clk);

          logic fetch_enable;
          logic core_sleep;
          logic alert_minor;
          logic alert_major;
          logic debug_req;
          logic ecall;


    modport dut_probe_ports(input core_sleep, alert_minor, ecall, alert_major,
                            output fetch_enable, debug_req);

    initial begin
                  debug_req = 1'b0;
          end

endinterface : ibex_dut_probe_if

