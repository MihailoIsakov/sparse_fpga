// number of channels in the accelerator
parameter channel_num = 4;
parameter channel_num_log = 2;

// size of column ID - 10 for 784 column matrix
parameter col_id_size = 16;

// size of row lengths
parameter row_len_size = 8;

// size of the multiplication 
parameter mult_size = 16; // DEPRECATE

// the size of the weights and inputs.
// This can change a lot with quantization
parameter val_bits = 8; 


// BVB parameters //////////////////////////////////////////////////////////////////////////////
    // the width of the RAM channel in bits
    parameter ram_width = 1024;
    // the BVB loads chunks of the vector, ram_splits control the number of those chunks
    // ram_width * ram_splits * byte_size needs to be larger than the vector
    parameter ram_splits = 8;
    // to store the index of each split, ram_split_bits controls the number 
    // of bits in the index, is log2(ram_splits)
    parameter ram_split_bits = 9;

    // address size of the input vectors
    // With images the size of 28*28=784, and with 1000+ images, addresses go
    // from 0 to 1M+
    parameter bvb_addr_size = 32;


// Fetcher addresses 
    /*parameter [0:12*13] val_addr = {13'd0, 13'd1061, 13'd2122, 13'd3183, 13'd4244, 13'd4476, 13'd4708, 13'd4940, 13'd5172, 13'd5183, 13'd5194, 13'd5205};*/
    /*parameter [0:12*13] col_addr = {13'd0, 13'd1061, 13'd2122, 13'd3183, 13'd4244, 13'd4476, 13'd4708, 13'd4940, 13'd5172, 13'd5183, 13'd5194, 13'd5205};*/
    /*parameter [0:12*13] len_addr = {9'd0,  9'd65,    9'd127,   9'd186,   9'd250,   9'd278,   9'd319,   9'd359,   9'd398,   9'd401,   9'd403,   9'd406};*/
    parameter [0:4*13-1] val_addr = {13'd0, 13'd1061, 13'd2122, 13'd3183};
    parameter [0:4*13-1] col_addr = {13'd0, 13'd1061, 13'd2122, 13'd3183};
    parameter [0:4*9-1] len_addr = {9'd0,  9'd65,    9'd127,   9'd186};

// CISR + accelerator
    parameter counter_size     = 8; // must be greater than the number of elements in a row, 4 bits should be fine
    parameter row_id_size      = 8; // must be greater than log2(len(vector))
    parameter accumulator_size = 32;
