#include<iostream>
#include<map>
#include "symbol_table.h"
using namespace std;
#define INTEGER 2
#define FLOAT 3
#define CHAR 5
#define STRING 6
struct data
{
    int type;
    char* string_value;
    int int_value;
    float float_value;
    char char_value;
    int assigned;  
};
map<char*,struct data>sym; 
map<char*,int>created;   
int create_int(char* name, int type, int assign, int value)
{
        if(created[name] == 0)
            return false;
        struct data d;
        d.type = type;
        d.assigned = assign;
        d.int_value = value;
        sym[name] = d;
        return true;
 }
int create_float(char* name, int type, int assign, float value)
{
        if(created[name])
            return false;
        struct data d;
        d.type = type;
        sym[name] = d;
        if(assign)
        {
            sym[name].assigned = true;
            sym[name].int_value = value;
        }
        return true;
    }
    int create_char(char* name, int type, int assign, char value)
    {
        if(created[name])
            return false;
        struct data d;
        d.type = type;
        sym[name] = d;
        if(assign)
        {
            sym[name].assigned = true;
            sym[name].char_value = value;
        }
        return true;
    }
    int create_string(char* name, int type, int assign, char* value)
    {
        if(created[name])
            return false;
        struct data d;
        d.type = type;
        sym[name] = d;
        if(assign)
        {
            sym[name].assigned = true;
            sym[name].string_value = value;
        }
        return true;
    }
int assign_int(char* name, int val)
{
        if(created[name])
            return false;
        sym[name].int_value = val;
        sym[name].assigned = true;
        return true;


    }
    int assign_float(char* name, float val)
    {
        if(created[name])
            return false;
        sym[name].float_value = val;
        sym[name].assigned = true;
        return true;
    }
    int assign_char(char* name, char val)
    {
        if(created[name])
            return false;
        sym[name].char_value = val;
        sym[name].assigned = 1;
        return true;
    }
    int assign_string(char* name, char* val)
    {
        if(created[name])
            return false;
        sym[name].string_value = val;
        sym[name].assigned = true;
        return true;
    }
    
