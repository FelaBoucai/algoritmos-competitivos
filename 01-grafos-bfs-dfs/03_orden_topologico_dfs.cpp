#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

bool ciclo = 0;
string orden;

void DFSvisit(int u, vector<vector<int>>& dout, vector<int>& color, vector<int>& pi){
    color[u] = 2; //gris

    for(int v : dout[u]){
        if(color[v] == 2){
            ciclo = 1; // si hay backedge en la misma rama hay ciclo
        }
        if(color[v] == 1){
            pi[v] = u;
            DFSvisit(v, dout, color, pi);
        }
    }
    color[u] = 3; //negro
    orden.push_back('a' + u); // voy armando el output
}

string sui(){
    int n;
    cin >> n;

    vector<string> apellidos(n);
    vector<vector<int>> dout(26);

    // guardo los string en apellidos
    for(int i=0; i < n; i++){
        cin >> apellidos[i];
    }

    for(int i=0; i < n-1; i++){

        int m = min(apellidos[i].size(), apellidos[i+1].size());

        

        // armo los dout para el dfs
        for(int j = 0; j < m; j++){
            if (apellidos[i][j] != apellidos[i+1][j]){
                dout[apellidos[i][j] - 'a'].push_back(apellidos[i+1][j] - 'a');
                break;
            }else{
                // si son iguales (para los primeros m), entonces el mas chico tiene que ir primero
                if(j == m-1){
                    if(apellidos[i].size() > apellidos[i+1].size()){
                        return "Impossible";
                    }
                }
            }
        }
    }


    //armo el dfs

    vector<int> color(26);
    vector<int> pi(26);

    for(int i = 0; i < 26; i++){
        color[i] = 1; //blanco
        pi[i] = -1;
    }

    //dfs
    for(int u = 0; u < 26; u++){
        if(color[u] == 1){
            DFSvisit(u, dout, color, pi);
        }
    }

    if(ciclo == 1){
        return "Impossible";
    }

    reverse(orden.begin(), orden.end()); // lo doy vuelta pq me quedaba al reves :p
    return orden;
}

int main(){
    string res = sui();

    cout << res << "\n";

    return 0;
}