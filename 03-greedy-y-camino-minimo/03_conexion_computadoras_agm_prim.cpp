#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int cant_cpus;
vector<int> x;
vector<int> y;
vector<long long> costos;
vector<long long> k;


void datos(){

    cin >> cant_cpus;


    x.resize(cant_cpus+1);
    y.resize(cant_cpus+1);
    costos.resize(cant_cpus+1);
    k.resize(cant_cpus+1);


    for(int i = 0; i < cant_cpus; i++){
        cin >> x[i+1];
        cin >> y[i+1];
    }

    for(int i = 0; i < cant_cpus; i++){
        cin >> costos[i+1]; 
    }

    for(int i = 0; i < cant_cpus; i++){
        cin >> k[i+1]; 
    }

}


long long costo_cable(int i, int j){

    // Si conecta con el servidor
    if(i == 0){
        return costos[j];
    }
    if(j == 0){
        return costos[i];
    }

    // Si conecta con otra pc
    long long dist = abs(x[i] - x[j]) + abs(y[i] - y[j]);
    return (k[i] + k[j]) * dist;
}


long long INF = 1e19;
vector<int> pi;


long long prim(int N){

    vector<long long> min_arista(N, INF);
    vector<bool> visitado(N, false);
    
    long long costo_total = 0;

    pi.resize(N);
    for(int i = 0; i < N; i++){
        pi[i] = -1;
    }

    min_arista[0] = 0;

    for(int j = 0; j < N; j++){
        int u = -1;
        long long menor_costo = INF;

        // Mejor v fuera del árbol
        for(int i = 0; i < N; i++){
            if(!visitado[i]){
                if(min_arista[i] < menor_costo){
                    menor_costo = min_arista[i];
                    u = i;
                }
            }
        }

        visitado[u] = true;
        costo_total = costo_total + menor_costo;

        // Relajar vecinos
        for(int v = 0; v < N; v++){
            if(!visitado[v]){
                long long costo = costo_cable(u, v);
                if(costo < min_arista[v]){
                    min_arista[v] = costo;
                    pi[v] = u;
                }
            }
        }
    }

    return costo_total;
}


int main(){

    datos();

    long long peso_min = prim(cant_cpus+1);
    
    
    vector<int> routers(cant_cpus+1, 0);
    int cant_routers = 0;
    for(int i = 1; i < cant_cpus+1; i++){
        if(pi[i] == 0){
            cant_routers++;
            routers[i] = 1;
        }
    }

    // Peso min
    cout << peso_min << "\n";

    // Cant routers
    cout << cant_routers << "\n";

    // Cuales tienen router
    for(int i = 1; i < cant_cpus+1; i++){
        if(routers[i] == 1){
            cout << i << " ";
        }
    }
    cout << "\n";

    // Ctas conexiones hay
    cout << cant_cpus - cant_routers << "\n";

    // Conexiones
    for(int i = 1; i < cant_cpus+1; i++){
        if(pi[i] != 0){
            cout << i << " " << pi[i] << "\n";
        }
    }

    return 0;
}
