#define HEIGHT_POW 12
#define WIDTH_POW 12

#define HEIGHT (1 << HEIGHT_POW)
#define WIDTH (1 << WIDTH_POW)

#define XMAX 1
#define XMIN -1
#define YMAX 1
#define YMIN -1

#define MAX_ITERATIONS 100
#define EPSILON 10e-8

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