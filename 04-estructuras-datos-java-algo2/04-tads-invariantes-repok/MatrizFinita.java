public class MatrizFinita {
    private int[][] _matriz;
    private int _columnas;
    private int _filas;

    public void crear(int filas, int columnas){
        _filas = filas;
        _columnas = columnas;
        _matriz = new int[columnas][filas];
    }

    public void definir(int valor, int columna, int fila){
        if (_columnas < columna || fila < _filas){
            return;
        }
        _matriz[columna][fila] = valor;
    }

    public int filas(){
        return _filas;
    }

    public int columnas(){
        return _columnas;
    }

    public int obtener(int columna, int fila){
        return _matriz[columna][fila];
    }

    public int[][] SumarMatrices(MatrizFinita m1, MatrizFinita m2){
        int[][] res = new int[m1._columnas][m1._filas];
        for(int i = 0; i < m1._columnas; i++){
            for(int j = 0; j < m1._filas; j++){
                res[i][j] = m1._matriz[i][j] + m2._matriz[i][j];
            }
        }
        return res;
    }
}
