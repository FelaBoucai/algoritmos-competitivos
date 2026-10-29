#include <iostream>
#include <vector>
#include <queue>
#include <string>
using namespace std;


string recorrido(){
    int n;
    int k;
    int l;
    int u;
    cin >> n;

    vector<int> a(n);
    vector<int> pos(n);
    
    vector<int> color(n);
    vector<int> d(n);
    vector<vector<int>> ady(n);
    vector<int> pi(n);

    queue<int> q;
    
    for(int i = 0; i < n-1; i++){
        cin >> k >> l;
        ady[k-1].push_back(l-1);
        ady[l-1].push_back(k-1);
    }

    for(int i = 0; i < n; i++){
        cin >> a[i];
        a[i]--;
        pos[a[i]] = i;
    }

    for(int i = 0; i < n; i++){
        color[i] = 1; // blanco
        d[i] = n+1;
    }

    color[0] = 2; //gris
    d[0] = 0;
    pi[0] = 0;
    q.push(0);

    while(!q.empty()){
        u = q.front();
        q.pop();
        for(int v : ady[u]){
          if(color[v] == 1){
            color[v] = 2;
            d[v] = d[u] + 1;
            pi[v] = u;
            q.push(v);
          }
        }
        color[u] = 3; //negro
    }

    if(pos[0] != 0){
        return "No";
    }

    for(int i = 1; i < n-1; i++){
        if(pos[pi[a[i]]] > pos[a[i]]){
           return "No"; 
        }
        if(pos[pi[a[i]]] > pos[pi[a[i+1]]]){
            return "No";
        }
    }

    return "Yes";

}

int main() {
    string res = recorrido();

    cout << res << "\n";
    
    return 0;
}