# ⚡ Algoritmos, Estructuras de Datos y Programación Funcional (Exactas - UBA)

Repositorio integral con implementaciones algorítmicas, estructuras de datos desde cero, programación funcional y apuntes teóricos desarrollados a lo largo de la carrera en la **Facultad de Ciencias Exactas y Naturales (UBA)**:
- **Algoritmos y Estructuras de Datos III / TDA** (`C++17` — Codeforces + Teoría y Demostraciones)
- **Algoritmos y Estructuras de Datos II / AED1** (`Java` + `JUnit` — Estructuras de Datos, Sorting, Ruteo IPv4 y TADs)
- **Intro a la Programación (Algo I) & Taller de Álgebra I** (`Haskell` — Criptografía RSA, Números de Carmichael y Red Social)

---

## 📂 Estructura del Repositorio

### 1. [`01-grafos-bfs-dfs/`](./01-grafos-bfs-dfs) — Recorridos en Grafos, Árboles y Orden Topológico (`C++17`)
- **[`01_jerarquia_piramidal.cpp`](./01-grafos-bfs-dfs/01_jerarquia_piramidal.cpp)**: Cálculo de niveles mínimos de partición en bosques dirigidos (Codeforces *Party*).
- **[`02_validacion_bfs.cpp`](./01-grafos-bfs-dfs/02_validacion_bfs.cpp)**: Verificación en $O(V + E)$ de si una secuencia de vértices corresponde a un recorrido **BFS** válido sobre un árbol (Codeforces *Valid BFS?*).
- **[`03_orden_topologico_dfs.cpp`](./01-grafos-bfs-dfs/03_orden_topologico_dfs.cpp)**: Inferencia de orden lexicográfico personalizado (Codeforces *Fox And Names* / SIU Guaraní). Modela restricciones como un grafo dirigido de 26 vértices, detecta ciclos con **DFS** (*back-edges*) y construye el **Orden Topológico**.

### 2. [`02-programacion-dinamica/`](./02-programacion-dinamica) — Programación Dinámica Top-Down con Memoización (`C++17`)
- **[`01_vacaciones_dp.cpp`](./02-programacion-dinamica/01_vacaciones_dp.cpp)**: Minimización de días de descanso bajo restricciones de transición de estados (Codeforces *Vacations*).
- **[`02_gasoducto_dp.cpp`](./02-programacion-dinamica/02_gasoducto_dp.cpp)**: Optimización en $O(N)$ del costo de tendido de tuberías y pilares con cruces obligatorios a doble altura (Codeforces *Gas Pipeline*).
- **[`03_viaje_dag_dp.cpp`](./02-programacion-dinamica/03_viaje_dag_dp.cpp)**: Camino de máxima longitud en un **DAG** pesado sujeto a presupuesto máximo $T$, con reconstrucción de camino óptimo mediante matriz de predecesores.

### 3. [`03-greedy-y-camino-minimo/`](./03-greedy-y-camino-minimo) — Estrategias Greedy y Dijkstra en Grafo de Estados (`C++17`)
- **[`01_consultas_greedy.cpp`](./03-greedy-y-camino-minimo/01_consultas_greedy.cpp)**: Algoritmo **Greedy** en $O(N \log N)$ para maximizar solicitudes atendidas según tiempo de espera acumulado.
- **[`02_bicicletas_dijkstra.cpp`](./03-greedy-y-camino-minimo/02_bicicletas_dijkstra.cpp)**: Camino mínimo con **Dijkstra modificado** sobre un grafo pesado donde cada nodo permite actualizar el factor multiplicador de velocidad (Codeforces *Bicycles*).

---

### 4. [`04-estructuras-datos-java-algo2/`](./04-estructuras-datos-java-algo2) — Estructuras de Datos, Sorting y TADs (`Java` + `JUnit`)
Implementaciones desde cero sin colecciones prearmadas, respetando complejidades asintóticas e invariantes de representación:
- **[`01-internet-toolkit-heapsort/`](./04-estructuras-datos-java-algo2/01-internet-toolkit-heapsort)**:
  - `InternetToolkit.java`, `Heap.java`, `HeapSort.java`, `Router.java`, `Fragment.java`, `IPv4Address.java`.
  - Reensamblado de fragmentos TCP (`Insertion Sort` en $O(N)$ para secuencias casi ordenadas), filtrado de los $k$ routers con mayor tráfico mediante una **Cola de Prioridad (`Max-Heap`)** con construcción en $O(N)$ (algoritmo de Floyd) y extracción en $O(k \log N)$, y ordenamiento lexicográfico de direcciones **IPv4**.
- **[`02-arbol-binario-busqueda-abb/`](./04-estructuras-datos-java-algo2/02-arbol-binario-busqueda-abb)**:
  - Implementación genérica de un **Árbol Binario de Búsqueda (`ABB<T extends Comparable<T>>`)** con inserción, búsqueda, mínimo/máximo, borrado de nodos (0, 1 y 2 hijos reemplazando por sucesor in-order) e iterador.
- **[`03-lista-doblemente-enlazada/`](./04-estructuras-datos-java-algo2/03-lista-doblemente-enlazada)**:
  - **Lista Doblemente Enlazada (`ListaEnlazada<T>`)** genérica con iterador bidireccional en $O(1)$.
- **[`04-tads-invariantes-repok/`](./04-estructuras-datos-java-algo2/04-tads-invariantes-repok)**:
  - Diseño de Tipos Abstractos de Datos (TADs), Funciones de Abstracción e Invariantes de Representación (`repOK`) en `DiccionarioConHistoria.java`, `ArbolBinario.java`, `Torneo.java`, `MatrizFinita.java` y `MatrizInfinita.java`.

---

### 5. [`05-programacion-funcional-haskell/`](./05-programacion-funcional-haskell) — Criptografía, Teoría de Números y Modelado Funcional (`Haskell`)
- **[`01-criptografia-rsa/`](./05-programacion-funcional-haskell/01-criptografia-rsa)**: Implementación funcional completa del protocolo criptográfico de clave pública **RSA** (`RSA.hs`, `Aritmetica.hs`): algoritmo de Euclides extendido, inverso multiplicativo modular, exponenciación modular rápida (`modExp`) y generación de claves $(e, d, n)$.
- **[`02-teoria-numeros-carmichael/`](./05-programacion-funcional-haskell/02-teoria-numeros-carmichael)**: Estudio computacional del Pequeño Teorema de Fermat, números $a$-pseudoprimos y detección de **Números de Carmichael** (`carmichael_pseudoprimos.hs`).
- **[`03-red-social-algo1/`](./05-programacion-funcional-haskell/03-red-social-algo1)**: Modelado algebraico de una **Red Social** (`Solucion.hs`) con usuarios, relaciones de amistad, publicaciones, likes, búsqueda de cadenas de amigos (`cadenaDeAmigos`) y detección de seguidores fieles, acompañado de suites de tests unitarios con `HUnit` (`Test1y2.hs`, `Test5y6.hs`, `Ejercicios4y10.hs`, `Ejercicios8y9.hs`).

---

### 6. [`06-teoria-y-demostraciones-algo3/`](./06-teoria-y-demostraciones-algo3) — Apuntes Teóricos y Demostraciones de Correctitud
Guías teóricas completas con análisis de complejidad, invariantes y técnicas de demostración:
- **[`00_Resumen_Maestro_Segundo_Parcial.md`](./06-teoria-y-demostraciones-algo3/00_Resumen_Maestro_Segundo_Parcial.md)**: Comparativa general de paradigmas algorítmicos y elección de técnica según la estructura del problema.
- **[`01_Resumen_Programacion_Dinamica.md`](./06-teoria-y-demostraciones-algo3/01_Resumen_Programacion_Dinamica.md)**: Subestructura óptima, superposición de subproblemas, formulaciones Top-Down vs. Bottom-Up.
- **[`02_Resumen_Algoritmos_Greedy.md`](./06-teoria-y-demostraciones-algo3/02_Resumen_Algoritmos_Greedy.md)**: Propiedad de elección greedy y demostraciones de correctitud por *Argumento de Intercambio* y *Greedy Stays Ahead*.
- **[`03_Resumen_Caminos_Minimos.md`](./06-teoria-y-demostraciones-algo3/03_Resumen_Caminos_Minimos.md)**: Relajación de aristas, **Dijkstra**, **Bellman-Ford** (detección de ciclos negativos), **Floyd-Warshall** y **Dantzig**.
- **[`04_Resumen_Flujo_Maximo.md`](./06-teoria-y-demostraciones-algo3/04_Resumen_Flujo_Maximo.md)**: Redes de flujo, grafo residual, caminos de aumento, Teorema de **Max-Flow Min-Cut**, **Ford-Fulkerson**, **Edmonds-Karp** ($O(V E^2)$) y modelado de matching bipartito / asignación.
