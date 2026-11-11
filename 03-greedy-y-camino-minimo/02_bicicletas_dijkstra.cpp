#include <iostream>
#include <vector>
#include <tuple>
#include <algorithm>
#include <functional>
#include <queue>
using namespace std;

int cant_test;
vector<int> cant_ciudades;
vector<int> cant_calles;
vector<vector<vector<tuple<int, int>>>> ady;;
vector<vector<int>> costos;
int u;
int v;
int w;


void datos(){
    cin >> cant_test;
    cant_ciudades.resize(cant_test);
    cant_calles.resize(cant_test);
    ady.resize(cant_test);
    costos.resize(cant_test);

    for(int i=0; i < cant_test; i++){
        cin >> cant_ciudades[i];
        costos[i].resize(cant_ciudades[i]);
        
        cin >> cant_calles[i];
        ady[i].resize(cant_ciudades[i]);       
        
        for(int j=0; j < cant_calles[i]; j++){
            cin >> u;
            cin >> v;
            cin >> w;
            ady[i][u-1].push_back({v-1, w});
            ady[i][v-1].push_back({u-1, w});
        }
        for(int k=0; k < cant_ciudades[i]; k++){
            cin >> costos[i][k];
        }

    }

}
long long INF = 1e18;
long long LL = 1;


long long dijkstra(vector<vector<vector<tuple<int, int>>>> ady, vector<vector<int>> costos, int test){
    
    int n = costos[test].size();

    vector<vector<long long>> d(n, vector<long long>(1001, INF));

    priority_queue<tuple<long long, int, int>, vector<tuple<long long, int, int>>, greater<tuple<long long, int, int>>> Q;

    d[0][costos[test][0]] = 0;
    Q.emplace(0, 0, costos[test][0]);

    while(!Q.empty()){
        auto[dist, u, lentitud] = Q.top();
        Q.pop();


        for(auto& arista: ady[test][u]){
            auto [v, peso] = arista;

            long long dist_nueva = dist + peso * lentitud * LL;

            int bici_nueva = min(lentitud, costos[test][v]);

            if(dist_nueva < d[v][bici_nueva]){
                d[v][bici_nueva] = dist_nueva;
                Q.emplace(dist_nueva, v, bici_nueva);
            }
        }

    }





    long long res = INF;
    for(int i = 1; i <= 1000; i++){
        res = min(res, d[n-1][i]);
    }
    return res;
}




int main(){

    datos();

    for(int i = 0; i < cant_test; i++){
        cout << dijkstra(ady, costos, i) << "\n";
    }


    return 0;

}
