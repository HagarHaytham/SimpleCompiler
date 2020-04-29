// Wrapper.h
// #include "Utility.h"

#ifdef __cplusplus
extern "C" {
#endif
    void write_quadruple(char* op , char* src1, char* src2 , char* dest);
    int create_int(char* name, int  assign, int value);
    int create_float(char* name, int assign, float value);
    int create_char(char* name, int assign, char value);
    int create_string(char* name, int assign, char* value);
    int assign_int(char* name, int val);
    int assign_float(char* name, float val);
    int assign_char(char* name, char val);
    int assign_sting(char* name, char* val);
#ifdef __cplusplus
     }
#endif
