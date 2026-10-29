import Test.HUnit
import Ejercicios3y7

main = runTestTT tests

tests = test [ 
    " cantidadDeAmigos1 " ~: (cantidadDeAmigos redC usuario2) ~?= 3,
    " cantidadDeAmigos2 " ~: (cantidadDeAmigos redA usuario6) ~?= 0,

    " publicacionesQueLeGustanA1 " ~: (publicacionesQueLeGustanA redD usuario5) ~?= [publicacion1_5],
    " publicacionesQueLeGustanA2 " ~: (publicacionesQueLeGustanA redA usuario6) ~?= []

]

expectAny actual expected = elem actual expected ~? ("expected any of: " ++ show expected ++ "\n but got: " ++ show actual)

usuario1 = (1, "Nacho")
usuario2 = (2, "Samuel")
usuario3 = (3, "Fela")
usuario4 = (4, "Marbbiela")
usuario5 = (5, "Vicky")
usuario6 = (6, "Octa")

relacion1_2 = (usuario1, usuario2)
relacion1_3 = (usuario1, usuario3)
relacion1_4 = (usuario4, usuario1) 
relacion2_3 = (usuario3, usuario2)
relacion2_4 = (usuario2, usuario4)
relacion2_5 = (usuario2, usuario5)
relacion1_5 = (usuario1, usuario5) 

publicacion1_1 = (usuario1, "Hola facebook", [usuario2, usuario4])
publicacion1_2 = (usuario1, "probando", [usuario4])
publicacion1_3 = (usuario1, "Este es mi primer post", [usuario2, usuario5])
publicacion1_4 = (usuario1, "Hola amigos", [])
publicacion1_5 = (usuario1, "Esta es una publicacion den me gusta", [usuario5])
publicacion4_3 = (usuario4, "Hola amigos de Facebook", [usuario1, usuario3])

publicacion2_1 = (usuario2, "Nueva foto de perfil den me gusta", [usuario4])
publicacion2_2 = (usuario2, "Aprendiendo chino", [usuario1, usuario4])

publicacion3_1 = (usuario3, "en algo1", [])

usuariosA = [usuario1, usuario2, usuario3, usuario4, usuario6]
relacionesA = [relacion1_2, relacion1_4, relacion2_3, relacion2_4, relacion2_5]
publicacionesA = [publicacion1_1, publicacion1_2, publicacion2_1, publicacion2_2, publicacion3_1]
redA = (usuariosA, relacionesA, publicacionesA)

usuariosB = [usuario1, usuario2, usuario3, usuario5]
relacionesB = [relacion1_2, relacion2_3,relacion1_5 ]
publicacionesB = [publicacion1_3, publicacion1_4, publicacion1_5, publicacion3_1]
redB = (usuariosB, relacionesB, publicacionesB)

usuariosC = [usuario1, usuario2, usuario3, usuario5]
relacionesC = [relacion1_2, relacion2_3, relacion2_5]
publicacionesC = [publicacion1_3, publicacion1_4, publicacion1_5, publicacion3_1]
redC = (usuariosC, relacionesC, publicacionesC)

usuariosD = [usuario1, usuario2, usuario3, usuario4, usuario5]
relacionesD = [relacion1_2, relacion1_3, relacion2_4, relacion1_5]
publicacionesD = [publicacion4_3, publicacion1_1, publicacion3_1]
redD = (usuariosD, relacionesD, publicacionesD)
