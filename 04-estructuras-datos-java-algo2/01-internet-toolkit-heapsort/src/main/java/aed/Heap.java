package aed;

public class Heap{

        private Router[] _heap;
        private int _size;

        public Heap(Router[] heap){
            _heap = heap;
            _size = _heap.length;
        }

        public Router desencolar(){
            Router top = _heap[0];
            _heap[0] = _heap[--_size];
            int indice = 0;
            Router subMasGrande = getSubMasGrande(indice);
            Router fragmentoActual = _heap[indice];
            while(subMasGrande != null && (fragmentoActual == null || fragmentoActual.compareTo(subMasGrande) < 0)){     
                int subIndice = esSubIzq(indice, subMasGrande) ? indice * 2 + 1 : indice * 2 + 2;
                _heap[subIndice] = fragmentoActual;
                _heap[indice] = subMasGrande;
                indice = subIndice;

                subMasGrande = getSubMasGrande(indice);
            }
            return top;
        }

        private Router getSubMasGrande(int indice){
            Router subIzq = _size > indice * 2 + 1 ? _heap[indice * 2 + 1] : null;
            Router subDer = _size > indice * 2 + 2 ? _heap[indice * 2 + 2] : null;
            Router subMasGrande = subIzq != null ? (subDer != null ? (subIzq.compareTo(subDer) < 0 ? subDer : subIzq) : subIzq) : null;

            return subMasGrande;
        }

        private boolean esSubIzq(int indice, Router f){
            return indice * 2 + 1 < _size && _heap[indice * 2 + 1] == f;
        }
    }
