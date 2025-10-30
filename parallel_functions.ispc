#include "config.h"

// HSV/HSB (Hue Saturation Value/Brightness) to RGB (Red Green Blue) conversion
RGB_val hsv_to_rgb(int h, float s, float v)
{
    float chroma = v * s;
    float hPrim = h / 60.0;
    float hPrimMod2 = hPrim - 2.0 * floor(hPrim / 2.0);
    float X = chroma * (1 - abs(hPrimMod2 - 1));

    float r1, g1, b1;
    if (hPrim < 1)
        r1 = chroma, g1 = X, b1 = 0;
    else if (hPrim < 2)
        r1 = X, g1 = chroma, b1 = 0;
    else if (hPrim < 3)
        r1 = 0, g1 = chroma, b1 = X;
    else if (hPrim < 4)
        r1 = 0, g1 = X, b1 = chroma;
    else if (hPrim < 5)
        r1 = X, g1 = 0, b1 = chroma;
    else if (hPrim < 6)
        r1 = chroma, g1 = 0, b1 = X;
    
    float m = v - chroma;

    r1 += m, g1 += m, b1 += m;
    r1 *= 255, g1 *= 255, b1 *= 255;

    RGB_val retV;
    retV.r = r1, retV.g = g1, retV.b = b1;
    return retV;
}

// calculating p(x) = x^n - 1
// x = r cosA + r sinA i
// p(x) = r^n cos(nA) + r^n sin(nA)i - 1
ComplexNumber functionValue(ComplexNumber num, int n)
{
    ComplexNumber a;

    float r_pow_n = pow(sqrt(num.re * num.re + num.im * num.im), n);
    float angle_n = atan2(num.im, num.re) * n;

    a.re = r_pow_n * cos(angle_n) - 1;
    a.im = r_pow_n * sin(angle_n);

    return a;
}

// calculating p'(x) = n * x^(n-1)
// x = r cosA + r sinA i
// p'(x) = n * r^(n-1) cos((n-1)A) + n * r^(n-1) sin((n-1)A) i 
ComplexNumber functionDerivativeValue(ComplexNumber num, int n)
{
    ComplexNumber a;

    float r_pow_n1 = pow(sqrt(num.re * num.re + num.im * num.im), n - 1);
    float angle_n1 = atan2(num.im, num.re) * (n - 1);

    a.re = r_pow_n1 * n * cos(angle_n1);
    a.im = r_pow_n1 * n * sin(angle_n1);

    return a;
}
// calculating z_(k+1) = z_k - p(z_k) / p'(z_k)
ComplexNumber getNextZ(ComplexNumber num, int n)
{
    ComplexNumber fVal = functionValue(num, n);
    ComplexNumber fDerVal = functionDerivativeValue(num, n);
    
    float fDerSqDiff = fDerVal.re * fDerVal.re + fDerVal.im * fDerVal.im;
    float realPart = (fVal.re * fDerVal.re + fVal.im * fDerVal.im) / fDerSqDiff;
    float imagPart = (fVal.im * fDerVal.re - fVal.re * fDerVal.im) / fDerSqDiff;

    ComplexNumber result;
    result.re = num.re - realPart;
    result.im = num.im - imagPart;
    return result;
}

// newtons method 
// MAX_ITERATIONS in config.h
// EPSILON is the minimum apsolute difference between z_k and z_(k+1)
PixelInfo newtonMethod(ComplexNumber num, int n)
{
    ComplexNumber last = num;
    int iterations = 0;

    while (iterations < MAX_ITERATIONS)
    {
        num = getNextZ(num, n);
        if (abs(last.re - num.re) + abs(last.im - num.im) < EPSILON)
            break;
        last = num;
        iterations++;
    }
    PixelInfo a;
    a.root = num, a.iterations = iterations;
    return a;
}

// given the ComplexNumber it finds the closes root
// it uses the trigonometric representation of the roots which is z_m = cos(2PI* m/n) + i sin(2PI* m/n), where m is the rootId
int getRootId(ComplexNumber& a, int n)
{
    float angle = atan2(a.im, a.re);
    int rootId = angle * n / (2*PI);
    if (rootId < 0)
        return rootId + n;
    return rootId;
}

// gets the x coord based on the matrix position
float getXCoord(int x)
{
    return (float)x / (WIDTH-1) * (XMAX - XMIN) + XMIN;
}

// gets the y coord based on the matrix position
float getYCoord(int y)
{
    return (float)y / (HEIGHT-1) * (YMAX - YMIN) + YMIN;
}

// iterates through the matrix to calculate each point's root convergence
// then using the rootId and the iteration count it calculates Hue and Brightness
// Hue = rootId * 359 / n
// Brightness = 1 - iterations/max_iterations
export void calculateImage(uniform int n, int* uniform imgR, int* uniform imgG, int* uniform imgB)
{
    foreach (x = 0 ... HEIGHT * WIDTH)
    {
        int i = x >> WIDTH_POW, j = x & (WIDTH - 1);
        float real = getXCoord(j);
        float imag = getYCoord(i);

        ComplexNumber curr;
        curr.re = real;
        curr.im = imag;
        PixelInfo info = newtonMethod(curr, n);

        int hue = (float)getRootId(info.root, n) / n * 359.0;
        float bright = 1.0 - (float)info.iterations / (float)MAX_ITERATIONS;
        
        RGB_val rgb = hsv_to_rgb(hue, 1, bright);

        imgR[x] = rgb.r;
        imgG[x] = rgb.g;
        imgB[x] = rgb.b;
    }
}


