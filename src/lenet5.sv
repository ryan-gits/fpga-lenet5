module lenet5 (
  input logic         clock,
  input logic         reset,
  axis_if.peripheral  input_image,
  output logic        busy,
  output logic        valid,
  output logic [9:0]  model_output
);

  localparam int NUM_CONV_LAYER_1_FILTERS = 6;

  // 32x32x1 image in
  // convolution layer 1 - 5x5, stride 1, tanh -> 28x28x6 feature maps
  for (genvar i=0; i<NUM_CONV_LAYER_1_FILTERS; i++) begin
    convolution #(.KERNEL_SIZE(5)) U_CONVOLUTION (
      .clock     (clock),
      .reset     (reset),
      .image_in  (image_in),
      .image_out (image_out)
    );
  end

  // pooling - 2x2, stride 1 -> 14x14x6 feature maps

  // convolution layer 2 - 5x5, stride 1, tanh -> 10x10x16 feature maps

  // pooling, 2x2, stride 2 -> 5x5x16 feature maps

  // convolution layer 3 - 5x5, stride 1, tanh -> 1x1x120 filtered output

  // fully connected layer, 84 neurons, tanh

  // output layer, 10 neurons, softmax

endmodule