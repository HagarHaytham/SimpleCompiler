//C++-source: sys_unicode_for_c.hpp


#include"mapp.h"
#include <iostream>
#include <unordered_map>
using namespace std;

  unordered_map <int, int> mp;
    
 void add(int key,int val) {
    mp[key] = val;
    cout << mp[1]<<endl;
  }

  int val(int idx){
    return mp[idx];
  }