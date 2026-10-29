import Test.HUnit
import Ejercicios5y6

main = runTestTT tests

tests = test [ 
    " publicacionesDe1" ~: (publicacionesDe redA usuario5) ~?= [],
    " publicacionesDe2" ~: (publicacionesDe redB usuario2) ~?= [publicacion2_1, publicacion2_2, publicacion2_3]

    " estaRobertoCarlos 1" ~: (estaRobertoCarlos redA) ~?= False
    " estaRobertoCarlos 1" ~: (estaRobertoCarlos redD) ~?= True

]

expectAny actual expected = elem actual expected ~? ("expected any of: " ++ show expected ++ "\n but got: " ++ show actual)

usuario1 = (1, "Lily")
usuario2 = (2, "Rose")
usuario3 = (3, "Max")
usuario4 = (4, "Jero")
usuario5 = (5, "Cristina")
usuario6 = (6, "Roberto Carlos")

relacion1_4 = (usuario1, usuario4)
relacion2_4 = (usuario2, usuario4)
relacion2_4 = (usuario2, usuario4)
relacion2_3 = (usuario2, usuario3)
relacion3_5 = (usuario3, usuario5)

publicacion2_1 = (usuario2, "Hey mamma", [])
publicacion2_2 = (usuario2, "Buenas noches america", [usuario1],)
publicacion2_3 = (usuario2, "Comi pizza", [usuario3, usuario5])

publicacion3_1 = (usuario1, "Zzz sleeping", [usuario4, usuario])
publicacion5_2 = (usuario4, "Studying", [])
publicacion3_2 = (usuario3, "Testeando", [])

usuariosA = [usuario1, usuario4, usuario5]
relacionesA = [relacion1_4, relacion4_5]
publicacionesA = [publicacion3_1, publicacion5_2,]
redA = (usuariosA, relacionesA, publicacionesA)

usuariosB = [usuario2, usuario3]
relacionesB = [relacion2_3]
publicacionesB = [publicacion3_2, publicacion2_1, publicacion2_2, publicacion2_3]
redB = (usuariosB, relacionesB, publicacionesB)

usuariosC = [usuario1, usuario2, usuario3, usuario4, usuario5]
relacionesC = [relacion2_3, relacion3_5, relacion1_4]
publicacionesB = [publicacion3_1, publicacion3_2, publicacion2_3]
redB = (usuariosC, relacionesC, publicacionesC)

usuariosD = [usuario1, usuario7]
relacionesB = []
publicacionesD = [publicacion3_1]
redD = (usuariosD, relacionesD, publicacionesD)
