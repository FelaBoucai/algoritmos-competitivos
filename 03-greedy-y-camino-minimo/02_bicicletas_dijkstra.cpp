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
long long INF = 1e+10;

vector<long long> d;
vector<int> pi;

long long dijkstra(vector<vector<vector<tuple<int, int>>>> ady, vector<vector<int>> costos, int test){
    int n = ady[test].size();
    int lentitud = INF;

    d.assign(n, INF);
    pi.assign(n, -1);

    priority_queue<
        pair<long long, int>,
        vector<pair<long long, int>>,
        greater<pair<long long, int>>
    > pq;

    d[0] = 0;
    pq.push({0, 0});
    lentitud = costos[test][0];

    while (!pq.empty()) {
        long long dist = pq.top().first;
        int u = pq.top().second;
        pq.pop();

        if (dist > d[u]) continue;

        if(costos[test][u] < lentitud){
            lentitud = costos[test][u];
        }

        for(int j = 0; j < ady[test][u].size(); j++){
            int v = get<0>(ady[test][u][j]);
            int peso = get<1>(ady[test][u][j]);
            if (d[u] + peso * lentitud < d[v]) {
                d[v] = d[u] + peso * lentitud;
                pi[v] = u;
                pq.push({d[v], v});
            }
        }
    }

    return d[n - 1];
}




int main(){

    datos();

    for(int i = 0; i < cant_test; i++){
        cout << dijkstra(ady, costos, i) << "\n";
    }


    return 0;

}