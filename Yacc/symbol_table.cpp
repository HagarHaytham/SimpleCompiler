#include<iostream>
#include<map>
#include<string>
using namespace std;
#define INTEGER 2
#define FLOAT 3
#define CHAR 5
#define STRING 6
struct data
{
    int type;
    string string_value;
    int int_value;
    float float_value;
    char char_value;
    bool assigned;  
};
class SymbolTable{
    map<string,struct data>sym;    
public:
    bool create_id(string name, int type)
    {
        struct data d;
        d.type = type;
        //if(sym[name] == NULL)
        sym[name] = d;
        return true;
    }
    template <class T>
    bool assign_id(string name,int type, T val)
    {
        struct data d;
        d.type = type;
        switch(type)
        {
            case INTEGER:
                d.int_value = val;
                break;
            case FLOAT:
                d.float_value = val;
                break;
            case STRING:
                d.string_value = val;
                break;
            case CHAR:
                d.char_value = val;
                break;
            case default:
                break;
        }
        sym[name] = d;
        return true;
    }
};
int main()
{
    return 0;
}