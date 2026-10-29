import java.util.HashMap;
import java.util.Map;

public class DiccionarioConHistoria<T, V> {
    private Map<T, V> _data;
    private Map<T, Integer> _cant;

    public void nuevoDiccionario(){
        _data = new HashMap<>();
        _cant = new HashMap<>();
    }

    public boolean esta(T clave){
    return _data.containsKey(clave);
    }

    public void definir(T clave, V valor){
        _data.put(clave, valor);
        if(_cant.containsKey(clave)){
            _cant.put(clave, _cant.get(clave) + 1);
        } else if (_cant.containsKey(clave) == false){
            _cant.put(clave, 1);
        }

    }

    public V obtener(T clave){
        return _data.get(clave);
    }

    public void borrar(T clave){
        _data.remove(clave);
        _cant.remove(clave);
    }

    public int cantidadSignificados(T clave){
        return _cant.get(clave);
    }

}
