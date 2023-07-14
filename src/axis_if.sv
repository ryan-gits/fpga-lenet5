interface axis_if #(parameter DATA_WIDTH = 8) (
  logic clock,
  logic reset
);

logic [DATA_WIDTH-1:0]         tdata;
logic                          tvalid;
logic                          tready;
logic                          tkeep;
logic [$clog2(DATA_WIDTH)-1:0] tstrb;
logic                          tlast;
logic                          tuser;

modport main (
  input  clock,
  input  reset,
  output tdata,
  output tvalid,
  input  tready,
  output tkeep,
  output tstrb,
  output tlast,
  output tuser
);

modport peripheral (
  input  clock,
  input  reset,
  input  tdata,
  input  tvalid,
  output tready,
  input  tkeep,
  input  tstrb,
  input  tlast,
  input  tuser
);

endinterface