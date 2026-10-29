-- Completar con los datos del grupo
--
-- Nombre de Grupo: xx
-- Integrante 1: Samuel Furlanich, samuelfurlanich@gmail.com, 61/23
-- Integrante 2: Felipe Adrián Boucai, felaaboucai@gmail.com, 1342/21
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

-- Devuelve una lista de aquellos usuarios que esten relacionados con el usuario del segundo parametro.
amigosDe :: RedSocial -> Usuario -> [Usuario]
amigosDe (_,[],_) u = []
amigosDe (_,relacionActual:relaciones,_) usuario    | usuario == fst relacionActual = snd relacionActual : amigosDe ([], relaciones, []) usuario
                                                    | usuario == snd relacionActual = fst relacionActual : amigosDe ([], relaciones, []) usuario
                                                    | otherwise = amigosDe ([], relaciones, []) usuario

-- 3)

-- Devuelve la longitud de la lista de usuarios amigos del parametro usuario.
-- Requiere que la RedSocial y el Usuario sean validos.
cantidadDeAmigos :: RedSocial -> Usuario -> Int
cantidadDeAmigos (usuarios,relaciones,publicaciones) usuario = cantidadElementos (amigosDe (usuarios,relaciones,publicaciones) usuario)

-- 4)

-- Devuelve el usuario con el mayor numero de relaciones asociadas al mismo.
-- Requiere que la RedSocial sea valida y contenga al menos un usuario.
usuarioConMasAmigos :: RedSocial -> Usuario
usuarioConMasAmigos (usuarios,relaciones,publicaciones) = usuarioConMasRelaciones (usuarios,relaciones,publicaciones) (usuarios, juntarCantidadRelaciones (usuarios,relaciones,publicaciones)) 

-- Funcion Auxiliar.
-- Devuelve una lista cuyos elementos seran la cantidad de relaciones existentes por usuario.
juntarCantidadRelaciones :: RedSocial -> [Int]
juntarCantidadRelaciones (usuarioActual:usuarios,relaciones,publicaciones)  | cantidadElementos usuarios == 0 || cantidadElementos relaciones == 0 = [cantidadDeAmigos (usuarioActual:usuarios,relaciones,publicaciones) usuarioActual]
                                                                            | otherwise = cantidadDeAmigos (usuarioActual:usuarios,relaciones,publicaciones) usuarioActual : juntarCantidadRelaciones (usuarios,relaciones,publicaciones) 

-- Funcion Auxiliar.
-- Devuelve el usuario con mayores relaciones si el numero de estas es el elemento maximo en la lista de cantidad de relaciones totales por usuario en la RedSocial especificada. 
usuarioConMasRelaciones :: RedSocial -> ([Usuario], [Int]) -> Usuario  
usuarioConMasRelaciones redSocial (usuarioActual:usuarios,numeroDeRelaciones)   | cantidadElementos usuarios == 0 = usuarioActual
                                                                                | cantidadDeAmigos redSocial usuarioActual == maximo numeroDeRelaciones = usuarioActual 
                                                                                | otherwise = usuarioConMasRelaciones redSocial (usuarios,numeroDeRelaciones)

--5)

-- Tomando como funciones auxiliares "cantidadDeAmigos" y "usuarioConMasAmigos",
-- lo que hace esta función es verificar que la cantidad de amigos del usuario con mas amigos
-- sea mayor a un millón.
estaRobertoCarlos :: RedSocial -> Bool
estaRobertoCarlos (usuarios,relaciones,publicaciones) = cantidadDeAmigos (usuarios,relaciones,publicaciones) (usuarioConMasAmigos (usuarios,relaciones,publicaciones)) > 10

--6)

-- Haciendo recursión en la lista de publicaciones, la función revisa que el usuairio sea igual al primer termino
-- de la cabeza de la lista de publicaciones.
-- Si es igual, agrega la publicacion a la lista y hace recursión sobre la cola de publicaciones y el mismo usuairo.
-- Por lo contrario, solamente hace la recursión sobre la cola de publicaciones y el mismo usuario.
-- El caso base es cuando la lista de publiaciones es vacía, y devuelve una lista vacía.
publicacionesDe :: RedSocial -> Usuario -> [Publicacion]
publicacionesDe (_, _, []) _ = []
publicacionesDe (_, _, p:ps) u | u == usuarioDePublicacion p = p : publicacionesDe ([], [], ps) u
                               | otherwise = publicacionesDe ([], [], ps) u

-- 7)

-- Dada un usuario devuelve la lista de publicaciones a las cuales le dio me gusta.
publicacionesQueLeGustanA :: RedSocial -> Usuario -> [Publicacion]
publicacionesQueLeGustanA (_, _, []) usuario = []
publicacionesQueLeGustanA (_, _, publicacion:publicaciones) usuario | pertenece usuario (tercerElementoTupla publicacion) = publicacion : publicacionesQueLeGustanA ([], [], publicaciones) usuario
                                                                    | otherwise = publicacionesQueLeGustanA ([], [], publicaciones) usuario

--8)

--Dados dos usuarios de una misma red social devuelve un booleano indicando si ambos le dieron like a las mismas publicaciones.
lesGustanLasMismasPublicaciones :: RedSocial -> Usuario -> Usuario -> Bool
lesGustanLasMismasPublicaciones red usuario1 usuario2 = mismosElementos (publicacionesQueLeGustanA red usuario1) (publicacionesQueLeGustanA red usuario2)

--9)

--Dada una red social y un usuario de esta devuelve un booleano indicando si existe otro usuario de la red que le haya dado me gusta a todas las publicaciones del primer usuario.
--Tambien devuelve falso si el usuario no tiene publicaciones hechas.
tieneUnSeguidorFiel :: RedSocial -> Usuario -> Bool
tieneUnSeguidorFiel (usuarios, _, publicaciones) usuario | null publicacionesUsuario    = False
                                                         | otherwise                    = tieneUnSeguidorFielAux (quitarElemento usuario usuarios) publicacionesUsuario
                                                         where publicacionesUsuario     = publicacionesDe ([], [], publicaciones) usuario

--Funcion auxiliar para computar tieneUnSeguidorFiel. Es necesaria para poder iterar por todas las publicaciones del usuario sin redefenir tieneUnSeguidorFiel.
tieneUnSeguidorFielAux :: [Usuario] -> [Publicacion] -> Bool
tieneUnSeguidorFielAux usuarios [] = not(null usuarios)
tieneUnSeguidorFielAux usuarios (publicacion:publicaciones) | null likesPublicacionesEnComun   = False
                                                            | otherwise                        = tieneUnSeguidorFielAux likesPublicacionesEnComun publicaciones
                                                            where likesPublicacionesEnComun    = interseccion (likesDePublicacion publicacion) usuarios

-- 10)

-- Devuelve valor verdadero si existe una relacion consecutiva entre usuarios desde el usuario del primer parametro hasta el usuario del segundo parametro.
existeSecuenciaDeAmigos :: RedSocial -> Usuario -> Usuario -> Bool
existeSecuenciaDeAmigos (usuarios,relaciones,publicaciones) usuario1 usuario2   | pertenece usuario2 (amigosDe (usuarios,relaciones,publicaciones) usuario1) = True
                                                                                | pertenece usuario2 (amigosDeAmigos (usuarios,relaciones,publicaciones) (amigosDe (usuarios,relaciones,publicaciones) usuario1)) = True
                                                                                | otherwise = False

-- Funcion Auxiliar para obtener una lista con todos los usuarios relacionados entre si.
-- Dada una RedSocial valida, y una lista de usuarios inicial, 
-- devuelve una lista de usuarios basada en todos los usuarios que son amigos del parametro usuario o relacionados con los usuarios relacionados a este ultimo.
amigosDeAmigos :: RedSocial -> [Usuario] -> [Usuario]
amigosDeAmigos _ [] = []
amigosDeAmigos (usuarios,relaciones,publicaciones) (usuarioActual:usuarioss) = amigosDe (usuarios,relaciones,publicaciones) usuarioActual ++ amigosDeAmigos (usuarios,relaciones,publicaciones) usuarioss


-- /////////// HELPERS //////////// --


-- Devuelve el numero de elementos de una lista generica.
cantidadElementos :: [t] -> Int
cantidadElementos [] = 0
cantidadElementos (_:elementos) = 1 + cantidadElementos elementos

-- Devuelve el elemento maximo de una lista de enteros.
maximo :: [Int] -> Int
maximo (elementoActual:elementos)   | cantidadElementos (elementoActual:elementos) == 1 = elementoActual
                                    | cantidadElementos (elementoActual:elementos) == 0 = 0
                                    | otherwise = max elementoActual (maximo elementos)

-- Comprobueba pertenencia de elementos en listas.
-- Dado un parametro "t" y la lista de elementos "t" del segundo parametro, devuelve un valor de verdad segun el primer parametro es un elemento en la lista del segundo parametro.
pertenece :: (Eq t) => t -> [t] -> Bool
pertenece _ [] = False
pertenece elementoBuscado (elementoActual:elementos)    | elementoActual == elementoBuscado = True
                                                        | otherwise = pertenece elementoBuscado elementos

--Devuelve un booleano indicando si dos listas contienen los mismos elementos independientemente del orden de aparicion de los mismos.
--Requiere: Que no haya elementos repetidos en las listas.
mismosElementos :: (Eq t) => [t] -> [t] -> Bool
mismosElementos [] []     = True
mismosElementos [] (b:bs) = False
mismosElementos (elementoLista1:lista1) lista2      | elementoLista1 `pertenece` lista2     = mismosElementos lista1 (quitarElemento elementoLista1 lista2)
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
interseccion (elementoLista1:lista1) (elementoLista2:lista2)    | elementoLista1 == elementoLista2                          =   elementoLista1 :     interseccion lista1 lista2
                                                                | elementoLista1PerteneceA2 && elementoLista2PerteneceA1    =   elementoLista1 : elementoLista2 : interseccion lista1 lista2
                                                                | elementoLista1PerteneceA2                                 =   elementoLista1 :     interseccion lista1 lista2
                                                                | elementoLista2PerteneceA1                                 =   elementoLista2 :     interseccion lista1 lista2
                                                                | otherwise                                                 =   interseccion lista1 lista2
                                                                where   elementoLista1PerteneceA2 = elementoLista1 `pertenece` lista2
                                                                        elementoLista2PerteneceA1 = elementoLista2 `pertenece` lista1

--Devuelve el tercer elemento de una tupla de tres elementos.
tercerElementoTupla :: (t, r, s) -> s
tercerElementoTupla (_, _, s) = s

usuario1 = (1, "Juan")
usuario2 = (2, "Natalia")
usuario3 = (3, "Pedro")
usuario4 = (4, "Mariela")
usuario5 = (5, "Natalia")

relacion1_2 = (usuario1, usuario2)
relacion1_3 = (usuario1, usuario3)
relacion1_4 = (usuario4, usuario1) -- Notar que el orden en el que aparecen los usuarios es indistinto
relacion2_3 = (usuario3, usuario2)
relacion2_4 = (usuario2, usuario4)
relacion3_4 = (usuario4, usuario3)

publicacion1_1 = (usuario1, "Este es mi primer post", [usuario2, usuario4])
publicacion1_2 = (usuario1, "Este es mi segundo post", [usuario4])
publicacion1_3 = (usuario1, "Este es mi tercer post", [usuario2, usuario5])
publicacion1_4 = (usuario1, "Este es mi cuarto post", [])
publicacion1_5 = (usuario1, "Este es como mi quinto post", [usuario5])

publicacion2_1 = (usuario2, "Hello World", [usuario4])
publicacion2_2 = (usuario2, "Good Bye World", [usuario1, usuario4])

publicacion3_1 = (usuario3, "Lorem Ipsum", [])
publicacion3_2 = (usuario3, "dolor sit amet", [usuario2])
publicacion3_3 = (usuario3, "consectetur adipiscing elit", [usuario2, usuario5])

publicacion4_1 = (usuario4, "I am Alice. Not", [usuario1, usuario2])
publicacion4_2 = (usuario4, "I am Bob", [])
publicacion4_3 = (usuario4, "Just kidding, i am Mariela", [usuario1, usuario3])


usuariosA = [usuario1, usuario2, usuario3, usuario4]
relacionesA = [relacion1_2, relacion1_4, relacion1_3, relacion2_3, relacion2_4, relacion3_4]
publicacionesA = [publicacion1_1, publicacion1_2, publicacion2_1, publicacion2_2, publicacion3_1, publicacion3_2, publicacion4_1, publicacion4_2]
redA = (usuariosA, relacionesA, publicacionesA)

usuariosB = [usuario1, usuario2, usuario3, usuario5]
relacionesB = [relacion1_2, relacion2_3]
publicacionesB = [publicacion1_3, publicacion1_4, publicacion1_5, publicacion3_1, publicacion3_2, publicacion3_3]
redB = (usuariosB, relacionesB, publicacionesB)
