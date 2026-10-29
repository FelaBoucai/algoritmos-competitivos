import java.Math;

public class ArbolBinario<T>{
    private Nodo[] _arbol;
    private int _length;

    private class Nodo{

        public int indice;
        public Nodo izq;
        public Nodo der;
        public T dato;

        public Nodo(T valor, int i){
            indice = i;
            dato = valor;
            izq.indice = i * 2 + 1;
            der.indice = i * 2 + 2;
        }

    
        private Nodo getIzquierda(Nodo nodo){
            return nodo.izq;
        }

        private Nodo getDerecha(Nodo nodo){
            return nodo.der;
        }

    }

    public ArbolBinario(int maxLength){
        _length = 0;
        Nodo[] _arbol = new Nodo[maxLength];
    }


    public boolean nivelCompleto(ArbolBinario<T> a, int n){
        for(int i = 0; i < Math.pow(2, n) - 2; i++){
            if(_arbol[i] == null){
                return false;
            }
        }
        return true;
    }







    // private Nodo raiz;

    // private class Nodo{
    //     public Nodo izq;
    //     public Nodo der;
    //     public T dato;

    //     public Nodo(T valor){
    //         this.izq = null;
    //         this.der = null;
    //         this.dato = valor;
    //     }

    //     public T getDato(Nodo nodo){
    //         return nodo.dato;
    //     }
        
    //     public Nodo getIzquierda(Nodo nodo){
    //         return nodo.izq;
    //     }

    //     public Nodo getDerecha(Nodo nodo){
    //         return nodo.der;
    //     }

    //     public void setIzquierda(Nodo padre, Nodo nodIzq){
    //         padre.izq = nodIzq;
    //     }

    //     public void setDerecha(Nodo padre, Nodo nodDer){
    //         padre.der = nodDer;
    //     }
    // }

    // public boolean nivelCompleto(ArbolBinario<T> arbol, int n){
    //     boolean res = true;



    //     return res;
    // }
}
