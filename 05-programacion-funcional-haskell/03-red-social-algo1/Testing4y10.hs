import Test.HUnit
import Ejercicios4y10

main = runTestTT tests

tests = test [

    " usuarioConMasAmigos -> Un solo usuario con mas de una relacion" ~: (usuarioConMasAmigos redN) ~?= usuario2,

    " usuarioConMasAmigos -> Usuario con mas relaciones entre otros usuarios con mas de una relacion" ~: (usuarioConMasAmigos redM) ~?= usuario18,

    " existeSecuenciaDeAmigos -> Existe la secuencia, relacion entre amigos de amigos." ~: (existeSecuenciaDeAmigos redO usuario18 usuario22) ~?= True,

    " existeSecuenciaDeAmigos -> Existe la secuencia, relacion unica." ~: (existeSecuenciaDeAmigos redM usuario18 usuario22) ~?= True,

    " existeSecuenciaDeAmigos -> No existe la secuencia, no hay relaciones en comun" ~: (existeSecuenciaDeAmigos redP usuario18 usuario22) ~?= False

 ]

expectAny actual expected = elem actual expected ~? ("expected any of: " ++ show expected ++ "\n but got: " ++ show actual)

-- Test Inputs:

usuario18 = (18, "Johnny")
usuario19 = (19, "Natalie")
usuario20 = (20, "Peter")
usuario21 = (21, "Marie")
usuario22 = (22, "Neris")

relacion18_19 = (usuario18, usuario19)
relacion18_20 = (usuario18, usuario20)
relacion18_21 = (usuario21, usuario18)
relacion19_20 = (usuario20, usuario2)
relacion19_21 = (usuario19, usuario21)
relacion20_21 = (usuario21, usuario20)
relacion18_22 = (usuario18, usuario22)
relacion22_21 = (usuario22, usuario21)

usuariosM = [usuario18, usuario19, usuario20, usuario21, usuario22]
relacionesM = [relacion18_19, relacion18_21, relacion19_21, relacion20_21, relacion18_22]
redM = (usuariosM, relacionesM, [])

usuariosN = [usuario18, usuario19, usuario20]
relacionesN = [relacion18_19, relacion19_20]
redN = (usuariosN, relacionesN, [])

usuariosO = [usuario18, usuario19, usuario20, usuario21, usuario22]
relacionesO = [relacion18_20, relacion18_22, relacion19_21, relacion20_21, relacion22_21]
redO = (usuariosO, relacionesO, [])

usuariosP = [usuario18, usuario20, usuario22]
relacionesP = [relacion18_20, relacion22_21]
redP = (usuariosP, relacionesP, [])

redE = ([],[],[])
