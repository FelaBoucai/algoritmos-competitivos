#include <iostream>
#include <vector>
#include <unordered_set>
using namespace std;


int piramidal(){
int n;
cin >> n;

vector<int> p(n);
//vector<int> d(n);
unordered_set<int> s;
unordered_set<int> t;
int j = 0;

for(int i = 0; i < n; i++){
    cin >> p[i];
}

for(int i = 0; i < n; i++){
    if (p[i] == -1){
//        d[i] = j;
        s.insert(i+1);
    }    
}

while(!s.empty()){
    j = j+1;
for(int i = 0; i < n; i++){
    if(s.count(p[i]) > 0){
        t.insert(i+1);
//        d[i] = j;
        p[i] = -1;
    }
}
s = t;
t = {};
}

return j;
}

int main(){
    int res = piramidal();

    cout << res << "\n";

    return 0;
}