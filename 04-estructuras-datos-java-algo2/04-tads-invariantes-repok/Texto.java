import java.util.Map;

public class Texto {
    public String[] palabras; //
    private Map<String, Integer[]> _posicionPalabras; //
    private Map<String, Integer>  _repeticionPalabras; //
    private String[] _palabrasMasRepetidas;
    private int _cantMasRepetidas; 
    private int _ultimaPosicion; //
    private int _size; //

    public String[] subtexto(Texto t, int hasta, int desde){
        String[] res = new String[hasta - desde];
        int j = 0;
        for (int i = desde; i <= hasta; i++){
            res [j] = t.palabras[i];
            j++;
        }
        return res;
    }

    public void cambiarPalabra(Texto t, String vieja, String nueva){
        Integer[] indicePalabra = t._posicionPalabras.get(vieja);
        int cantPalabra = t._repeticionPalabras.get(vieja);
        
        for(int i = 0; i <= cantPalabra; i++){
            t.palabras[indicePalabra[i]] = nueva;
        }
    }

    public String[] masRepetidas(Texto t){
        return _palabrasMasRepetidas; 
    }

    public void agregarPalabra(Texto t, String palabra){
        extenderArray(t);
        t.palabras[t._ultimaPosicion] = palabra;
        t._ultimaPosicion = t._ultimaPosicion + 1;

        if(t._repeticionPalabras.containsKey(palabra)){
            t._repeticionPalabras.replace(palabra, t._repeticionPalabras.get(palabra) + 1);
            Integer[] nuevosIndices = new Integer[t._repeticionPalabras.get(palabra)];
            Integer[] indicesPalabra = t._posicionPalabras.get(palabra);

            for(int i = 0; i < t._repeticionPalabras.get(palabra); i++){
                nuevosIndices[i] = indicesPalabra[i];
            }
            nuevosIndices[t._repeticionPalabras.get(palabra)] = t._ultimaPosicion;
            t._posicionPalabras.replace(palabra, nuevosIndices);

            if(t._repeticionPalabras.get(palabra) > t._repeticionPalabras.get(t._palabrasMasRepetidas[0])){
                String[] nuevoPalabrasMasRepetidas = new String[1];
                nuevoPalabrasMasRepetidas[0] = palabra;
                t._palabrasMasRepetidas = nuevoPalabrasMasRepetidas;
                t._cantMasRepetidas = 1;

            } else if(t._repeticionPalabras.get(palabra) == t._repeticionPalabras.get(t._palabrasMasRepetidas[0])){
                String[] nuevoPalabrasMasRepetidas = new String[t._cantMasRepetidas + 1];
                for(int i = 0; i <= t._cantMasRepetidas; i++){
                    nuevoPalabrasMasRepetidas[i] = t._palabrasMasRepetidas[i];
                }
                nuevoPalabrasMasRepetidas[t._cantMasRepetidas + 1] = palabra;
                t._cantMasRepetidas = t._cantMasRepetidas + 1;
                t._palabrasMasRepetidas = nuevoPalabrasMasRepetidas;
            }

        }else if(t._repeticionPalabras.containsKey(palabra) == false){
            Integer[] nuevosIndices = new Integer[1];
            nuevosIndices[0] = t._ultimaPosicion;
            t._posicionPalabras.put(palabra, nuevosIndices);
            t._repeticionPalabras.put(palabra, 1);

            if(t._palabrasMasRepetidas[0] == null){
                String[] nuevoPalabrasMasRepetidas = new String[1];
                nuevoPalabrasMasRepetidas[0] = palabra;
                t._palabrasMasRepetidas = nuevoPalabrasMasRepetidas;
            }


        }



    }

    private void extenderArray(Texto t){
        if (t._ultimaPosicion ==t._size){
            String[] arrayExtendido = new String[t._size * 2];
            for (int i = 0; i < t._size; i++) {
                arrayExtendido[i] = t.palabras[i];
            }
            t.palabras = arrayExtendido;
            t._size = t._size * 2;
        }
    }
}

