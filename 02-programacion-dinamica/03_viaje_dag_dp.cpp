#include <iostream>
#include <vector>
#include <map>
using namespace std;

int n;
int m;
int T;



vector<vector<int>> calles;
vector<vector<int>> t;

void datos(){
    int k;
    int l;
    int o;

    cin >> n >> m >> T;

    calles.resize(n);
    t.resize(n, vector<int>(n, -1));

    for(int i = 0; i < m; i++){
        cin >> k >> l >> o;
        calles[k-1].push_back(l-1);
        t[k-1][l-1] = o;
    }

}

map<int, vector<int>> memoria_max;
map<int, vector<int>> siguiente;


int maximo_paradas(int tiempo, int pos){

    // PODAS
    if(tiempo > T){
        return -2*n;
    }

    if(pos == n-1){
        return 1;
    }

    // CREO LOS DIC SI NO ESTAN
    if(memoria_max.find(tiempo) == memoria_max.end()){
        memoria_max[tiempo] = vector<int>(n, -1);
    }
    if (siguiente.find(tiempo) == siguiente.end()) {
        siguiente[tiempo] = vector<int>(n, -1);
    }
    
    // USO LA MEMORIA
    if(memoria_max[tiempo][pos] != -1){
        return memoria_max[tiempo][pos];
    }


    // veo si es mejor que el max, si es actualizo y elijo al mejor vecino
    int maximo = -2*n;
    int mejor_siguiente;

    for (int v: calles[pos]){
        int maximo2 = maximo_paradas(tiempo + t[pos][v], v)+1;
        if(maximo < maximo2){
            maximo = maximo2;
            mejor_siguiente = v;
        }
    }

    memoria_max[tiempo][pos] = maximo;
    siguiente[tiempo][pos] = mejor_siguiente;

    return maximo;
}

vector<int> camino(){
    int tiempo = 0;
    int pos = 0;
    vector<int> camino_final;

    while(pos != n-1){
        camino_final.push_back(pos+1);
        int v = siguiente[tiempo][pos];

        tiempo = tiempo + t[pos][v];
        pos = v;
    }
    camino_final.push_back(n);

    return camino_final;
}

int main(){
    datos();
    int res = maximo_paradas(0,0);
    cout << res << "\n";

    vector<int> C = camino();

    for(int j = 0; j < C.size(); j++){
        cout << C[j] << " ";
    } 

    return 0;
}