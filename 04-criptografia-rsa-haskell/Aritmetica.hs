module Aritmetica where
import Tipos
import Data.Tuple
import Data.Bits


--OPERACIONES PARA TRABAJAR CON CONJUNTOS

vacio :: Set Integer
vacio = []

pertenece :: Integer->Set Integer->Bool
pertenece _ [] = False
pertenece y (x:xs) | y == x = True
                   | otherwise = pertenece y xs

agregar :: Integer->Set Integer->Set Integer
agregar y x | pertenece y x = x
            | otherwise = y:x


--(1)

------Funciones auxiliares---------

menorDivisorDoble :: Integer -> Integer -> Integer
menorDivisorDoble 0 _ = 1
menorDivisorDoble 1 _ = 1
menorDivisorDoble n k | n `mod` k == 0 = k
                      | otherwise      = menorDivisorDoble n (k+1)

menorDivisor :: Integer -> Integer
menorDivisor n = menorDivisorDoble n 2

esPrimo :: Integer -> Bool
esPrimo 1 = False
esPrimo n = n == menorDivisor n

----------------------------------

--FUNCION PRINCIPAL

criba :: Integer -> Set Integer
criba 0 = []
criba x | esPrimo (x-1) = (x-1) : criba (x-1)
        | otherwise = criba (x-1)

--(2)

------Funciones auxiliares---------

mcd :: Integer -> Integer -> Integer
mcd x 0 = abs x
mcd x y = mcd y (mod x y)

coprimoConDoble :: Integer -> Integer -> Integer
coprimoConDoble n x | n <= 2 = 0
                  | mcd n x == 1 = x
                  | otherwise = coprimoConDoble n (x+1)

----------------------------------

--FUNCION PRINCIPAL

coprimoCon :: Integer -> Integer
coprimoCon n = coprimoConDoble n 2

--(3)

------Funciones auxiliares---------

mcdExt :: Integer -> Integer -> (Integer , Integer , Integer)
mcdExt a b | b > a = mcdExt b a
mcdExt a 0 = (a, 1, 0)
mcdExt a b = (d, t, s-t * k)
         where (k, r) = (div a b, mod a b)
               (d, s, t) = mcdExt b r

esOnoEsCoprimo :: Integer -> Integer -> Bool
esOnoEsCoprimo x y | mcd x y == 1 = True
                   | otherwise = False

tomaValorDeTripla :: (Integer , Integer , Integer) -> Integer
tomaValorDeTripla (x,y,z) = z

tomaValorDemcdExt :: Integer -> Integer -> Integer
tomaValorDemcdExt x y = tomaValorDeTripla (mcdExt x y)

----------------------------------

--FUNCION PRINCIPAL

inversoMultiplicativo:: Integer -> Integer -> Integer
inversoMultiplicativo x y | esOnoEsCoprimo x y == False = undefined
                          | x > y = inversoMultiplicativo y x
                          | tomaValorDemcdExt x y < 0 = tomaValorDemcdExt x y % y
                          | otherwise = tomaValorDemcdExt x y



-- Función de regalo para exponenciar "rápido"

modExp :: Integer -> Integer -> Integer -> Integer
modExp b 0 m = 1
modExp b e m = t * modExp ((b * b) `mod` m) (shiftR e 1) m `mod` m
  where t = if testBit e 0 then b `mod` m else 1
