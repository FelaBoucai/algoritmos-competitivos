module Solucion where

-- Completar con los datos del grupo
--
-- Nombre de Grupo: Felicky-EVC
-- Integrante 1: Samuel Furlanich, samuelfurlanich@gmail.com, 61/23
-- Integrante 2: Felipe Adrián Boucai, felaaboucai@gmail.com, 1342/21
-- Integrante 3: Victoria Rauch, vickyrauh@gmail.com, 1181/21
-- Integrante 4: Scirica Carlos Ignacio, igna88856@gmail.com, 35/23

type Usuario            = (Integer, String) -- (id, nombre)
type Relacion           = (Usuario, Usuario) -- usuarios que se relacionan
type Publicacion        = (Usuario, String, [Usuario]) -- (usuario que publica, texto publicacion, likes)
type RedSocial          = ([Usuario], [Relacion], [Publicacion])

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
--Devuelve una lista de nombres de usuarios que pertenecen a una red social.
nombresDeUsuarios :: RedSocial -> [String]
nombresDeUsuarios (usuarios, _, _) = proyectaNombresSinRepetir (proyectarNombres usuarios) []

proyectarNombres :: [Usuario] -> [String]
proyectarNombres [] = []
proyectarNombres ((id, nombre):usuarios) = nombre : proyectarNombres usuarios

--Función auxiliar que devuelve una lista con los nombres de los usuarios dados, sin repetir aquellos nombres repetidos entre usuarios.
proyectaNombresSinRepetir :: [String] -> [String] -> [String]
proyectaNombresSinRepetir [] _ = []
proyectaNombresSinRepetir (nombre:nombres) nombresNORepetidos   | nombre `elem` nombresNORepetidos = proyectaNombresSinRepetir nombres nombresNORepetidos
                                                                | otherwise = nombre : proyectaNombresSinRepetir nombres (nombre : nombresNORepetidos)

--2)
--Devuelve una lista con los amigos del usuario especificado.
amigosDe :: RedSocial -> Usuario -> [Usuario]
amigosDe (_, [], _) _ = []
amigosDe (usuarios, relacion:relaciones, publicaciones) usuario | usuario == fst relacion = snd relacion : amigosDe ([], relaciones, []) usuario
                                                                | usuario == snd relacion = fst relacion : amigosDe ([], relaciones, []) usuario
                                                                | otherwise  = amigosDe (usuarios, relaciones, publicaciones) usuario

--3)
--Devuelve el numero de amigos de un usuario.
cantidadDeAmigos :: RedSocial -> Usuario -> Int
cantidadDeAmigos (usuarios, relaciones, publicaciones) usuario = cantidadElementos (amigosDe (usuarios, relaciones, publicaciones) usuario)

--4)
--Dada una red social, devuelve el usuario con el mayor numero de amigos en dicha red social.
usuarioConMasAmigos :: RedSocial -> Usuario
usuarioConMasAmigos (usuarios,relaciones,publicaciones) = usuarioConMasRelaciones (usuarios,relaciones,publicaciones) (usuarios, juntarCantidadRelaciones (usuarios,relaciones,publicaciones)) 

--Funcion auxiliar que devuelve una lista cuyos elementos seran la cantidad de relaciones existentes por usuario.
juntarCantidadRelaciones :: RedSocial -> [Int]
juntarCantidadRelaciones (usuarioActual:usuarios,relaciones,publicaciones)  | cantidadElementos usuarios == 0 = [cantidadDeAmigos (usuarioActual:usuarios,relaciones,publicaciones) usuarioActual]
                                                                            | otherwise = cantidadDeAmigos (usuarioActual:usuarios,relaciones,publicaciones) usuarioActual : juntarCantidadRelaciones (usuarios,relaciones,publicaciones) 

--Funcion Auxiliar para que dada una red social y un tupla de una lista de usuarios y una lista de enteros, devuelve el usuario cuyo indice coincide con el indice de maximo elemento de la lista de enteros.
--([Usuario], [Int]]) por cada usuario en la lista del primer elemento, existe una entero en el mismo indice para lista del segundo elemento. Dicho numero entero representa la cantidad de relaciones del usuario asociado al mismo indice.
usuarioConMasRelaciones :: RedSocial -> ([Usuario], [Int]) -> Usuario  
usuarioConMasRelaciones redSocial (usuarioActual:usuarios,numeroDeRelaciones)   | cantidadElementos usuarios == 0 = usuarioActual
                                                                                | cantidadDeAmigos redSocial usuarioActual == maximo numeroDeRelaciones = usuarioActual 
                                                                                | otherwise = usuarioConMasRelaciones redSocial (usuarios,numeroDeRelaciones)

{-
usuarioConMasAmigos :: RedSocial -> Usuario
usuarioConMasAmigos (usuario:usuarios,relaciones,publicaciones) | null usuarios = usuario
                                                                | cantidadDeAmigos (usuarios, relaciones, publicaciones) usuario > cantidadDeAmigos (usuarios, relaciones, publicaciones) usuarioConMasAmigosActual = usuario
                                                                | otherwise = usuarioConMasAmigosActual
                                                                 where usuarioConMasAmigosActual = usuarioConMasAmigos (usuarios, relaciones, publicaciones)
-}

--5)
--Verifica si el usuario con mas amigos tiene mas de un millón de amigos.
estaRobertoCarlos :: RedSocial -> Bool
estaRobertoCarlos red = cantidadDeAmigos red (usuarioConMasAmigos red) > 10

--6)
--Dado un usuario devuelve una lista de sus publicaciones.
publicacionesDe :: RedSocial -> Usuario -> [Publicacion]
publicacionesDe (_, _, []) _ = []
publicacionesDe (_, _, publicacion:publicacions) usuario | usuario == usuarioDePublicacion publicacion = publicacion : publicacionesDe ([], [], publicacions) usuario
                                                         | otherwise = publicacionesDe ([], [], publicacions) usuario

--7)
--Dado un usuario devuelve la lista de publicaciones a las cuales le dio me gusta.
publicacionesQueLeGustanA :: RedSocial -> Usuario -> [Publicacion]
publicacionesQueLeGustanA (_, _, []) usuario = []
publicacionesQueLeGustanA (_, _, publicacion:publicacions) usuario | pertenece usuario (trd publicacion) = publicacion : publicacionesQueLeGustanA ([], [], publicacions) usuario
                                                                   | otherwise = publicacionesQueLeGustanA ([], [], publicacions) usuario

--8)
--Dados dos usuarios de una misma red social devuelve un booleano indicando si ambos le dieron like a las mismas publicaciones.
lesGustanLasMismasPublicaciones :: RedSocial -> Usuario -> Usuario -> Bool
lesGustanLasMismasPublicaciones red usuario1 usuario2 = mismosElementos (publicacionesQueLeGustanA red usuario1) (publicacionesQueLeGustanA red usuario2)

--9)
--Dada una red social y un usuario de esta devuelve un booleano indicando si existe otro usuario de la red que le haya dado me gusta a todas las publicaciones del primer usuario.
--También devuelve falso si el usuario no tiene publicaciones hechas.
tieneUnSeguidorFiel :: RedSocial -> Usuario -> Bool
tieneUnSeguidorFiel (usuarios, relaciones, publicaciones) usuario | null publicacionesUsuario = False
                                                                  | otherwise                 = tieneUnSeguidorFielAux (quitarElemento usuario usuarios) publicacionesUsuario
                                                                  where publicacionesUsuario  = publicacionesDe (usuarios, relaciones, publicaciones) usuario

--Función auxiliar para computar tieneUnSeguidorFiel. Es necesaria para poder iterar por todas las publicaciones del usuario sin redefinir tieneUnSeguidorFiel.
tieneUnSeguidorFielAux :: [Usuario] -> [Publicacion] -> Bool
tieneUnSeguidorFielAux usuarios [] = not(null usuarios)
tieneUnSeguidorFielAux usuarios (publicacion:publicacions) | null likesEnComun = False
                                                           | otherwise         = tieneUnSeguidorFielAux likesEnComun publicacions
                                                            where likesEnComun = interseccion (likesDePublicacion publicacion) usuarios

--10)
--Dada una red social y dos usuarios distintos pertenecientes a dicha red social, devuelve un booleano indicando si existe una relacion consecutiva desde el primer usuario hasta el segundo
existeSecuenciaDeAmigos :: RedSocial -> Usuario -> Usuario -> Bool
existeSecuenciaDeAmigos (usuarios, relaciones, publicaciones) usuario1 usuario2 | pertenece usuario2 (amigosDe (usuarios, relaciones, publicaciones) usuario1) = True
                                                                                | pertenece usuario2 (amigosDeAmigos (usuarios, relaciones, publicaciones) (amigosDe (usuarios, relaciones, publicaciones) usuario1)) = True
                                                                                | otherwise = False

--Función auxiliar para obtener una lista con todos los usuarios relacionados entre si.
--Devuelve una lista de usuarios basada en todos los usuarios que son amigos del parametro usuario o amigos con los usuarios relacionados a este ultimo.
amigosDeAmigos :: RedSocial -> [Usuario] -> [Usuario]
amigosDeAmigos _ [] = []
amigosDeAmigos (usuarios, relaciones, publicaciones) (amigo:amigos) = amigosDe (usuarios, relaciones, publicaciones) amigo ++ amigosDeAmigos (usuarios, relaciones, publicaciones) amigos

-- //////////////////////////////// HELPERS ////////////////////////////////

--Devuelve el numero de elementos de una lista generica.
cantidadElementos :: [t] -> Int
cantidadElementos [] = 0
cantidadElementos (_:elementos) = 1 + cantidadElementos elementos

--Devuelve el elemento maximo de una lista de enteros.
maximo :: [Int] -> Int
maximo (elemento:elementos) | cantidadElementos (elemento:elementos) == 1 = elemento
                            | cantidadElementos (elemento:elementos) == 0 = 0
                            | otherwise = max elemento (maximo elementos)

--Comprueba la pertenencia de un elemento a una lista
pertenece :: (Eq t) => t -> [t] -> Bool
pertenece _ [] = False
pertenece valor (elemento:elementos) | elemento == valor = True
                                     | otherwise         = pertenece valor elementos

--Devuelve un booleano indicando si dos listas contienen los mismos elementos independientemente del orden de aparicion de los mismos.
--Requiere: Que no haya elementos repetidos en las listas.
mismosElementos :: (Eq t) => [t] -> [t] -> Bool
mismosElementos [] []     = True
mismosElementos [] (b:bs) = False
mismosElementos (elementoLista1:lista1) lista2 | elementoLista1 `pertenece` lista2     = mismosElementos lista1 (quitarElemento elementoLista1 lista2)
                                               | otherwise                             = False

--Quita exactamente un elemento de una lista sin mantener el orden del resto de elementos.
--Requiere: Que el elemento este en la lista.
quitarElemento :: (Eq t) => t -> [t] -> [t]
quitarElemento elemento (elementoActual:elementos) | elemento == elementoActual = elementos
                                                   | otherwise                  = quitarElemento elemento (elementos ++ [elementoActual])

--Computa la interseccion entre dos conjuntos.
interseccion :: (Eq t) => [t] -> [t] -> [t]
interseccion [] _ = []
interseccion _ [] = []
interseccion (elementoLista1:lista1) (elementoLista2:lista2) | elementoLista1 == elementoLista2                          =   elementoLista1 :                  interseccion lista1 lista2
                                                             | elementoLista1PerteneceA2 && elementoLista2PerteneceA1    =   elementoLista1 : elementoLista2 : interseccion lista1 lista2
                                                             | elementoLista1PerteneceA2                                 =   elementoLista1 :                  interseccion lista1 lista2
                                                             | elementoLista2PerteneceA1                                 =   elementoLista2 :                  interseccion lista1 lista2
                                                             | otherwise                                                 =   interseccion lista1 lista2
                                                             where   elementoLista1PerteneceA2 = elementoLista1 `pertenece` lista2
                                                                     elementoLista2PerteneceA1 = elementoLista2 `pertenece` lista1

--Devuelve el tercer elemento de una tupla de tres elementos.
trd :: (t, r, s) -> s
trd (_, _, s) = s
