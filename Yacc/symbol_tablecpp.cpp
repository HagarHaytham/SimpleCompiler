#include <iostream>
#include <map>
#include "symbol_table.h"
#include <fstream>
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
map<std::string,struct data>sym; 
map<std::string,int>created; 
ofstream file;
void write_quadruple(string to_print,string split)
{

    file.open("quad.txt",std::ios::app);
    file <<to_print<<split;
    file.close();
}
int create_int(char* name, int assign, int value)
{
        write_quadruple("CREATE"," ");
        if(assign)
        {
            write_quadruple("-"," ");
            write_quadruple(to_string(value)," ");
        }
        else
        {
            write_quadruple("-"," ");
            write_quadruple("-"," ");

        }
        write_quadruple(name,"\n");
        
        std::string str = name;
        if(created[str])
            return 0;
        created[str] = 1;
        struct data d;
        d.type = INTEGER;
        d.assigned = assign;
        d.int_value = value;
        sym[str] = d;
        return 1;
 }
int create_float(char* name, int assign, float value)
{

    write_quadruple("CREATE"," ");
    if(assign)
    {
        write_quadruple("-"," ");
        write_quadruple(to_string(value)," ");

    }
    else
    {
        write_quadruple("-"," ");
        write_quadruple("-"," ");

    }
    write_quadruple(name,"\n");
    std::string str = name;
    if(created[str])
        return 0;
    struct data d;
    created[str] = 1;
    d.type = FLOAT;
    d.assigned = assign;
    d.float_value = value;
    sym[str] = d;
    return 1;
}
int create_char(char* name, int assign, char value)
{
    write_quadruple("CREATE"," ");
    string tmp = "";
    tmp += value;

    if(assign)
    {
        write_quadruple("-"," ");
        write_quadruple(tmp," ");

    }
    else
    {
        write_quadruple("-"," ");
        write_quadruple("-"," ");

    }
    write_quadruple(name,"\n");
    std::string str = name;
    if(created[str])
        return false;
    struct data d;
    created[str] = 1;
    d.type = CHAR;
    d.assigned = assign;
    d.char_value = value;
    sym[str] = d;
    return 1;
}
int create_string(char* name, int assign, char* value)
{
    write_quadruple("CREATE"," ");

    if(assign)
    {
        write_quadruple("-"," ");
        write_quadruple(value," ");

    }
    else
    {
        write_quadruple("-"," ");
        write_quadruple("-"," ");

    }
    write_quadruple(name,"\n");
    std::string str = name;
    if(created[str])
        return 0;
    created[str] = 1;
    struct data d;
    d.type = STRING;
    d.assigned = assign;
    d.string_value = value;
    sym[str] = d;
    return 1;
}
int assign_int(char* name, int val)
{
    write_quadruple("MOVE"," ");
    write_quadruple("-"," ");
    write_quadruple(to_string(val)," ");
    write_quadruple(name,"\n");
    std::string str = name;
    if(!created[str])
        return 0;
    created[str] = 1;
    sym[str].int_value = val;
    sym[str].assigned = 1;
    return 1;
}
int assign_float(char* name, float val)
{
    write_quadruple("MOVE"," ");
    write_quadruple("-"," ");
    write_quadruple(to_string(val)," ");
    write_quadruple(name,"\n");
    std::string str = name;
    if(!created[str])
        return false;
    created[str] = 1;
    sym[str].float_value = val;
    sym[str].assigned = 1;
    return 1;
}
int assign_char(char* name, char val)
{
    write_quadruple("MOVE"," ");
    write_quadruple("-"," ");
    string tmp = "";
    tmp += val;
    write_quadruple(tmp," ");
    write_quadruple(name,"\n");
    std::string str = name;
    if(!created[str])
        return false;
    sym[str].char_value = val;
    sym[str].assigned = 1;
    return 1;
}
int assign_string(char* name, char* val)
{
    write_quadruple("MOVE"," ");
    write_quadruple("-"," ");
    write_quadruple(val," ");
    write_quadruple(name,"\n");
    std::string str = name;
    if(!created[str])
        return 0;
    sym[str].string_value = val;
    sym[str].assigned = 1;
    return 1;
}
float get_value(char* name,int &flag)
{
    write_quadruple(name," ");
    std::string str = name;
    if(!created[str])
    {
    flag = -1;
    return NULL;
    }
    if(!sym[str].assigned)
    {
        flag = -1;
        return NULL;
    }
    if(sym[str].type != INTEGER && sym[str].type != FLOAT)
    {
        flag = -1;
        return NULL;
    }
    if(sym[str].type == INTEGER)
        return float(sym[str].int_value);
    else
    {
        return sym[str].float_value;
    }
}
int assign_value(char* name , float value)
{
    write_quadruple(name,"\n");
    std::string str = name;
    cout<<value<<endl;
    if(!created[str])
        return -1;
    if(sym[str].type == INTEGER)
    {
        sym[str].int_value=int(value);
        sym[str].assigned = 1;
        return 1;
    }
    else if(sym[str].type == FLOAT)
    {
        sym[str].float_value=value;
        sym[str].assigned = 1;
        return 1;
    }
    else return -2;

}
void print_operation(char* operation)
{
    write_quadruple(operation," ");
}
void print_table()
{
    cout<<"SYMBOL TABLE:"<<endl;
    for(std::map<std::string,data>::iterator it = sym.begin(); it != sym.end();it++)
    {
        cout<<it->first<<" ";
        if(it->second.assigned == 0)
        {
            cout<<"NOT ASSIGNED.\n";
            continue;
        }
        switch(it->second.type)
        {
            case INTEGER:
                cout<<it->second.int_value;
                break;
            case FLOAT:
                cout<<it->second.float_value;
                break;
            case CHAR:
                cout<<it->second.char_value;
                break;
            case STRING:
                cout<<it->second.string_value;
                break;
        }
        cout<<endl;
    }
    cout<<"CREATED: "<<endl;
    for(std::map<std::string,int>::iterator it = created.begin(); it != created.end();it++)
    {
        cout<<it->first<<" "<<it->second<<endl;
    }
}

    
