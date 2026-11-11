#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int n;
int m;
int T;



vector<vector<pair<int, int>>> calles_inv;

vector<vector<long long>> M;
vector<vector<short>> anterior;

void datos(){
    int k;
    int l;
    int o;

    cin >> n >> m >> T;

    calles_inv.resize(n);

    for(int i = 0; i < m; i++){
        cin >> k >> l >> o;
        calles_inv[l-1].push_back({k-1, o});
    }
    
    M = vector<vector<long long>>(n, vector<long long>(n, -1));
    anterior = vector<vector<short>>(n, vector<short>(n, -1));

}



long long tiempo_minimo(int cant_paradas, int pos){

    if(cant_paradas == 0){
        if (pos == 0){
            return 0;
        }
        return 1e+10;
    }

    if(M[cant_paradas][pos] != -1){
        return M[cant_paradas][pos];
    }

    long long minimo = 1e+10;


    for(auto [v, tiempo]: calles_inv[pos]){
        long long recursion = tiempo_minimo(cant_paradas - 1, v);
        if(recursion < 1e+10 && recursion + tiempo < minimo){
            minimo = recursion + tiempo;
            anterior[cant_paradas][pos] = v;
        }
    }

    M[cant_paradas][pos] = minimo;
    return minimo;


}


long long res;
int main(){
    datos();

    for(int k = 0; k<n; k++){
        if(tiempo_minimo(k, n-1) <= T){
            res = k;
        }
    }

    cout << res + 1 << "\n";

    int v;
    int j;
    j = n-1;
    int h;
    vector<int> sec(res);
    h = 0;
    

    for(int i = res; i > 0; i--){
        v = anterior[i][j];
        sec[h] = v+1;
        h++;
        j = v;

    }

    reverse(sec.begin(), sec.end());

    for(int i =0; i < res; i++){
        cout << sec[i] << " ";
    }
    cout << n << " ";

    return 0;
}
