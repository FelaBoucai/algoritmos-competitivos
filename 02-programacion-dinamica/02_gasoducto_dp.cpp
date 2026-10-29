#include <iostream>
#include <vector>
#include <tuple>
#include <string>
using namespace std;


int cant_consultas;
vector<tuple<vector<long long>, vector<int>>> consulta;

vector<vector<vector<long long>>> M;


void datos(){
    cin >> cant_consultas;
    consulta.resize(cant_consultas);



    for(int i = 0; i < cant_consultas; i++){
        get<0>(consulta[i]).resize(3);
    

        for(int j = 0; j < 3; j++){
            cin >> get<0>(consulta[i])[j];
        }

        get<1>(consulta[i]).resize(get<0>(consulta[i])[0]);

        string s;
        cin >> s;

        for(int j = 0; j < get<0>(consulta[i])[0]; j++){
            get<1>(consulta[i])[j] = s[j] - '0';
        }

    }


    M.resize(cant_consultas);

    for(int i = 0; i< cant_consultas; i++){
        M[i] = vector<vector<long long>>(get<0>(consulta[i])[0], vector<long long>(3, -1));
    }
    
}

long long gasoducto(int i_cons, int i_ruta,int altura_previa){




    // FINAL
    if(i_ruta == get<0>(consulta[i_cons])[0]){
        if(altura_previa == 2){
            return 1e15;
        }
        return 0;
    }

    // USO DE MEMORIA
    if(M[i_cons][i_ruta][altura_previa] != -1){
        return M[i_cons][i_ruta][altura_previa];
    }

    
    long long costo_gas = get<0>(consulta[i_cons])[1];
    long long costo_pilar = get<0>(consulta[i_cons])[2];




    if(altura_previa == 1){
        if(get<1>(consulta[i_cons])[i_ruta] == 1){
            M[i_cons][i_ruta][altura_previa] = 1e15;
        }
        if(get<1>(consulta[i_cons])[i_ruta] == 0){
            M[i_cons][i_ruta][altura_previa] = min(gasoducto(i_cons, i_ruta+1 , 1)+ (costo_gas + costo_pilar), gasoducto(i_cons, i_ruta+1 , 2) + (2*costo_gas + 2*costo_pilar));
        }

    }

    if(altura_previa == 2){
        if(get<1>(consulta[i_cons])[i_ruta] == 1){
            long long f = 100000000000000;
            M[i_cons][i_ruta][altura_previa] = min(
                gasoducto(i_cons, i_ruta+1 , 1)+f, 
                gasoducto(i_cons, i_ruta+1 , 2) + (costo_gas + 2*costo_pilar)
            );
        }
        if(get<1>(consulta[i_cons])[i_ruta] == 0){
            M[i_cons][i_ruta][altura_previa] = min(
                gasoducto(i_cons, i_ruta+1 , 1) + (2*costo_gas + costo_pilar),
                gasoducto(i_cons, i_ruta+1 , 2) + (costo_gas + 2*costo_pilar)
                );
        }
    }

    return M[i_cons][i_ruta][altura_previa];
}


int main(){
    datos();
    vector<long long> res(cant_consultas);
    for(int i = 0; i < cant_consultas; i++){
         res[i] = gasoducto(i, 0, 1) + get<0>(consulta[i])[2];
    }
    for(int i = 0; i < cant_consultas; i++){
         cout << res[i] << "\n";
    }
    
    return 0;
}

