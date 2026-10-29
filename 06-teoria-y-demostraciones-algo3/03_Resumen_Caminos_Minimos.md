# Guía de Estudio Exhaustiva: Caminos Mínimos y Modelado en Grafos
**Materia:** Técnicas de Diseño de Algoritmos (TDA) / Algoritmos y Estructuras de Datos III — FCEyN, UBA  
**Unidad:** Segundo Parcial — Tema 3: Caminos Mínimos (BFS, DAGs, Dijkstra, Bellman-Ford, Floyd-Warshall, Dantzig) y Técnicas de Modelado  
**Fuentes integradas:** Teórica 9, Pizarrón Turno Tarde (Teórica y Práctica), Clase Práctica 9, Guía Práctica 8 completa, Taller 3 de Codeforces.

---

## 1. Fundamentos Teóricos y Propiedades Generales

### 1.1. Planteo del Problema
Dado un grafo o digrafo ponderado $G = (V, E)$ con función de costo en las aristas $w: E \to \mathbb{R}$ (con $n = |V|$ y $m = |E|$):
- **Peso de un recorrido $P = (v_0, v_1, \dots, v_k)$:**
  $$w(P) = \sum_{i=1}^{k} w(v_{i-1}, v_i)$$
- **Distancia mínima $\delta(u, v)$:**
  $$\delta(u, v) = \begin{cases} \inf \{ w(P) : P \text{ es un recorrido de } u \text{ a } v \} & \text{si existe camino de } u \text{ a } v \\ +\infty & \text{si } v \text{ es inalcanzable desde } u \end{cases}$$
- **Variantes del problema:**
  1. **Un origen a todos (SSSP - *Single-Source Shortest Paths*):** Dado $s \in V$, hallar $\delta(s, v)$ para todo $v \in V$.
  2. **Todos a un destino:** Dado $t \in V$, hallar $\delta(v, t)$ para todo $v \in V$. Se resuelve invirtiendo todas las aristas del digrafo ($G^R$ o $G^T$) y corriendo SSSP desde $t$.
  3. **Todos contra todos (APSP - *All-Pairs Shortest Paths*):** Hallar $\delta(u, v)$ para todo par $(u, v) \in V \times V$.

---

### 1.2. Propiedad de Subestructura Óptima de los Caminos Mínimos
> **Propiedad Fundamental:** Todo subcamino de un camino mínimo es a su vez un camino mínimo entre sus extremos.  
> Es decir, si $P = v_0 \to v_1 \to \dots \to v_k$ es un camino mínimo de $v_0$ a $v_k$, entonces para cualesquiera $0 \le i \le j \le k$, el subcamino $P_{ij} = v_i \to \dots \to v_j$ es un camino mínimo de $v_i$ a $v_j$, y por lo tanto $\delta(v_0, v_k) = \delta(v_0, v_i) + \delta(v_i, v_j) + \delta(v_j, v_k)$.

- **Demostración (Cut & Paste):** Si existiera un camino $P'_{ij}$ de $v_i$ a $v_j$ con $w(P'_{ij}) < w(P_{ij})$, al reemplazar $P_{ij}$ por $P'_{ij}$ dentro de $P$ obtendríamos un recorrido de $v_0$ a $v_k$ de peso estrictamente menor que $\delta(v_0, v_k)$, lo cual es absurdo.
- **¿Qué pasa con los ciclos?**
  - **Ciclos de peso $> 0$:** Nunca conviene incluirlos en un camino mínimo; quitarlos reduce estrictamente el costo.
  - **Ciclos de peso $= 0$:** Quitarlos no altera el peso total; por lo tanto, siempre que $\delta(s, v) > -\infty$, existe un **camino simple** (sin repetir vértices, de a lo sumo $n - 1$ aristas) que alcanza el peso mínimo $\delta(s, v)$.
  - **Ciclos de peso $< 0$ (Ciclos Negativos):** Si existe un ciclo $C$ con $w(C) < 0$ alcanzable desde $s$ y desde el cual se puede llegar a $v$, entonces podemos ciclar arbitrariamente en $C$ y hacer que el costo tienda a $-\infty$ ($\delta(s, v) = -\infty$).
  - ⚠️ **Nota teórica clave:** Si hay ciclos negativos y pedimos el **camino simple** (sin repetir vértices) de menor peso entre $s$ y $t$, el problema deja de tener subestructura óptima estándar y es **NP-difícil** (equivalente a Camino Hamiltoniano).

---

### 1.3. Operación de Relajación (`RELAJAR`)
Todos los algoritmos de un origen mantienen para cada vértice $v \in V$:
- Una estimación superior $d[v]$ del peso del camino mínimo desde $s$ (inicializada en $d[s] = 0$ y $d[v] = +\infty$ para $v \neq s$).
- Un puntero al predecesor $\pi[v]$ para reconstruir el árbol de caminos mínimos (inicializado en $\text{NIL}$).

```text
RELAJAR(u, v, w):
1. si d[u] != +inf y d[v] > d[u] + w(u, v) entonces
2.     d[v] <- d[u] + w(u, v)
3.     pi[v] <- u
```

**Propiedades invariantes de la relajación ($O(1)$ por operación):**
1. **Cota superior:** En todo momento, si $d[v] < +\infty$, entonces $d[v]$ es el peso de *algún* recorrido válido desde $s$ hasta $v$. En consecuencia, **siempre vale $\delta(s, v) \le d[v]$**.
2. **Monotonía:** $d[v]$ nunca aumenta; sólo puede disminuir o mantenerse igual tras una relajación.
3. **Desigualdad triangular en el óptimo:** $\delta(s, v) \le \delta(s, u) + w(u, v)$ para toda arista $(u, v) \in E$.
4. **Propiedad de relajación de caminos (Teorema 22.5 del Cormen):** Si $P = (s = v_0, v_1, \dots, v_k = v)$ es un camino mínimo de $s$ a $v$, y relajamos las aristas $(v_0, v_1), (v_1, v_2), \dots, (v_{k-1}, v_k)$ en ese orden (aunque haya otras relajaciones intercaladas), entonces al finalizar vale $d[v] = \delta(s, v)$.

---

## 2. Cuadro Comparativo de Algoritmos de Camino Mínimo

| Algoritmo | Tipo de Problema | Condición sobre Pesos / Grafo | Idea / Paradigma | Complejidad Temporal | Complejidad Espacial |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **BFS** | 1 a todos (SSSP) | Sin pesos (o todas las aristas con igual peso $c > 0$) | Búsqueda por niveles (cola FIFO) | $O(n + m)$ | $O(n)$ aux |
| **BFS 0-1** | 1 a todos (SSSP) | Pesos $w(e) \in \{0, 1\}$ | Deque (doble cola): peso $0$ al frente, peso $1$ atrás | $O(n + m)$ | $O(n)$ aux |
| **Camino en DAG** | 1 a todos (SSSP) | Digrafo Acíclico (DAG), **cualquier peso** ($\ge 0$ o $< 0$) | Orden Topológico + PD (1 barrido) | $O(n + m)$ | $O(n)$ aux |
| **Dijkstra (con Heap)** | 1 a todos (SSSP) | Pesos **no negativos** ($w(e) \ge 0$) | **Greedy**: fijar el no visitado con menor $d[u]$ | $O((n + m) \log n)$ | $O(n)$ aux |
| **Dijkstra (con Arreglo)** | 1 a todos (SSSP) | Pesos **no negativos** ($w(e) \ge 0$), ideal en grafos densos ($m \approx n^2$) | **Greedy**: buscar mínimo en $O(n)$ por paso | $O(n^2 + m) = O(n^2)$ | $O(n)$ aux |
| **Bellman-Ford** | 1 a todos (SSSP) | **Cualquier peso** ($w(e) \in \mathbb{R}$); detecta ciclos negativos alcanzables | **PD** por cantidad de aristas ($n-1$ pasadas) | $O(n \cdot m)$ | $O(n)$ aux |
| **Floyd-Warshall** | Todos a todos (APSP) | **Cualquier peso**; detecta ciclos negativos ($D[i][i] < 0$) | **PD** por conjunto de vértices intermedios $\{1..k\}$ | $O(n^3)$ | $O(n^2)$ |
| **Dantzig** | Todos a todos (APSP) | **Cualquier peso**; detecta ciclos negativos | **PD** agregando el vértice $k$ al subgrafo inducido $\{1..k\}$ | $O(n^3)$ | $O(n^2)$ |

---

## 3. Análisis Detallado de Cada Algoritmo

### 3.1. Caminos Mínimos (y Máximos) en un DAG — $O(n + m)$
En un Digrafo Acíclico (DAG) no existen ciclos (ni positivos ni negativos). Todo camino tiene a lo sumo $n - 1$ aristas y respeta cualquier **orden topológico** $v_1, v_2, \dots, v_n$ (donde si $(v_i, v_j) \in E$, entonces $i < j$).

#### Recurrencia de Programación Dinámica
$$\delta(s, s) = 0, \qquad \delta(s, v) = \min_{(u, v) \in E} \{ \delta(s, u) + w(u, v) \} \quad (v \neq s)$$

#### Algoritmo (Un único barrido en orden topológico)
1. Calcular un orden topológico $L = (v_1, \dots, v_n)$ de $G$ en $O(n + m)$.
2. Inicializar $d[s] = 0$, $d[v] = +\infty$ para $v \neq s$, y $\pi[v] = \text{NIL}$.
3. Para cada $u \in L$ (en orden topológico):
   - Para cada $v \in \text{Adj}[u]$: ejecutar `RELAJAR(u, v, w)`.

#### Demostración de Correctitud
Sea $P = (s = u_0, u_1, \dots, u_k = v)$ un camino mínimo de $s$ a $v$. Como $G$ es un DAG, los vértices $u_0, u_1, \dots, u_k$ aparecen en ese orden estricto dentro del orden topológico $L$. Por lo tanto, el algoritmo relaja las aristas $(u_0, u_1), (u_1, u_2), \dots, (u_{k-1}, u_k)$ en orden exacto. Por la propiedad de relajación de caminos, al terminar vale $d[v] = \delta(s, v)$.

#### Adaptación para Camino Máximo en un DAG (Ej. 3.b y Gestión de Proyectos - Ej. 15)
A diferencia de un grafo general (donde camino máximo simple es NP-difícil), **en un DAG el camino máximo se calcula en $O(n + m)$** de dos maneras equivalentes:
1. **Directa:** Inicializar $D[s] = 0$, $D[v] = -\infty$ ($v \neq s$), y cambiar la condición de mejora a $D[v] < D[u] + w(u, v)$.
2. **Por reducción:** Multiplicar todos los pesos por $-1$ ($w'(e) = -w(e)$), correr camino mínimo en el DAG y tomar $D[v] = -d_{w'}[v]$.

---

### 3.2. Algoritmo de Dijkstra — $O((n + m) \log n)$ o $O(n^2)$
Resuelve SSSP cuando **todas las aristas tienen peso no negativo ($w(e) \ge 0$)**.

#### Idea Greedy
Mantenemos un conjunto $S \subseteq V$ de vértices **fijados** (visitados) cuyas distancias $d[u]$ ya son definitivas ($d[u] = \delta(s, u)$). En cada paso, elegimos de $Q = V \setminus S$ el vértice $u$ con menor etiqueta $d[u]$, lo agregamos a $S$ y relajamos todas sus aristas salientes.

#### Pseudocódigo e Implementación en C++
```cpp
const long long INF = 1e18;
vector<long long> d(n + 1, INF);
vector<int> parent(n + 1, -1);
d[s] = 0;

// Min-heap de pares (distancia, vertice)
priority_queue<pair<long long, int>, vector<pair<long long, int>>, greater<pair<long long, int>>> pq;
pq.push({0, s});

while (!pq.empty()) {
    auto [dist_u, u] = pq.top();
    pq.pop();
    if (dist_u > d[u]) continue; // Entrada vieja en el heap (lazy deletion)

    for (auto [v, w] : adj[u]) {
        if (d[u] + w < d[v]) {
            d[v] = d[u] + w;
            parent[v] = u;
            pq.push({d[v], v});
        }
    }
}
```

#### Demostración de Correctitud (Por invariante / Inducción — ¡Clásico de parcial!)
- **Invariante:** Al comienzo de cada iteración del bucle `while`, para todo vértice ya fijado $x \in S$ vale $d[x] = \delta(s, x)$.
- **Caso base:** $S = \emptyset$ se cumple trivialmente (y en la primera extracción sale $s$ con $d[s] = 0 = \delta(s, s)$).
- **Paso inductivo:** Supongamos que el invariante vale para $S$ y el algoritmo extrae $u \in V \setminus S$ tal que $d[u] = \min_{z \in V \setminus S} d[z]$. Queremos probar que $d[u] = \delta(s, u)$.
  1. Sea $P$ un camino mínimo de $s$ a $u$. Como $s \in S$ y $u \notin S$, al recorrer $P$ desde $s$ hacia $u$ existe un **primer vértice $y \in P$ que sale de $S$** ($y \notin S$), cuyo predecesor inmediato en $P$ es $x \in S$.
  2. Como $x \in S$, por hipótesis inductiva cuando $x$ fue fijado ya valía $d[x] = \delta(s, x)$, y en ese momento se relajó la arista $(x, y)$, dejando:
     $$d[y] \le d[x] + w(x, y) = \delta(s, x) + w(x, y) = \delta(s, y)$$
  3. Como el subcamino de $P$ desde $y$ hasta $u$ sólo usa aristas de peso **no negativo ($w(e) \ge 0$)**, tenemos:
     $$\delta(s, y) \le \delta(s, u)$$
  4. Por otro lado, como Dijkstra eligió a $u$ antes que a $y$ (ambos estaban fuera de $S$), vale $d[u] \le d[y]$.
  5. Juntando todo en una cadena de desigualdades:
     $$\delta(s, u) \le d[u] \le d[y] \le \delta(s, y) \le \delta(s, u)$$
     De donde todas las desigualdades son igualdades y **$d[u] = \delta(s, u)$**. $\blacksquare$

> ⚠️ **¿Dónde falla la demostración si hay aristas negativas?**  
> En el paso 3: si el sufijo de $y$ a $u$ tiene peso negativo, deja de ser cierto que $\delta(s, y) \le \delta(s, u)$. Un camino más largo en cantidad de aristas pero que use una arista negativa más adelante podría terminar costando menos que $d[u]$ después de haber fijado a $u$.

---

### 3.3. Algoritmo de Bellman-Ford — $O(n \cdot m)$
Resuelve SSSP en digrafos con **pesos arbitrarios (positivos, cero o negativos)** y detecta si existe algún **ciclo de peso negativo alcanzable desde $s$**.

#### Relación con Programación Dinámica
Definimos $d_k(v)$ como el costo de un camino mínimo de $s$ a $v$ que utiliza **a lo sumo $k$ aristas**:
$$d_0(s) = 0, \quad d_0(v) = +\infty \;\;(v \neq s)$$
$$d_k(v) = \min \left\{ d_{k-1}(v), \; \min_{(u, v) \in E} \{ d_{k-1}(u) + w(u, v) \} \right\}$$
En su versión *in-place*, Bellman-Ford relaja todas las $m$ aristas del grafo durante $n - 1$ pasadas sobre el mismo arreglo `d[v]`.

#### Algoritmo
1. Inicializar $d[s] = 0$, $d[v] = +\infty$ ($v \neq s$), $\pi[v] = \text{NIL}$.
2. **Repetir $|V| - 1$ veces:**
   - Para cada arista $(u, v) \in E$: ejecutar `RELAJAR(u, v, w)`.
3. **Pasada $n$-ésima (Detección de ciclo negativo):**
   - Para cada arista $(u, v) \in E$:
     - Si $d[u] < +\infty$ y $d[u] + w(u, v) < d[v]$: **devolver `FALSO`** (hay ciclo negativo alcanzable desde $s$).
4. **Devolver `VERDADERO`** (las distancias $d[v] = \delta(s, v)$ son óptimas).

#### Demostración de Correctitud de Bellman-Ford
1. **Lema de las pasadas (por inducción en $i$):** Tras $i$ pasadas sobre todas las aristas, para todo vértice $v$ y todo camino $P$ de $s$ a $v$ de a lo sumo $i$ aristas, vale $d[v] \le w(P)$.
2. **Caso sin ciclos negativos alcanzables:** Todo vértice alcanzable $v$ tiene un camino mínimo simple de a lo sumo $n - 1$ aristas. Por el lema, tras $n - 1$ pasadas vale $d[v] \le \delta(s, v)$, y como siempre $\delta(s, v) \le d[v]$, resulta $d[v] = \delta(s, v)$. Además, para toda arista $(u, v)$ se cumple $\delta(s, v) \le \delta(s, u) + w(u, v)$, por lo que ninguna arista se relaja en el chequeo final.
3. **Caso con ciclo negativo alcanzable $C = (v_0, v_1, \dots, v_k = v_0)$ con $w(C) < 0$:**
   - Supongamos por el absurdo que en el chequeo final ninguna arista de $C$ se relaja. Entonces para cada arista $(v_{r-1}, v_r) \in C$ vale:
     $$d[v_r] \le d[v_{r-1}] + w(v_{r-1}, v_r)$$
   - Sumando estas $k$ desigualdades a lo largo de todo el ciclo $C$:
     $$\sum_{r=1}^k d[v_r] \le \sum_{r=1}^k d[v_{r-1}] + \sum_{r=1}^k w(v_{r-1}, v_r)$$
   - Como $\sum_{r=1}^k d[v_r] = \sum_{r=1}^k d[v_{r-1}]$ (son exactamente los mismos vértices del ciclo y tienen $d < +\infty$ por ser alcanzables), restando esa suma en ambos miembros queda:
     $$0 \le \sum_{(u, v) \in C} w(u, v) = w(C) < 0$$
     ¡Absurdo! Por lo tanto, al menos una arista del ciclo $C$ puede seguir relajándose en la pasada $n$. $\blacksquare$

#### Cómo Reconstruir un Ciclo Negativo
Si en la pasada $n$-ésima el vértice $x$ ve mejorado su $d[x]$:
1. $x$ o bien pertenece a un ciclo negativo, o bien es alcanzable desde uno.
2. Retrocedemos **$n$ veces** siguiendo los punteros de predecesor: $y \leftarrow \pi[\pi[\dots \pi[x]\dots]]$ ($n$ pasos). Como cualquier camino simple tiene $< n$ aristas, el vértice $y$ está **garantizado de pertenecer al ciclo negativo**.
3. Desde $y$, seguimos retrocediendo con $\pi[\cdot]$ hasta volver a encontrar a $y$, e **invertimos la lista** de vértices para obtener el ciclo en el sentido correcto de las aristas.

---

### 3.4. Caminos Mínimos entre Todos los Pares (APSP): Floyd-Warshall y Dantzig — $O(n^3)$

#### Floyd-Warshall
Numeramos los vértices $V = \{1, 2, \dots, n\}$.
- **Definición del estado:** $D^{(k)}[i, j]$ = peso de un camino mínimo de $i$ a $j$ cuyos **vértices internos (intermedios)** pertenecen únicamente al subconjunto $\{1, 2, \dots, k\}$.
- **Caso base ($k = 0$, sin vértices intermedios):**
  $$D^{(0)}[i, j] = \begin{cases} 0 & \text{si } i = j \\ w(i, j) & \text{si } i \neq j \text{ y } (i, j) \in E \\ +\infty & \text{si } i \neq j \text{ y } (i, j) \notin E \end{cases}$$
- **Transición ($k = 1, \dots, n$):** Para ir de $i$ a $j$ usando intermedios en $\{1..k\}$, o bien no usamos al vértice $k$, o bien lo usamos una vez (dividiendo el camino en $i \leadsto k$ y $k \leadsto j$ con intermedios en $\{1..k-1\}$):
  $$D^{(k)}[i, j] = \min \left( D^{(k-1)}[i, j], \; D^{(k-1)}[i, k] + D^{(k-1)}[k, j] \right)$$
- **Implementación en $O(n^3)$ tiempo y $O(n^2)$ memoria (sobre una sola matriz):**
  ```cpp
  for (int k = 1; k <= n; ++k)
      for (int i = 1; i <= n; ++i)
          for (int j = 1; j <= n; ++j)
              if (D[i][k] < INF && D[k][j] < INF)
                  D[i][j] = min(D[i][j], D[i][k] + D[k][j]);
  ```
  *(¡Cuidado! El bucle externo **SIEMPRE** es `k`.)*
- **Detección de ciclos negativos en Floyd-Warshall:** Existe un ciclo de peso negativo en el grafo si y sólo si al terminar (o durante la ejecución) algún elemento de la diagonal queda negativo: **$D[i][i] < 0$ para algún $i$**.

#### Algoritmo de Dantzig
A diferencia de Floyd-Warshall (que en el paso $k$ ya tiene a todos los pares $(i, j) \in \{1..n\}^2$ y sólo restringe los *intermedios* a $\{1..k\}$), **Dantzig trabaja en el paso $k$ únicamente sobre la submatriz de $k \times k$ correspondiente al subgrafo inducido por $\{1, \dots, k\}$**:
1. En el paso $k$ (asumiendo ya calculadas las distancias mínimas $D^{(k-1)}[i, j]$ para todo $1 \le i, j \le k-1$):
   - Primero calcula las distancias mínimas desde y hacia el nuevo vértice $k$ para todo $1 \le i \le k-1$:
     $$D^{(k)}[i, k] = \min_{1 \le j \le k-1} \{ D^{(k-1)}[i, j] + w(j, k) \} \quad (O(k) \text{ por cada } i \implies O(k^2))$$
     $$D^{(k)}[k, j] = \min_{1 \le i \le k-1} \{ w(k, i) + D^{(k-1)}[i, j] \} \quad (O(k) \text{ por cada } j \implies O(k^2))$$
   - Verifica si $D^{(k)}[i, k] + D^{(k)}[k, i] < 0$ para algún $i < k$ (detección de ciclo negativo que pasa por $k$).
   - Actualiza el resto de los pares $1 \le i, j \le k-1$ pasando por $k$:
     $$D^{(k)}[i, j] = \min \left( D^{(k-1)}[i, j], \; D^{(k)}[i, k] + D^{(k)}[k, j] \right) \quad (O(k^2))$$
2. Complejidad total: $\sum_{k=1}^n O(k^2) = O(n^3)$ tiempo y $O(n^2)$ espacio.

---

## 4. Caja de Herramientas de Modelado con Caminos Mínimos (¡Lo más evaluado en el Parcial!)

> **Regla de Oro de la Cátedra (Clase Práctica 9):**  
> *"Evitar modificar los algoritmos que sabemos que funcionan (Dijkstra, Bellman-Ford, BFS), ya que si modificamos el algoritmo tenemos que demostrar desde cero su correctitud. En cambio, si **modificamos el grafo (modelado)** y corremos el algoritmo estándar como caja negra, sólo debemos demostrar que los caminos en el grafo modelado se corresponden con las soluciones del problema."*

### Técnica 1: Vértice Fantasma (Super-Origen / Múltiples Orígenes)
- **Cuándo usarla:**
  1. Queremos calcular para cada vértice $v$ su distancia al conjunto más cercano de orígenes/depósitos/policías $D \subseteq V$: $d_D(v) = \min_{w \in D} \delta(w, v)$ (*Ej. Policías, Ej. 1 Fantasmagórico, Ej. 11 Depósitos*).
  2. Queremos detectar si existe un ciclo negativo en **cualquier componente conexa** del grafo (no necesariamente alcanzable desde un nodo fijo), como en *Peaje / Ciclo Puré (Ej. 4)*.
- **Cómo armar el modelo:**
  - Agregar un nuevo vértice $z \notin V$ y aristas dirigidas $(z, w)$ de peso $0$ (o peso $1$ si usamos BFS sin pesos) hacia cada $w \in D$.
  - Correr una **única vez** BFS / Dijkstra / Bellman-Ford desde $z$.
- **Lema para demostrar correctitud:** Para todo $v \in V$, como las únicas aristas salientes de $z$ van hacia $s \in D$ con peso $0$, todo camino de $z$ a $v$ tiene la forma $z \to s \leadsto v$ con $s \in D$. Por subestructura óptima:
  $$\delta_{G'}(z, v) = \min_{s \in D} \{ w(z, s) + \delta_G(s, v) \} = \min_{s \in D} \delta_G(s, v)$$

---

### Técnica 2: Grafo Traspuesto ($G^R$) y "Correr desde ambos extremos ($s$ y $t$)"
- **Cuándo usarla:** Problemas donde necesitamos evaluar qué ocurre al forzar el paso por una arista especial $e = (u, v)$ (ej. *Recorridos acotados - Ej. 6, Julián y los Mares, Camino cuasi positivo - Ej. 7, Aristas superadoras - Ej. 17, st-eficiencia - Ej. 5*).
- **Cómo armar el modelo:**
  1. Correr Dijkstra (o Bellman-Ford) desde $s$ en $G$ $\implies$ obtenemos $d_s[u] = \delta_G(s, u)$ para todo $u$.
  2. Construir el digrafo traspuesto $G^R$ (invirtiendo todas las aristas en $O(n + m)$) y correr Dijkstra (o Bellman-Ford) desde $t$ en $G^R$ $\implies$ obtenemos $d_t[v] = \delta_G(v, t)$ para todo $v$.
  3. Ahora, para cualquier arista candidata $e = (u, v)$, el **mínimo peso de un recorrido de $s$ a $t$ que utiliza $e$** se consulta en **$O(1)$**:
     $$\text{costo}(s \leadsto u \xrightarrow{e} v \leadsto t) = d_s[u] + w(u, v) + d_t[v]$$
- **Aplicaciones directas de la Guía 8:**
  - **Aristas $st$-eficientes (Ej. 5) y DAG de caminos mínimos (*Lautaro y los Monstruos*):** Una arista $(u, v)$ pertenece a algún camino mínimo de $s$ a $t$ si y sólo si:
    $$d_s[u] + w(u, v) + d_t[v] = d_s[t]$$
  - **Aristas críticas entre $s$ y $t$ (Ej. 8):** Una arista $e$ hace crecer la distancia entre $s$ y $t$ al removerla ($d_G(s, t) < d_{G - e}(s, t)$) si y sólo si $e$ pertenece a **todos** los caminos mínimos de $s$ a $t$; es decir, si $e$ es un **puente** (arista de corte) entre $s$ y $t$ dentro del subgrafo (DAG) formado únicamente por las aristas $st$-eficientes.
  - **Aristas superadoras (Ej. 17):** Una nueva arista $e = (u, v)$ de peso $w(e)$ mejora la distancia de $s$ a $t$ si y sólo si $d_s[u] + w(e) + d_t[v] < d_s[t]$.
  - **Camino cuasi positivo (a lo sumo 1 arista negativa, Ej. 7):** Quitamos todas las aristas negativas, corremos Dijkstra desde $s$ en $G^+$ y desde $t$ en $(G^+)^R$, y tomamos:
    $$\min \left( d_s[t], \; \min_{e=(u,v) \text{ negativa}} \{ d_s[u] + w(u, v) + d_t[v] \} \right)$$

---

### Técnica 3: Multiplicación de Grafos / Grafo de Estados (Grafo por Niveles)
- **Cuándo usarla:** Cuando la validez o el costo de las transiciones depende de un **estado adicional acotado** (por ejemplo: paridad de la longitud del camino, resto módulo $k$, bit que recuerda qué hizo la cabina anterior, máscara de bits de comidas compradas, o cuál es la mejor bicicleta comprada hasta ahora).
- **Cómo armar el modelo:**
  - Definimos el conjunto de vértices del nuevo grafo como pares `(vértice_original, estado)`: $V' = V \times \text{Estados}$.
  - Definimos las aristas dirigidas entre estados según las reglas de transición del problema.
- **Ejemplos clave de la Guía 8 y Taller 3:**
  1. **Grilla Modular (Ej. 2):** Estado $(x, y, r)$ con $r \in [0, k)$. Hay $k \cdot m \cdot n$ vértices y $4kmn$ aristas. Se resuelve con BFS en $O(kmn)$.
  2. **Cabinas de Peaje Mixtas (Ej. 4.b):** Estado $(i, b)$ con $b \in \{0, 1\}$ indicando si la cabina $i$ cobró ($b=1$) o pagó ($b=0$). Tiene $2n + 1$ vértices y $2m + n$ aristas; Bellman-Ford tarda $O(n(n + m))$.
  3. **Recorridos de longitud par (Ej. 16):** Grafo bipartito $H$ con dos copias $v^0, v^1$ por cada vértice y aristas $u^0 \to v^1$ y $u^1 \to v^0$. Un camino de $s^0$ a $t^0$ en $H$ equivale exactamente a un recorrido de longitud par en $G$. (Tiene $2n$ vértices y $2m$ aristas $\implies O(n + m)$ con BFS, mucho mejor que armar $G^{=2}$ que puede tener $O(n^3)$ tiempo de construcción).
  4. **Comidas con Bitmask (Ej. 12):** Como hay $k$ tipos de comida ($k$ chico), el estado es $(u, \text{mask})$ con $\text{mask} \in [0, 2^k - 1]$ representando el subconjunto de comidas ya compradas. Al pasar por $v$, transicionamos a $(v, \text{mask} \mid C_v)$ con peso $s_i$. Corremos Dijkstra desde $(1, C_1)$ hasta $(n, 2^k - 1)$ en $O((n 2^k + m 2^k) \log(n 2^k))$.
  5. **Múltiplo especial (Ej. 19):** Encontrar el menor natural divisible por $d$ cuyos dígitos sumen $s$. Estado $(r, \text{suma})$ donde $r \in [0, d-1]$ es el resto módulo $d$ y $\text{suma} \in [0, s]$ es la suma de dígitos acumulada. Agregar un dígito $c \in \{0..9\}$ transiciona de $(r, \text{suma})$ a $((10r + c) \bmod d, \text{suma} + c)$. Con BFS desde $(0, 0)$ a $(0, s)$ en $O(d \cdot s)$ encontramos el de menor cantidad de dígitos y lexicográficamente menor.
  6. **Taller 3 - Problema B (*Juan y las Bicicletas*):** Estado $(u, b)$ donde $u$ es la ciudad actual y $b$ es la bicicleta de menor factor de lentitud $s_b$ comprada hasta el momento (o $s_b$ mismo). Desde $(u, s_b)$, al viajar por $(u, v)$ de peso $w$, vamos al estado $(v, \min(s_b, s_v))$ con costo $w \cdot s_b$. Se resuelve con Dijkstra sobre los $O(n^2)$ estados en $O(n(n + m) \log n)$.

---

### Técnica 4: Transformación de Pesos (Peso Multiplicativo $\to$ Logaritmos, Ej. 18)
- **Problema:** Encontrar un camino $v_1, \dots, v_k$ que minimice el **producto** de los pesos $\prod_{i=1}^{k-1} c(v_i, v_{i+1})$, donde $c(e) > 1$ para toda arista.
- **Modelado:** Definimos nuevos pesos aditivos $w(e) = \ln(c(e)) > 0$.
- **Justificación de correctitud:** Como la función $\ln(x)$ es **estrictamente creciente** y transforma productos en sumas:
  $$\ln \left( \prod_{e \in P} c(e) \right) = \sum_{e \in P} \ln(c(e)) = w(P)$$
  un camino $P$ minimiza el producto $\prod c(e)$ si y sólo si minimiza la suma $\sum \ln(c(e))$. Además, como $c(e) > 1 \implies \ln(c(e)) > 0$, todos los pesos son positivos y podemos aplicar **Dijkstra** directamente.

---

### Técnica 5: Puntaje Máximo con Ciclos Positivos (*Lautaro y los Monstruos* / Ej. 10 Puntajes)
- **Problema:** Ir del nodo $1$ al nodo $n$ maximizando la suma de puntajes, o detectar si se puede obtener **puntaje infinito** en un recorrido válido de $1$ a $n$.
- **Trampa clásica de examen:** Si multiplicamos los pesos por $-1$ y corremos Bellman-Ford desde $1$, Bellman-Ford devuelve `FALSO` si existe *cualquier* ciclo negativo alcanzable desde $1$. **¡Pero ese ciclo podría no llegar nunca al nodo destino $n$!**
- **Algoritmo correcto en 4 pasos:**
  1. Multiplicar todos los pesos por $-1$: $w'(e) = -p(e)$.
  2. En el grafo traspuesto $G^R$, correr un **DFS/BFS desde el destino $n$** para identificar todos los vértices que pueden alcanzar a $n$, y **eliminar del grafo todos los vértices que NO alcanzan a $n$**.
  3. Ahora sí, correr **Bellman-Ford desde $1$** en el subgrafo filtrado.
  4. Si Bellman-Ford detecta un ciclo negativo, como todo nodo del subgrafo alcanza a $n$ y el ciclo fue alcanzado desde $1$, existe puntaje infinito pasando por $n$ (y podemos reconstruir el camino $1 \leadsto C \leadsto n$). Si devuelve `VERDADERO`, el puntaje máximo es $-d[n]$.
