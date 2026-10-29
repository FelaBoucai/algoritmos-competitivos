import Test.HUnit
import Ejercicios1y2

main = runTestTT tests

tests = test [ 
    " nombresDeUsuarios1" ~: (nombresDeUsuarios redA) ~?= ["Pepe","Mauro","Maria","Jose","Francisco"],
    
    " amigosDe1" ~: (amigosDe redC usuario1) ~?= [usuario2, usuario3],
    " amigosDe2" ~: (amigosDe redD usuario6) ~?= []

]

expectAny actual expected = elem actual expected ~? ("expected any of: " ++ show expected ++ "\n but got: " ++ show actual)

usuario1 = (1, "Pepe")
usuario2 = (2, "Mauro")
usuario3 = (3, "Maria")
usuario4 = (4, "Jose")
usuario5 = (5, "Francisco")
usuario6 = (6, "Soledad")

relacion1_2 = (usuario1, usuario2)
relacion3_1 = (usuario3, usuario1)
relacion5_4 = (usuario5, usuario4)
relacion4_3 = (usuario4, usuario3)
relacion3_4 = (usuario3, usuario4)

usuariosA = [usuario1, usuario2, usuario3, usuario4, usuario5]
relacionesA = [relacion1_2, relacion3_1, relacion5_4, relacion3_4, relacion4_3]
redA = (usuariosA, relacionesA, [])

usuariosB = [usuario1, usuario2, usuario3]
relacionesB = [relacion4_3, relacion3_1]
redB = (usuariosB, relacionesB, [])

usuariosC = [usuario1, usuario2, usuario3, usuario4, usuario5]
relacionesC = [relacion1_2, relacion4_3, relacion3_1]
redC = (usuariosC, relacionesC, [])

usuariosD = [usuario1, usuario2, usuario3, usuario4, usuario5, usuario6]
relacionesC = [relacion1_2, relacion4_3, relacion3_1, relacion3_4]
redC = (usuariosD, relacionesD, [])
