package aed;

import java.util.*;

public class ListaEnlazada<T> implements Secuencia<T> {
    private int _length;
    private Nodo primero;
    private Nodo ultimo;

    private class Nodo {
        T valor;
        Nodo sig;
        Nodo ant;

        Nodo(T v){
            valor = v; 
        }
    }

    public ListaEnlazada() {
        primero = null;
        ultimo = null;
    }

    public int longitud() {
        return this._length;
    }

    public void agregarAdelante(T elem) {
        Nodo nuevo = new Nodo(elem);
        _length++;
        if (primero != null){
            primero.ant = nuevo;
        } else {
            ultimo = nuevo;
        }
        nuevo.sig = primero;
        primero = nuevo;
    }

    public void agregarAtras(T elem) {
        Nodo nuevo = new Nodo(elem);
        _length ++;
        if (ultimo != null){
            ultimo.sig = nuevo;
        } else {
            primero = nuevo;
        }
        nuevo.ant = ultimo;
        ultimo = nuevo;
    }

    public T obtener(int i) {
        int j = 0;
        Nodo res = primero;
        while (j != i){
            res = res.sig;
            j++;
        }
        return res.valor;
    }

    public void eliminar(int i) {
        int j = 0;
        Nodo res = primero;
        if (i == 0){
            primero = primero.sig;
        } else if (i == _length - 1){
            ultimo = ultimo.ant;
        } else {
            while (j != i){
            res = res.sig;
            j++;
        }
        res.ant.sig = res.sig;
        res.sig.ant = res.ant;
        }
        _length--;
    }

    public void modificarPosicion(int indice, T elem) {
        int j = 0;
        while (j != indice){
            primero = primero.sig;
            j++;
        }
        primero.valor = elem;
        while(j != 0){
            primero = primero.ant;
            j--;
        }
    }

    public ListaEnlazada<T> copiar() {
        return new ListaEnlazada<>(this);
    }

    public ListaEnlazada(ListaEnlazada<T> lista) {
        int i = 0;
        while (i < lista._length){
            agregarAtras(lista.obtener(i));
            i++;
        }
    }
    
    @Override
    public String toString() {
        String res = "[";
        while (primero.sig != null){
            res = res + primero.valor + ", ";
            primero = primero.sig;
        }
        res = res + primero.valor + "]";
        return res;
    }

    private class ListaIterador implements Iterador<T> {
        private int i = 0;

        
        public boolean haySiguiente() {
            return i < _length;
        }
        
        public boolean hayAnterior() {
            return i > 0;
        }

        public T siguiente(){
            T res = obtener(i);
            i++;
            return res;
        }
        
        
        public T anterior() {
            i--;       
            T res = obtener(i);
            return res;
        }
    }

    public Iterador<T> iterador() {
        return new ListaIterador();
    }

}
