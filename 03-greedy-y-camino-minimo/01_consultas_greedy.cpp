#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int N;
int k;
vector<int> sec;


void datos(){
    cin >> N;

    sec.resize(N);

    for(int i = 0; i < N; i++){
        cin >> k;
        sec[i] = k;
    }
    
    sort(sec.begin(), sec.end());

}

int max_alumnos(vector<int> alumno){
    int n = alumno.size();
    int res = 0;
    int tiempo_transcurrido = 0;

    for(int i = 0; i < n; i++){
        if(alumno[i] >= tiempo_transcurrido){
            res++;
            tiempo_transcurrido = tiempo_transcurrido + alumno[i];
        }
    }

    return res;
}



int main(){

    datos();
    int out = max_alumnos(sec);
    cout << out;

    return 0;
}