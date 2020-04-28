// Wrapper.h
// #include "Utility.h"

#ifdef __cplusplus
extern "C" {
#endif
    float get_value(char* name, int &flag); 
    int create_int(char* name, int  assign, int value);
    int create_float(char* name, int assign, float value);
    int create_char(char* name, int assign, char value);
    int create_string(char* name, int assign, char* value);
    int assign_int(char* name, int val);
    int assign_float(char* name, float val);
    int assign_char(char* name, char val);
    int assign_string(char* name, char* val);
    char* assign_value(char* name,float val);
    void print_table();
#ifdef __cplusplus
    }
#endif
