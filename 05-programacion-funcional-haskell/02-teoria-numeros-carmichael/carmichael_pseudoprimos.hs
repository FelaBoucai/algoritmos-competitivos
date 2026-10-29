--Funcion auxiliar recomendada

esUnCubo :: Integer -> Bool
esUnCubo x = (round (fromIntegral x ** (1/3))) ^ 3 == x

--Esta funcion me da el numero cubo anterior al ingresado por teclado

anteriorCubo :: Integer -> Integer
anteriorCubo n | esUnCubo (n-1) = n-1
               | otherwise      = anteriorCubo (n-1)

--Recibe un valor x por teclado y en y el cubo anterior a x y me dice si la suma de ambos es suma de 2 cubos

esSumaDeDosCubosAux :: (Integer, Integer) -> Bool
esSumaDeDosCubosAux (a,b) | b              == 0          = False
                          | esUnCubo (a-b) && esUnCubo b = True
                          | otherwise                    = esSumaDeDosCubosAux (a, anteriorCubo b)
--EJ 1

esSumaDeDosCubos :: Integer -> Bool
esSumaDeDosCubos x = esSumaDeDosCubosAux (x, anteriorCubo x)

--------------------------------------------------------------------------------

--Dados dos numeros por teclado los compara y me devuelve el valor del numero que elevaria al cubo

valorDelCuboAux :: Integer -> Integer -> Integer
valorDelCuboAux x y | y == (x^3) = x
                    | x ==   0   = undefined
                    | y /= (x^3) = valorDelCuboAux (x-1) y

--Llama a la funcion anterior y solo uso un valor ingresado por teclado

valorDelCubo :: Integer -> Integer
valorDelCubo x = valorDelCuboAux x x

--AGREGAR EXPLICACION

descomposicionCubos2 :: (Integer,Integer) -> (Integer,Integer)
descomposicionCubos2 (x,y)  | esUnCubo(x-y) && esUnCubo y = ((valorDelCubo (x-y)),(valorDelCubo y))
                            | esUnCubo(x-y) == False      = undefined
                            | otherwise                   = descomposicionCubos2 (x, anteriorCubo y)

--EJ 2

descomposicionCubos :: Integer -> (Integer,Integer)
descomposicionCubos 0 = undefined
descomposicionCubos 1 = undefined
descomposicionCubos x = descomposicionCubos2 (x,(x-1))

--------------------------------------------------------------------------------

--Ingreso 2 numeros por teclado x = el primero , y = numero anterior al primero y me devuelve la cantidad de formas en que x se escribe como suma de cubos

cantidadDeFormasAux :: (Integer,Integer) -> Integer
cantidadDeFormasAux (x,y) | (x-y)          > y          = 0
                          | esUnCubo(x-y) && esUnCubo y = 1 + (cantidadDeFormasAux (x, anteriorCubo y))
                          | otherwise                   = cantidadDeFormasAux (x, anteriorCubo y)

--EJ 3

cantidadDeFormas :: Integer -> Integer
cantidadDeFormas x = cantidadDeFormasAux (x, (x-1))

--------------------------------------------------------------------------------

--Dado un numero me dice si este es especial o no (puedan escribirse como suma de 2 cubos de AL MENOS 2 formas dif)

esEspecial :: Integer -> Bool
esEspecial x | cantidadDeFormasAux (x, x-1)  >= 2 = True
             | cantidadDeFormasAux (x, x-1)   < 2 = False

--EJ 4

especialDesde :: Integer -> Integer
especialDesde x | esEspecial x =  x
                | otherwise    = especialDesde (x+1)
--------------------------------------------------------------------------------

{- x (Lugar del número especial), z (variable que aumenta cuando la funcion pasa por un número especial)
hay 2 guardas recursivas, si y es "especial" y si no lo es.
1) si y es especial entonces vuelve a aplicar la funcion pero con (y+1) (z+1)
primero el (y+1) es para que siga buscando el siguiente numero especial
y el (z+1) cuenta que pasó por un numero especial.
2) si y no es especial hace la misma recursion pero mantiene z (no suma 1 al contador de números especiales)
cuando z == x significa que este es el lugar del numero especial (y)
ponemos (y-1) para anular la última recursion en y de la función.-}

contarEspecial :: Integer -> Integer -> Integer -> Integer
contarEspecial x y z | z            == x     = (y-1)
                     | esEspecial y == True  = contarEspecial x (y+1) (z+1)
                     | esEspecial y == False = contarEspecial x (y+1) z

--EJ 5

{-Aplica la funcion contarEspecial x 1 0, así arranca desde el primer numero y (1)
Ademas, el contador z arranca en cero (0). x es el lugar del número especial.-}

especialNumero :: Integer -> Integer
especialNumero x = contarEspecial x 1 0

--------------------------------------------------------------------------------

{-Lo que hace es que a partir de x (el numero que queremos ver si es Muy Especial)
busca si es el resultado entre la multiplicacion de un cubo (y^3) y un numero especial (especialNumero z)
primero prueba con el primer numero especial (especialNumero 1) y aplica la recursion en y hasta que supera el valor de x
si x es mayor a la multiplicacion prueba con el segundo numero especial (especialNumero z+1) y arranca de vuelta con y=2
asi sucesivamente hasta que x = especialNumero z (entonces es Muy Especial) o que de resultado de la multiplicación (no es un número muy especial)
Para que todo funcione, lo primero que prueba es si x es especial (esEspecial x == False = False). -}

especialBase :: Integer-> Integer-> Integer -> Bool
especialBase x y z | esEspecial x == False                  = False
                   | x            == especialNumero z       = True
                   | x            == y^3 * especialNumero z = False
                   | x             > y^3 * especialNumero z = especialBase x (y+1) z
                   | x             < y^3 * especialNumero z = especialBase x 2 (z+1)

--EJ 6

{-aplica la funcion "especialBase x 2 1". Así prueba con y=2 (primer cubo) y z=1 (primer número especial)
y de esta manera pasa por todos los casos posibles.-}

esMuyEspecial :: Integer -> Bool
esMuyEspecial x = especialBase x 2 1

{-
esMuyEspecial:: Integer -> Bool
esMuyEspecial x = esMuyEspecialAux (x, x-1)

esMuyEspecialAux :: (Integer, Integer) -> Bool
esMuyEspecialAux (a,b) | b == 0 = False
                       | esEspecial (a*b) && not (esUnCubo b) = True
                       | otherwise = esMuyEspecialAux (a, b-1) -}
