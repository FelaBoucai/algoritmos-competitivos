package aed;

public class HeapSort{

    public static int contador = 0;

    public static Router[] sort(Router[] fragments){
        Router[] result = new Router[fragments.length];
        heapify(fragments);
        Heap heap = new Heap(fragments);    
        for(int i = 0; i < fragments.length; i++){
            result[i] = heap.desencolar();
        }
        return result;
    }

    public static void heapify(Router[] fragments){
        for(int i = fragments.length / 2 - 1; i >= 0; i--){
            heapifyInterno(i, fragments);
        }
    }

    private static void heapifyInterno(int indice, Router[] fragments){
        while(indice * 2 + 1 < fragments.length){
            Router subIzq = fragments[indice * 2 + 1];
            Router subDer = indice * 2 + 2 < fragments.length ? fragments[indice * 2 + 2] : null;
            if(fragments[indice].compareTo(subIzq) < 0 || (subDer != null && fragments[indice].compareTo(subDer) < 0)){
                contador++;
                if(subDer != null && subIzq.compareTo(subDer) < 0){
                    fragments[indice * 2 + 2] = fragments[indice];
                    fragments[indice] = subDer;
                    indice = indice * 2 + 2;
                }else{
                    fragments[indice * 2 + 1] = fragments[indice];
                    fragments[indice] = subIzq;
                    indice = indice * 2 + 1;
                }
            }
            else{
                break;
            }
        }
    }
}