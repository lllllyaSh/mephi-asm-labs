#include "func.h" 
void func(int width ,int height, int bytes, unsigned char* data, unsigned char* new_data){

	for(int j =0; j<height; ++j){
		for(int i=0; i<width; ++i){
			for(int pos = 0; pos < bytes; ++pos){
				new_data[j*width*bytes+i*bytes+pos] = data[(j+1)*width*bytes-i*bytes-bytes+pos];
			}
		}
	}

	return ;
}
