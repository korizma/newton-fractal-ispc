#define HEIGHT_POW 12
#define WIDTH_POW 12

#define HEIGHT (1 << HEIGHT_POW)
#define WIDTH (1 << WIDTH_POW)

#define XMAX 2
#define XMIN -2
#define YMAX 2
#define YMIN -2

#define MAX_ITERATIONS 1000
#define EPSILON 10e-5

#define OUTPUT_IMAGE "picture.ppm"

struct ComplexNumber
{
    float re;
    float im;
};

struct PixelInfo
{
    ComplexNumber root;
    int iterations;
};

struct RGB_val
{
    int r, g, b;
};