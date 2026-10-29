package aed;

import java.util.*;

// Todos los tipos de datos "Comparables" tienen el método compareTo()
// elem1.compareTo(elem2) devuelve un entero. Si es mayor a 0, entonces elem1 > elem2
public class ABB<T extends Comparable<T>> implements Conjunto<T> {
    private Nodo _raiz;
    private int _size;

    private class Nodo {
        public T valor;
        public Nodo der;
        public Nodo izq;
        public Nodo pad;

        Nodo(T v){
            valor = v;
            der = null;
            izq = null;
            pad = null;
        }
    }

    public ABB() {
        _raiz = null;
        _size = 0;
    }

    public int cardinal() {
        return _size;
    }

    public T minimo(){
        Nodo res = _raiz;
        while (res.izq != null) {
            res = res.izq;
        }
        return res.valor;
    }

    private Nodo nodoMinimo(Nodo res){
        while (res.izq != null) {
            res = res.izq;
        }
        return res;
    }

    public T maximo(){
        Nodo res = _raiz;
        while (res.der != null) {
            res = res.der;
        }
        return res.valor;
    }

    private Nodo nodoMaximo(Nodo res){
        while (res.der != null) {
            res = res.der;
        }
        return res;
    }  

    public void insertar(T elem){
        if (pertenece(elem)==true){
        return;              
        } 
        _size++;
        Nodo actual = _raiz;
        if(actual == null){
            _raiz = new Nodo(elem);
        }else {
            while((actual.izq != null && actual.valor.compareTo(elem) > 0) || (actual.der != null && actual.valor.compareTo(elem) < 0)){
                if(actual.valor.compareTo(elem) > 0){
                    actual = actual.izq;
                }else{
                    actual = actual.der;
                }
                }
            
            if (actual.valor.compareTo(elem) > 0){
            actual.izq = new Nodo(elem);
            actual.izq.pad = actual;
            }else {
            actual.der = new Nodo(elem);
            actual.der.pad = actual;
            }
        }
        } 

    public boolean pertenece(T elem){
        return perteneceRecursivo(_raiz, elem);
    }

    private boolean perteneceRecursivo(Nodo nodo, T elem){
        if (nodo == null){
            return false;
        }
        if (nodo.valor.compareTo(elem) == 0){
            return true;
        }
        if (nodo.valor.compareTo(elem) > 0){
            return perteneceRecursivo(nodo.izq, elem);
        } else {
            return perteneceRecursivo(nodo.der, elem);
        }
    }

    private Nodo buscarNodo(Nodo nodo, T elem){
        while(nodo != null && nodo.valor.compareTo(elem) != 0){
            if (nodo.valor.compareTo(elem) > 0){
                nodo = nodo.izq;
            } else {
                nodo = nodo.der;
            }
        }
        return nodo;
    }

    private void eliminarHijo(Nodo padre, Nodo hijo){
        if (padre.izq == hijo){
            padre.izq = null;
        } else if(padre.der == hijo) {
            padre.der = null;
        }
    }

    public void eliminar(T elem){
        Nodo nodo = buscarNodo(_raiz, elem);
        if(nodo == null){
            return;
        }
        _size--;
        if(nodo.der == null && nodo.izq == null){
            if (nodo == _raiz){
                // El nodo es la raíz y hoja.
                _raiz = null;
            }else{
                // El nodo es una hoja.
                eliminarHijo(nodo.pad, nodo);
            }

        } else if(nodo.izq != null){
            // El nodo tiene descendencia izquierda.
            Nodo antecesorInmediato;
            antecesorInmediato = nodoMaximo(nodo.izq);

            nodo.valor = antecesorInmediato.valor;
            
            while(antecesorInmediato.izq != null){
                antecesorInmediato.valor = antecesorInmediato.izq.valor;
                if (antecesorInmediato.izq.der != null){
                    antecesorInmediato.izq.der.pad = antecesorInmediato;
                }
                antecesorInmediato.der = antecesorInmediato.izq.der;
                antecesorInmediato = antecesorInmediato.izq;
            }

            eliminarHijo(antecesorInmediato.pad, antecesorInmediato);

        } else if(nodo.der != null){
            // El nodo tiene descendencia derecha.
            Nodo sucesorInmediato;
            sucesorInmediato = nodoMinimo(nodo.der);

            nodo.valor = sucesorInmediato.valor;
            
            while(sucesorInmediato.der != null){
                sucesorInmediato.valor = sucesorInmediato.der.valor;
                if (sucesorInmediato.der.izq != null){
                    sucesorInmediato.der.izq.pad = sucesorInmediato;
                }
                sucesorInmediato.izq = sucesorInmediato.der.izq;
                sucesorInmediato = sucesorInmediato.der;
            }

            eliminarHijo(sucesorInmediato.pad, sucesorInmediato);
        }
    }
    
    @Override
    public String toString(){
        Iterador<T> it = new ABB_Iterador();
        String res = "{";
        while (it.haySiguiente() == true){
            res = res + it.siguiente() + ",";
        }
        return res + it.siguiente() + "}";
    }

    private class ABB_Iterador implements Iterador<T> {
        private Nodo _actual = nodoMinimo(_raiz);

        public boolean haySiguiente() {    
            Nodo verificar = _actual;

            if(verificar.der != null){
                return true;
            }else{
                while (verificar.pad != null && verificar == verificar.pad.der){
                verificar = verificar.pad;
            }
            return (verificar.pad != null);
            }
        }
    
        public T siguiente() {
            T valor = _actual.valor;
            if (haySiguiente() == true){
                if (_actual.der != null){
                    _actual = nodoMinimo(_actual.der);
                }else if(_actual.der == null){
                    while (_actual == _actual.pad.der){
                        _actual = _actual.pad;
                    }
                    _actual = _actual.pad;
                }
            }
            return valor;
        }
    }

    public Iterador<T> iterador() {
        return new ABB_Iterador();
    }

}
