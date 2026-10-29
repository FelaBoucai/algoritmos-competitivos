#include <iostream>
#include <vector>
#include <tuple>
#include <map>
#include <optional>
using namespace std;

int n;
vector<int> a;
vector<map<tuple<int,int>, optional<int>>> M(n);


void datos(){
    cin >> n;
    a.resize(n);
    M.resize(n);

    for(int i = 0; i < n; i++){
        cin >> a[i];
    }
}

int i = 0;
tuple<int, int> J = {0, 0};


int vacaciones(int i, tuple<int, int> J){


    // PODAS
    if(get<0>(J) == get<1>(J)){
        if(get<0>(J) != 0){
            return 1e4;
        }
    }

    if(i > 0){
        int j = get<1>(J);
        int r = a[i-1];

        if(j == 1){
            if(r == 0 || r == 1){
                return 1e4;
            }
        }
        
        if(j == 2){
            if(r == 0 || r == 2){
                return 1e4;
            }
        }
    }

    if(i == n){
        return 0;
    }
    // FIN DE LAS PODAS

    if (!M[i][J].has_value()) {
    // Todavía es null
    int x = get<1>(J);

    tuple<int, int> A = {x, 0};
    tuple<int, int> B = {x, 1};
    tuple<int, int> C = {x, 2};

    M[i][J] = min(vacaciones(i+1, A) + 1, min(vacaciones(i+1, B), vacaciones(i+1, C)));

    }

    return M[i][J].value();

}

int main(){
    datos();
    int res = vacaciones(i, J);

    cout << res << "\n";

    return 0;
}