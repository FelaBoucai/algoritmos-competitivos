# ⚡ Diseño de Algoritmos y Programación Competitiva (C++ & Haskell)

Colección de resoluciones algorítmicas implementadas para **Técnicas de Diseño de Algoritmos (Algoritmos y Estructuras de Datos III)** en **Codeforces** y **Taller de Álgebra I** (Exactas - UBA).

---

## 📂 Contenido por Técnica

### 1. [`01-grafos-bfs-dfs/`](./01-grafos-bfs-dfs) — Recorridos en Grafos, Árboles y Orden Topológico (C++)
- **[`01_jerarquia_piramidal.cpp`](./01-grafos-bfs-dfs/01_jerarquia_piramidal.cpp)**: Cálculo de la altura/niveles mínimos de partición en bosques dirigidos (Codeforces *Party* / Jerarquía Piramidal).
- **[`02_validacion_bfs.cpp`](./01-grafos-bfs-dfs/02_validacion_bfs.cpp)**: Verificación en $O(V + E)$ de si una permutación dada de vértices corresponde a un orden válido de recorrido **BFS** sobre un árbol (Codeforces *Valid BFS?*).
- **[`03_orden_topologico_dfs.cpp`](./01-grafos-bfs-dfs/03_orden_topologico_dfs.cpp)**: Inferencia de un alfabeto personalizado a partir de una lista ordenada lexicográficamente de cadenas (Codeforces *Fox And Names* / SIU Guaraní). Modela precedencias como un grafo dirigido de 26 vértices, detecta ciclos con **DFS** (aristas de retorno / *back-edges*) y construye el **Orden Topológico**.

### 2. [`02-programacion-dinamica/`](./02-programacion-dinamica) — Programación Dinámica Top-Down con Memoización (C++)
- **[`01_vacaciones_dp.cpp`](./02-programacion-dinamica/01_vacaciones_dp.cpp)**: Minimización de días de descanso sujetos a restricciones de actividades consecutivas (Codeforces *Vacations*).
- **[`02_gasoducto_dp.cpp`](./02-programacion-dinamica/02_gasoducto_dp.cpp)**: Optimización del costo de construcción de tuberías y pilares en terrenos con cruces obligatorios a doble altura (Codeforces *Gas Pipeline*), resuelto en $O(N)$ por caso de prueba con DP sobre estados de altura $(1, 2)$.
- **[`03_viaje_dag_dp.cpp`](./02-programacion-dinamica/03_viaje_dag_dp.cpp)**: Maximización de nodos visitados en un grafo acíclico dirigido (DAG) con pesos en las aristas bajo un presupuesto máximo de tiempo $T$, con reconstrucción de camino óptimo mediante matriz de predecesores (Codeforces *Bertown Subway / Vacations DAG*).

### 3. [`03-greedy-y-camino-minimo/`](./03-greedy-y-camino-minimo) — Algoritmos Greedy y Camino Mínimo con Estado (C++)
- **[`01_consultas_greedy.cpp`](./03-greedy-y-camino-minimo/01_consultas_greedy.cpp)**: Estrategia **Greedy** con ordenamiento previo ($O(N \log N)$) para maximizar la cantidad de elementos atendidos sin superar sus umbrales de espera (Codeforces *Queue*).
- **[`02_bicicletas_dijkstra.cpp`](./03-greedy-y-camino-minimo/02_bicicletas_dijkstra.cpp)**: Camino mínimo con **Dijkstra modificado** sobre grafos pesados donde cada nodo ofrece un factor multiplicador ("lentitud" de bicicleta) que puede actualizarse dinámicamente a lo largo del recorrido (Codeforces *Bicycles*).

### 4. [`04-criptografia-rsa-haskell/`](./04-criptografia-rsa-haskell) — Sistema Criptográfico RSA en Haskell
Implementación puramente funcional del protocolo de clave pública **RSA**:
- **[`Aritmetica.hs`](./04-criptografia-rsa-haskell/Aritmetica.hs)**: Algoritmo de Euclides extendido (`mcdExt`), inverso multiplicativo modular, exponenciación modular rápida (`modExp`) y criba de números primos.
- **[`RSA.hs`](./04-criptografia-rsa-haskell/RSA.hs)**: Generación de pares de claves pública/privada $(e, d, n)$ a partir de primos $p, q$, cifrado y descifrado de mensajes de texto.

---

## ⚙️ Compilación y Ejecución

### C++ (Estándar C++17)
```bash
g++ -O2 -std=c++17 02-programacion-dinamica/02_gasoducto_dp.cpp -o gasoducto
./gasoducto < input.txt
```

### Haskell (GHCi)
```bash
cd 04-criptografia-rsa-haskell
ghci main.hs
```
