#include <stdio.h>
#include <time.h>
#include <math.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"

#ifdef C
#include "func.h"
#else
extern void func(int, int, int, unsigned char*, unsigned char*);
#endif
int main(int argc, char** argv){
	
	if(argc!=3){
		printf("Usage: %s input.png output.png\n", argv[0]);
		return 1;
	}

	
	int x,y,n;
	unsigned char* data = stbi_load(argv[1], &x, &y, &n,3);
	if(data == NULL){
		printf("Error loading img!\n");
		return 1;
	}

	unsigned char* new_data=malloc(x*y*n*sizeof(unsigned char) );
	

	clock_t start, end;
	
	start = clock();
	// x-width, y=height
	func(x, y, n, data, new_data);

	end = clock();
	double dur = (double)(end-start)/CLOCKS_PER_SEC;
	printf("func() took %f seconds\n", dur);
	stbi_write_png(argv[2],x, y, n, new_data, 0);


}
