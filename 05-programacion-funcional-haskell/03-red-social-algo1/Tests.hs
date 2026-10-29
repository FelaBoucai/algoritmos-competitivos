import Test.HUnit
import Solucion
import Test.HUnit (runTestTT)

main = runTestTT tests

testSuiteEjercicio1 = runTestTT 
testSuiteEjercicio2 = runTestTT testsEjercicio2
testSuiteEjercicio3 = runTestTT testsEjercicio3
testSuiteEjercicio4 = runTestTT testsEjercicio4
testSuiteEjercicio5 = runTestTT testsEjercicio5
testSuiteEjercicio6 = runTestTT testsEjercicio6
testSuiteEjercicio7 = runTestTT testsEjercicio7
testSuiteEjercicio8 = runTestTT testsEjercicio8
testSuiteEjercicio9 = runTestTT testsEjercicio9
testSuiteEjercicio10 = runTestTT testsEjercicio10

testsEjercicio1 = test[
    "nombresDeUsuarios -> Red con usuarios" ~: mismosElementos (nombresDeUsuarios redA) ["Pepe","Mauro","Maria","Jose","Francisco", "Soledad"] ~?= True,
    "nombresDeUsuarios -> Red vacia"       ~: nombresDeUsuarios redJ ~?= []
 ]

testsEjercicio2 = test[
    "amigosDe -> Usuario con amigos"        ~: mismosElementos (amigosDe redC usuario1) [usuario2, usuario3] ~?= True,
    "amigosDe -> Usuario sin amigos"        ~: amigosDe redB usuario2  ~?= []
 ]

testsEjercicio3 = test[
    " cantidadDeAmigos -> Usuario con amigos "          ~: cantidadDeAmigos redD usuario8 ~?= 4,
    " cantidadDeAmigos -> Usuario sin amigos "          ~: cantidadDeAmigos redB usuario2 ~?= 0
 ]

testsEjercicio4 = test[
    "usuarioConMasAmigos -> Un solo usuario con mas de una relacion."                                           ~: usuarioConMasAmigos redB ~?= usuario3,
    "usuarioConMasAmigos -> Usuario con mas relaciones entre otros usuarios con mas de una relacion."           ~: usuarioConMasAmigos redG ~?= usuario18,
    "usuarioConMasAmigos -> No existen relaciones entre usuarios, nadie tiene amigos."                          ~: usuariosConMasAmigos redK [usuario23, usuario24, usuario25] ~?= True,
    -- Caso especial para testear el comportamiento de la funcion si existen varios usuarios con un maximo comun de amigos.
    "usuarioConMasAmigos -> Existe mas de un usuario con la misma cantidad de amigos que el maximo."            ~: usuariosConMasAmigos redC [usuario3, usuario1] ~?= True
 ]

testsEjercicio5 = test[
    " estaRobertoCarlos -> Ningun usuario tiene 10 o mas amigos"    ~: estaRobertoCarlos redA ~?= False,
    " estaRobertoCarlos -> Existe un usuario con 11 amigos."        ~: estaRobertoCarlos redF ~?= True
 ]

testsEjercicio6 = test[   
    " publicacionesDe -> Usuario con varias publicaciones"  ~: mismosElementos (publicacionesDe redD usuario7) [publicacion7_1, publicacion7_2] ~?= True,
    " publicacionesDe -> Usuario sin publicaciones"         ~: mismosElementos (publicacionesDe redD usuario11) [] ~?= True
 ]

testsEjercicio7 = test[
    " publicacionesQueLeGustanA -> Al usuario le gustan varias publicaciones"   ~: mismosElementos (publicacionesQueLeGustanA redE usuario11) [publicacion7_3, publicacion7_5] ~?= True,
    " publicacionesQueLeGustanA -> Al usuario no le gusta ninguna publicacion"  ~: publicacionesQueLeGustanA redA usuario6 ~?= []
 ]

testsEjercicio8 = test[   
    "lesGustanLasMismasPublicaciones -> Les gustan las mismas publicaciones"    ~: lesGustanLasMismasPublicaciones redK usuario24 usuario25 ~?= True,
    "lesGustanLasMismasPublicaciones -> No Les gustan las mismas publicaciones" ~: lesGustanLasMismasPublicaciones redK usuario23 usuario25 ~?= False,
    "lesGustanLasMismasPublicaciones -> Ninguno dio like a ninguna publicacion" ~: lesGustanLasMismasPublicaciones redL usuario24 usuario25 ~?= True
 ]

testsEjercicio9 = test[
    "tieneUnSeguidorFiel -> Tiene un seguidor fiel"         ~: tieneUnSeguidorFiel redM usuario26 ~?= True,
    "tieneUnSeguidorFiel -> No tiene un seguidor fiel"      ~: tieneUnSeguidorFiel redM usuario27 ~?= False, 
    "tieneUnSeguidorFiel -> Tiene varios seguidores fieles" ~: tieneUnSeguidorFiel redN usuario26 ~?= True,
    "tieneUnSeguidorFiel -> No tiene publicaciones"         ~: tieneUnSeguidorFiel redM usuario27 ~?= False
 ]

testsEjercicio10 = test[
    "existeSecuenciaDeAmigos -> Existe la secuencia, relacion entre amigos de amigos."  ~: existeSecuenciaDeAmigos redH usuario18 usuario22 ~?= True,
    "existeSecuenciaDeAmigos -> Existe la secuencia, relacion unica."                   ~: existeSecuenciaDeAmigos redG usuario18 usuario22 ~?= True,
    "existeSecuenciaDeAmigos -> No existe la secuencia, no hay relaciones en comun"     ~: existeSecuenciaDeAmigos redI usuario18 usuario22 ~?= False,
    "existeSecuenciaDeAmigos -> No existe la secuencia, no hay relaciones en comun"     ~: existeSecuenciaDeAmigos redI usuario18 usuario22 ~?= False
 ]

tests = test [

    testsEjercicio1,

    testsEjercicio2,
    
    testsEjercicio3,

    testsEjercicio4,

    testsEjercicio5,

    testsEjercicio6,
    
    testsEjercicio7,

    testsEjercicio8,

    testsEjercicio9,

    testsEjercicio10

 ]

-- //////////////////////////////// HELPERS ////////////////////////////////

-- Dada una red social y una lista de usuarios esperados, devuelve un booleano con valor verdadero si el usuario con mas amigos de la red social, pertenece a la lista de usuarios.
usuariosConMasAmigos :: RedSocial -> [Usuario] -> Bool
usuariosConMasAmigos red [] = False
usuariosConMasAmigos red usuariosPosibles = pertenece (usuarioConMasAmigos red) usuariosPosibles

-- Devuelve una lista de relaciones entre un usuario y otros generados recursivamente.
-- La longitud de la lista devuelta es del numero especificado en el segundo parametro.
-- Requiere: que "usuario" sea un usuario valido y "numeroRelaciones" sea mayor u igual a 1.
generarNRelacionesUsuario :: Usuario -> Integer -> [Relacion]
generarNRelacionesUsuario usuario numeroRelaciones  | numeroRelaciones == 1 = [(usuario, (1, "{numeroRelaciones}"))]
                                                    | otherwise = (usuario, generarUsuario numeroRelaciones) : generarNRelacionesUsuario usuario (numeroRelaciones-1)

-- Dado un numero entero, devuelve una lista de usuarios genericos de longitud segun el parametro indicado.
generarUsuarios :: Integer -> [Usuario]
generarUsuarios cantidadUsuarios    | cantidadUsuarios == 0 = []
                                    | cantidadUsuarios == 1 = [generarUsuario cantidadUsuarios]
                                    | otherwise = generarUsuario cantidadUsuarios : generarUsuarios (cantidadUsuarios - 1)

-- Dado un numero entero, devuelve un usuario cuya ID sera dicho numero entero en el parametro de entrada.
generarUsuario :: Integer -> Usuario
generarUsuario idUsuario = (idUsuario, "{idUsuario}")

-- //////////////////////////////// TEST INPUTS ////////////////////////////////

usuario1 = (1, "Pepe")
usuario1A = (111, "Pepe")
usuario2 = (2, "Mauro")
usuario3 = (3, "Maria")
usuario4 = (4, "Jose")
usuario5 = (5, "Francisco")
usuario6 = (6, "Soledad")
usuario7 = (7, "Nacho")
usuario8 = (8, "Samuel")
usuario9 = (9, "Fela")
usuario10 = (10, "Marbbiela")
usuario11 = (11, "Vicky")
usuario12 = (12, "Lily")
usuario13 = (13, "Rose")
usuario14 = (14, "Max")
usuario15 = (15, "Jero")
usuario16 = (16, "Cristina")
usuario18 = (18, "Johnny")
usuario19 = (19, "Natalie")
usuario20 = (20, "Peter")
usuario21 = (21, "Marie")
usuario22 = (22, "Neris")
usuario23 = (23, "Pepito")
usuario24 = (24, "Juanito")
usuario25 = (25, "Alcachofa")
usuario26 = (26, "Eriberto")
usuario27 = (27, "Bigote")
usuario28 = (28, "Eber")

relacion1_2 = (usuario1, usuario2)
relacion3_1 = (usuario3, usuario1)
relacion5_4 = (usuario5, usuario4)
relacion4_3 = (usuario4, usuario3)

relacion7_8 = (usuario7, usuario8)
relacion7_10 = (usuario7, usuario10) 
relacion7_11 = (usuario7, usuario11) 
relacion8_9 = (usuario8, usuario9)
relacion8_10 = (usuario8, usuario10)
relacion8_11 = (usuario8, usuario11)

relacion12_15 = (usuario12, usuario15)
relacion13_14 = (usuario13, usuario14)
relacion14_16 = (usuario14, usuario16)

relacion18_19 = (usuario18, usuario19)
relacion18_20 = (usuario18, usuario20)
relacion18_21 = (usuario18, usuario21)
relacion18_22 = (usuario18, usuario22)
relacion19_21 = (usuario19, usuario21)
relacion20_21 = (usuario20, usuario21)
relacion22_21 = (usuario22, usuario21)

relacion24_25 = (usuario24, usuario25)

publicacion7_1 = (usuario7, "Hola facebook", [usuario8, usuario10])
publicacion7_2 = (usuario7, "probando", [usuario10])
publicacion7_3 = (usuario7, "Este es mi primer post", [usuario8, usuario11])
publicacion7_4 = (usuario7, "Hola amigos", [])
publicacion7_5 = (usuario7, "Esta es una publicacion den me gusta", [usuario11])

publicacion8_1 = (usuario8, "Nueva foto de perfil den me gusta", [usuario10])
publicacion8_2 = (usuario8, "Aprendiendo chino", [usuario7, usuario10])

publicacion9_1 = (usuario9, "en algo1", [])

publicacion12_1 = (usuario12, "Zzz sleeping", [usuario15, usuario12])

publicacion13_1 = (usuario13, "Comi pizza", [usuario14, usuario16])

publicacion14_1 = (usuario14, "Testeando", [])

publicacion23_1 = (usuario23, "Viva la vida", [usuario24, usuario25])
publicacion23_2 = (usuario23, "Me gusta el helado de chocolate", [usuario24, usuario25])
publicacion23_3 = (usuario23, "Me caigo y me levanto", [usuario23])

publicacion26_1 = (usuario26, "Viva la vida", [usuario27])
publicacion26_2 = (usuario26, "Me gusta el helado de chocolate", [usuario27])
publicacion26_3 = (usuario26, "Hoy me comi una milanesa", [usuario28, usuario27])

usuariosA       = [usuario1, usuario1A, usuario2, usuario3, usuario4, usuario5,usuario6]
relacionesA     = [relacion1_2, relacion3_1, relacion5_4, relacion4_3]
redA            = (usuariosA, relacionesA, [])

usuariosB       = [usuario1, usuario2, usuario3, usuario4]
relacionesB     = [relacion4_3, relacion3_1]
redB            = (usuariosB, relacionesB, [])

usuariosC       = [usuario1, usuario2, usuario3, usuario4, usuario5]
relacionesC     = [relacion1_2, relacion4_3, relacion3_1]
redC            = (usuariosC, relacionesC, [])

usuariosD       = [usuario7, usuario8, usuario9, usuario10]
relacionesD     = [relacion7_8, relacion7_10, relacion8_9, relacion8_10, relacion8_11]
publicacionesD  = [publicacion7_1, publicacion7_2, publicacion8_1, publicacion8_2, publicacion9_1]
redD            = (usuariosD, relacionesD, publicacionesD)

usuariosE       = [usuario7, usuario8, usuario9, usuario11]
relacionesE     = [relacion7_8, relacion8_9,relacion7_11 ]
publicacionesE  = [publicacion7_3, publicacion7_4, publicacion7_5, publicacion9_1]
redE            = (usuariosE, relacionesE, publicacionesE)

-- Usamos los tests inputs de L para los casos de tests de "estaRobertoCarlos", 
-- Como requiere cantidades en decenas de usuarios y relaciones, las generamos por medio de funciones auxiliares.

usuariosF = usuario12 : generarUsuarios 11
relacionesF     = generarNRelacionesUsuario usuario12 11
publicacionesF  = [publicacion12_1]
redF            = (usuariosF, relacionesF, publicacionesF)

usuariosG = [usuario18, usuario19, usuario20, usuario21, usuario22]
relacionesG = [relacion18_19, relacion18_21, relacion19_21, relacion20_21, relacion18_22]
redG = (usuariosG, relacionesG, [])

usuariosH = [usuario18, usuario19, usuario20, usuario21, usuario22]
relacionesH = [relacion18_20, relacion18_22, relacion19_21, relacion20_21, relacion22_21]
redH = (usuariosH, relacionesH, [])

usuariosI = [usuario18, usuario20, usuario22, usuario21]
relacionesI = [relacion18_20, relacion22_21]
redI = (usuariosI, relacionesI, [])

redJ = ([],[],[])

usuariosK       = [usuario23, usuario24, usuario25]
publicacionesK  = [publicacion23_1, publicacion23_2, publicacion23_3]
redK            = (usuariosK, [], publicacionesK)

usuariosL       = [usuario23, usuario24, usuario25]
publicacionesL  = [publicacion23_3]
redL            = (usuariosL, [], publicacionesL)

usuariosM       = [usuario26, usuario27, usuario28]
publicacionesM  = [publicacion26_1, publicacion26_2] 
redM            = (usuariosM, [], publicacionesM)

usuariosN       = [usuario26, usuario27, usuario28]
publicacionesN  = [publicacion26_3] 
redN            = (usuariosN, [], publicacionesN)

usuariosO       = [usuario24, usuario25, usuario26]
relacionesO     = [relacion24_25] 
publicacionesO  = [publicacion26_3]
redO            = (usuariosO, relacionesO, publicacionesO)