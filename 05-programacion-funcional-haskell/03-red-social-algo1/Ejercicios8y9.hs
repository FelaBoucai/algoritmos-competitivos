module Ejercicios8y9 where

-- Completar con los datos del grupo
--
-- Nombre de Grupo: xx
-- Integrante 1: Samuel Furlanich, samuelfurlanich@gmail.com, 61/23
-- Integrante 2: Nombre Apellido, email, LU
-- Integrante 3: Nombre Apellido, email, LU
-- Integrante 4: Nombre Apellido, email, LU

type Usuario = (Integer, String) -- (id, nombre)
type Relacion = (Usuario, Usuario) -- usuarios que se relacionan
type Publicacion = (Usuario, String, [Usuario]) -- (usuario que publica, texto publicacion, likes)
type RedSocial = ([Usuario], [Relacion], [Publicacion])

-- Funciones basicas

usuarios :: RedSocial -> [Usuario]
usuarios (us, _, _) = us

relaciones :: RedSocial -> [Relacion]
relaciones (_, rs, _) = rs

publicaciones :: RedSocial -> [Publicacion]
publicaciones (_, _, ps) = ps

idDeUsuario :: Usuario -> Integer
idDeUsuario (id, _) = id 

nombreDeUsuario :: Usuario -> String
nombreDeUsuario (_, nombre) = nombre 

usuarioDePublicacion :: Publicacion -> Usuario
usuarioDePublicacion (u, _, _) = u

likesDePublicacion :: Publicacion -> [Usuario]
likesDePublicacion (_, _, us) = us

-- Ejercicios

--1)
nombresDeUsuarios :: RedSocial -> [String]
nombresDeUsuarios (usuarios, _, _) = proyectarNombres usuarios

proyectarNombres :: [Usuario] -> [String]
proyectarNombres [] = []
proyectarNombres ((x,y):xs) = y:proyectarNombres xs

--2)
amigosDe :: RedSocial -> Usuario -> [Usuario]
amigosDe (_, [], _) _ = []
amigosDe (_, r:rs, _) u | u == fst r = snd r : amigosDe ([], rs, []) u
                        | u == snd r = fst r : amigosDe ([], rs, []) u
                        | otherwise  = amigosDe ([], rs, []) u

-- describir qué hace la función: .....
cantidadDeAmigos :: RedSocial -> Usuario -> Int
cantidadDeAmigos = undefined

-- describir qué hace la función: .....
usuarioConMasAmigos :: RedSocial -> Usuario
usuarioConMasAmigos = undefined

-- describir qué hace la función: .....
estaRobertoCarlos :: RedSocial -> Bool
estaRobertoCarlos = undefined

-- describir qué hace la función: .....
publicacionesDe :: RedSocial -> Usuario -> [Publicacion]
publicacionesDe = undefined

-- describir qué hace la función: .....
publicacionesQueLeGustanA :: RedSocial -> Usuario -> [Publicacion]
publicacionesQueLeGustanA = undefined

--8)

--Mini 7)
miniPublicacionesQueLeGustanA :: RedSocial -> Usuario -> [Publicacion]
miniPublicacionesQueLeGustanA (_, _, []) u = []
miniPublicacionesQueLeGustanA (_, _, publicacion:publicaciones) usuario | pertenece usuario (trd publicacion) = publicacion : miniPublicacionesQueLeGustanA ([], [], publicaciones) usuario
                                                                        | otherwise                           = miniPublicacionesQueLeGustanA ([], [], publicaciones) usuario

--Dados dos usuarios de una misma red social devuelve un booleano indicando si ambos le dieron like a las mismas publicaciones
lesGustanLasMismasPublicaciones :: RedSocial -> Usuario -> Usuario -> Bool
lesGustanLasMismasPublicaciones red usuario1 usuario2 = mismosElementos (miniPublicacionesQueLeGustanA red usuario1) (miniPublicacionesQueLeGustanA red usuario2) 

--9)

--Mini 6)
miniPublicacionesDe :: RedSocial -> Usuario -> [Publicacion]
miniPublicacionesDe (_, _, []) _ = []
miniPublicacionesDe (_, _, publicacion:publicaciones) usuario   | usuarioDePublicacion publicacion == usuario   = publicacion : miniPublicacionesDe ([], [], publicaciones) usuario
                                                                | otherwise                                     = miniPublicacionesDe ([], [], publicaciones) usuario

--Dada una red social y un usuario de esta devuelve un booleano indicando si existe otro usuario de la red que le haya dado me gusta a todas las publicaciones del primer usuario.
--Tambien devuelve falso si el usuario no tiene publicaciones hechas.
tieneUnSeguidorFiel :: RedSocial -> Usuario -> Bool
tieneUnSeguidorFiel (usuarios, _, publicaciones) usuario | null publicacionesUsuario    = False
                                                         | otherwise                    = tieneUnSeguidorFielAux (quitarElemento usuario usuarios) publicacionesUsuario
                                                         where publicacionesUsuario     = miniPublicacionesDe ([], [], publicaciones) usuario

--Funcion auxiliar para computar tieneUnSeguidorFiel. Es necesaria para poder iterar por todas las publicaciones del usuario sin redefenir tieneUnSeguidorFiel
tieneUnSeguidorFielAux :: [Usuario] -> [Publicacion] -> Bool
tieneUnSeguidorFielAux usuarios [] = not(null usuarios)
tieneUnSeguidorFielAux usuarios (publicacion:publicaciones) | null likesPublicacionesEnComun   = False
                                                            | otherwise                        = tieneUnSeguidorFielAux likesPublicacionesEnComun publicaciones
                                                            where likesPublicacionesEnComun    = interseccion (likesDePublicacion publicacion) usuarios

-- describir qué hace la función: .....
existeSecuenciaDeAmigos :: RedSocial -> Usuario -> Usuario -> Bool
existeSecuenciaDeAmigos = undefined

--Helpers--

--Devuelve un booleano indicando si un elemento t pertenece a una lista
pertenece :: (Eq t) => t -> [t] -> Bool
pertenece _ [] = False
pertenece elementoBuscado (elementoActual:elementos)        | elementoBuscado == elementoActual     = True
                                                            | otherwise                             = pertenece elementoBuscado elementos

--Devuelve un booleano indicando si dos listas contienen los mismos elementos independientemente del orden de aparicion de los mismos.
--Requiere: Que no haya elementos repetidos en las listas
mismosElementos :: (Eq t) => [t] -> [t] -> Bool
mismosElementos [] []     = True
mismosElementos [] (b:bs) = False
mismosElementos (elementoLista1:lista1) lista2      | elementoLista1 `pertenece` lista2     = mismosElementos lista1 (quitarElemento elementoLista1 lista2)
                                                    | otherwise                             = False

--Quita exactamente un elemento de una lista sin mantener el orden del resto de elementos.
--Requiere: Que el elemento este en la lista
quitarElemento :: (Eq t) => t -> [t] -> [t]
quitarElemento elemento (elementoActual:elementos) | elemento == elementoActual = elementos
                                                   | otherwise                  = quitarElemento elemento (elementos ++ [elementoActual])

--Computa la interseccion entre dos conjuntos
interseccion :: (Eq t) => [t] -> [t] -> [t]
interseccion [] _ = []
interseccion _ [] = []
interseccion (elementoLista1:lista1) (elementoLista2:lista2)    | elementoLista1 == elementoLista2                          =   elementoLista1 :     interseccion lista1 lista2
                                                                | elementoLista1PerteneceA2 && elementoLista2PerteneceA1    =   elementoLista1 : elementoLista2 : interseccion lista1 lista2
                                                                | elementoLista1PerteneceA2                                 =   elementoLista1 :     interseccion lista1 lista2
                                                                | elementoLista2PerteneceA1                                 =   elementoLista2 :     interseccion lista1 lista2
                                                                | otherwise                                                 =   interseccion lista1 lista2
                                                                where   elementoLista1PerteneceA2 = elementoLista1 `pertenece` lista2
                                                                        elementoLista2PerteneceA1 = elementoLista2 `pertenece` lista1

--Devuelve el tercer elemento de una tupla de tres elementos
trd :: (t, r, s) -> s
trd (_, _, s) = s