public class MatrizInfinita{
    private Columnas[] _columnas;
    private int _tamaño;
    private boolean _invertida;


    private class Columnas{
        public int[] _filas;
        public int _tamañofilas;

        public Columnas(){
            _filas = null;
            _tamañofilas = 1;
        }
    }

    public void crear(){
        _columnas = null;
        _tamaño = 1;
        _invertida = false;
    }

    private void comprobarTamaño(MatrizInfinita m, int c, int f){
        if (m._tamaño < c){
            Columnas[] nuevoArray = new Columnas[c];
            for (int i = 0; i < _tamaño; i++){
                nuevoArray[i] = m._columnas[i];
            }
            m._tamaño = c;
            m._columnas = nuevoArray;
        }
        if (m._columnas[c]._tamañofilas < f){
            int[] nuevoArray = new int[f];
            for (int i = 0; i < m._columnas[c]._tamañofilas; i++){
                nuevoArray[i] = m._columnas[c]._filas[i];
            }
            m._columnas[c]._tamañofilas = f;
            m._columnas[c]._filas = nuevoArray;
        }
   }

    public void asignar(MatrizInfinita m, int c, int f, boolean v){
        if (v == true){
            comprobarTamaño(m, c, f);
            m._columnas[c]._filas[f] = f;
        } 
    }

    public void complementar(){
        _invertida = true;
    }


    public boolean ver(MatrizInfinita m, int c, int f){
        boolean res;
        if (m._invertida == false){
            res = true;
            if(m._tamaño < c || m._columnas[c]._tamañofilas < f || m._columnas[c]._filas[f] == 0){
                res = false;
            }
        } else{
            res = false;
            if(m._tamaño < c || m._columnas[c]._tamañofilas < f || m._columnas[c]._filas[f] == 0){
                res = true;
            }
        }
        return res;
    }

    
}