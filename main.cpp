#include <bits/stdc++.h>
#include "config.h"
#include "parallel_functions.h"

using namespace std;

int imgR[HEIGHT * WIDTH];
int imgG[HEIGHT * WIDTH];
int imgB[HEIGHT * WIDTH];

void writeImage()
{
    FILE* f = fopen(OUTPUT_IMAGE, "w");
    fprintf(f, "P3\n%d %d\n255\n", WIDTH, HEIGHT);
    for (int i = 0; i < HEIGHT * WIDTH; i++)
        fprintf(f, "%d %d %d ", imgR[i], imgG[i], imgB[i]);
    fclose(f);
}

int main(int argc, char** argv)
{
    int n;
    if (argc >= 2) {
        int parsed = atoi(argv[1]);
        if (parsed >= 2) n = parsed;
    }
    cout << "Generating Newton fractal for x^" << n << " - 1\n";

    // start time measurement
    auto start = chrono::high_resolution_clock::now();

    ispc::calculateImage(n, imgR, imgG, imgB);

    // end time measurement
    auto end = chrono::high_resolution_clock::now();
    chrono::duration<double> elapsed = end - start;
    cout << "Image creation time: " << elapsed.count() << " seconds\n";

    writeImage();
    cout << "Image written to " << OUTPUT_IMAGE << endl;

    return 0;
}

