module RSA where
import Tipos
import Aritmetica


--(4)

--FUNCION PRINCIPAL

claves :: Integer -> Integer -> (Integer, Integer, Integer)
claves p q = (coprimoCon m, inversoMultiplicativo (coprimoCon m) m,(p*q))
             where m = (p-1)*(q-1)

--(5)

------Funciones auxiliares---------

codificadorIntAux :: Clpub -> Integer -> Integer
codificadorIntAux (e,n) x | mcd x n == 1 = modExp x e n
                          | otherwise = -x

codificadorInt :: Clpub -> [Integer] -> Cifrado
codificadorInt p [] = []
codificadorInt p (x:xs) = codificadorIntAux p x : codificadorInt p xs

----------------------------------

--FUNCION PRINCIPAL

codificador :: Clpub -> Mensaje -> Cifrado
codificador p x = codificadorInt p (aEnteros x)

--(6)

------Funciones auxiliares---------
decodificadorIntAux :: Clpri -> Integer -> Integer
decodificadorIntAux (d,n) x | x >= 0 = modExp x d n
                            | otherwise = -x

decodificadorInt :: Clpri -> [Integer] -> [Integer]
decodificadorInt r [] = []
decodificadorInt r (x:ms) = decodificadorIntAux r x : decodificadorInt r ms

--FUNCION PRINCIPAL

decodificador :: Clpri -> Cifrado -> Mensaje
decodificador r x = aChars (decodificadorInt r x)
