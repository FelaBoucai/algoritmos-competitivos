module Ejercicios4y10 where
 
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

-- 2)
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

-- Funcion Auxiliar.
-- Devuelve el elemento maximo de una lista de enteros.
maximo :: [Int] -> Int
maximo (elementoActual:elementos)   | cantidadElementos (elementoActual:elementos) == 1 = elementoActual
                                    | cantidadElementos (elementoActual:elementos) == 0 = 0
                                    | otherwise = max elementoActual (maximo elementos)

-- 10)

-- Devuelve valor verdadero si existe una relacion consecutiva entre usuarios desde el usuario del primer parametro hasta el usuario del segundo parametro
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

-- Comprobueba pertenencia de elementos en listas.
-- Dado un el parametro y la lista de elementos del segundo parametro, devuelve un valor de verdad segun el primer parametro es un elemento en la lista del segundo parametro.
pertenece :: (Eq t) => t -> [t] -> Bool
pertenece _ [] = False
pertenece valor (elementoActual:elementos)  | elementoActual == valor = True
                                            | otherwise = pertenece valor elementos
