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
map<std::string,struct data>sym; 
map<std::string,int>created;   

int create_int(char* name, int assign, int value)
{
        cout<<"create integer function "<<endl;
        //cout<<name<<assign<<value;
        std::string str = name;
        if(created[str] == 1)
            return 0;
        created[str] = 1;
        cout<<"CREATING VAR "<<created[str];
        struct data d;
        d.type = INTEGER;
        d.assigned = assign;
        d.int_value = value;
        sym[str] = d;
        return 1;
 }
int create_float(char* name, int assign, float value)
{
    std::string str = name;

    cout<<"create float function "<<endl;

    if(created[str])
        return false;
    struct data d;
    d.type = FLOAT;
    sym[str] = d;
    if(assign)
    {
        sym[str].assigned = 1;
        sym[str].float_value = value;
    }
    return 1;
}
int create_char(char* name, int assign, char value)
{
    std::string str = name;

    cout<<"create char function "<<endl;
    cout<<str<<" "<<value<<endl;
    if(created[str])
        return false;
    struct data d;
    d.type = CHAR;
    sym[str] = d;
    if(assign)
    {
        sym[str].assigned = 1;
        sym[str].char_value = value;
    }
    return 1;
}
int create_string(char* name, int assign, char* value)
{
    std::string str = name;

    cout<<"create string function "<<endl;
    cout<<str<<" "<<value<<endl;
    if(created[str])
        return false;
    struct data d;
    d.type = STRING;
    sym[str] = d;
    if(assign)
    {
        sym[str].assigned = 1;
        sym[str].string_value = value;
    }
    return 1;
}
int assign_int(char* name, int val)
{
    std::string str = name;

    cout<<"assign integer function "<<endl;
    cout<<str<<" "<<val<<endl;
    if(created[str])
        return false;
    sym[str].int_value = val;
    sym[str].assigned = 1;
    return 1;
}
int assign_float(char* name, float val)
{
    std::string str = name;

    cout<<"assign float function "<<endl;
    if(created[str])
        return false;
    sym[str].float_value = val;
    sym[str].assigned = 1;
    return 1;
}
int assign_char(char* name, char val)
{
    std::string str = name;
    cout<<"assign char function "<<endl;
    if(created[str])
        return false;
    sym[str].char_value = val;
    sym[str].assigned = 1;
    return 1;
}
int assign_string(char* name, char* val)
{
    std::string str = name;
    cout<<"assign string function "<<endl;
    if(!created[str])
        return 0;
    sym[str].string_value = val;
    sym[str].assigned = 1;
    return 1;
}
float get_value(char* name,int &flag)
{
    cout<<"get value "<<endl;
    // print_table();
    str::string str = name;
    cout<<str<<"hello"<<endl;
    cout<<"created "<<created[str]<<endl;
    if(created[str] == 0)
        {
        flag = -1;
        return NULL;
        }
    if(sym[str].assigned == 0)
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
char* assign_value(char* name , float value)
{
    cout<<"assign value"<<endl;
    cout<<name<<" "<<value<<endl;
    std::string str = name;
    if(!created[str])
        return "ERROR : UNKNOWN Identifier";
    if(sym[str].type == INTEGER)
    {
        sym[str].int_value=int(value);
        // cout<<"WARNING : float value cast to integer"<<endl;
        return "";
    }
    else if(sym[str].type == FLOAT)
    {
        sym[str].float_value=value;
        return "";
    }
    else return "ERROR : Identifier type not supported";

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

    
