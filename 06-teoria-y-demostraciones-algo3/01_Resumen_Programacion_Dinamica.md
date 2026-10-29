# Guía de Estudio Exhaustiva: Programación Dinámica (PD)
**Materia:** Técnicas de Diseño de Algoritmos (TDA) / Algoritmos y Estructuras de Datos III — FCEyN, UBA  
**Unidad:** Segundo Parcial — Tema 1: Programación Dinámica (Top-Down y Bottom-Up)  
**Fuentes integradas:** Teórica 7, Clases Prácticas 6 y 7 (Diapositivas y Apunte Top-Down / Bottom-Up), Guía Práctica 6 completa.

---

## 1. Fundamentos Teóricos y Visión General

### 1.1. ¿Qué es la Programación Dinámica?
En el marco de la materia, la **Programación Dinámica (PD)** se introduce como un **tipo de poda inteligente sobre un algoritmo de Backtracking (recursivo)**:
- Cuando planteamos una función recursiva para resolver un problema de optimización o conteo, el árbol de llamadas recursivas suele tener un tamaño exponencial (por ejemplo, $O(2^n)$ o $O(3^n)$).
- Sin embargo, muchas ramas distintas del árbol llegan exactamente al **mismo subproblema** (mismo estado).
- La idea de PD consiste en **guardar el resultado asociado a cada estado** del árbol recursivo en una **estructura de memorización** (arreglo, matriz o diccionario) la primera vez que se calcula, y reutilizarlo en $O(1)$ (o $O(\log |E|)$) cada vez que se vuelva a necesitar.

---

### 1.2. Los 4 Pasos para Diseñar un Algoritmo de PD
Para justificar y diseñar correctamente una solución de Programación Dinámica en un examen de TDA, debés cumplir y explicitar estos **4 ingredientes fundamentales**:

1. **Identificación del Estado (Subproblemas):**
   - Encontrar un **conjunto minimal de parámetros** que describa completamente la instancia restante del problema, **olvidando el historial irrelevante** de qué decisiones nos llevaron hasta ahí.
   - *Regla de oro:* Menos parámetros = menos estados = menor complejidad temporal y espacial. Siempre preguntarse si algún parámetro se puede deducir de los otros (ej. en *Legiones del César*, $t = n_P + n_D$ es redundante).

2. **Función Recursiva y Principio de Optimalidad de Bellman:**
   - **Principio de Optimalidad (Subestructura Óptima):** El valor óptimo de un estado se puede construir combinando los valores óptimos de los subestados a los que transiciona.
   - Escribir matemáticamente la ecuación de recurrencia $f(\text{estado})$, especificando con claridad:
     - **Casos base** (y su orden de evaluación si hay casos inválidos como $-\infty$ o $+\infty$).
     - **Paso recursivo** (transiciones posibles: $\min$, $\max$, $\sum$, $\lor$).
     - **Llamado inicial** (ej. $f(n, W)$ o $f(0, 0)$).

3. **Superposición de Subproblemas (Cuándo conviene usar PD):**
   - **¡Atención para el parcial!** Para justificar que hay superposición de subproblemas **NO alcanza** con dibujar un ejemplo particular donde se repite un llamado recursivo.
   - La forma rigurosa exigida en la cátedra es **comparar asintóticamente**:
     $$|\text{Estados distintos alcanzables}| \ll |\text{Llamados recursivos totales del Backtracking}|$$
   - Si la cantidad de estados distintos es polinomial (ej. $\Theta(n^2)$ o $\Theta(nW)$) mientras que el árbol recursivo sin memoria tiene tamaño exponencial (ej. $\Theta(2^n)$), entonces la memorización evita una cantidad masiva de recálculos.

4. **Estructura de Memorización y Esquema de Evaluación:**
   - Elegir cómo almacenar los estados (vector, matriz multidimensional o diccionario/ABB) y el enfoque de cómputo (**Top-Down** o **Bottom-Up**).

---

### 1.3. Análisis de Complejidad en Programación Dinámica

#### Fórmula General del Tiempo de Ejecución
$$\text{Tiempo Total} = O(\text{Inicialización de la estructura}) + O\left(\sum_{S \in \text{Estados}} \text{costo\_transición}(S)\right)$$
donde $\text{costo\_transición}(S)$ es el costo de calcular el estado $S$ **asumiendo que las llamadas recursivas a sus subestados ya están calculadas y devuelven su valor en $O(1)$** (o el costo de acceso a la estructura).

- **Cota estándar (uniforme):** Si hay $|E|$ estados y cada estado realiza a lo sumo $O(C)$ operaciones (por ejemplo, un ciclo `for` de largo $C$ o tomar el máximo entre $O(1)$ opciones):
  $$T = \Theta(|E| \cdot C)$$
- **Cota fina / amortizada (suma de grados):** En problemas sobre grafos (como caminos en un DAG), el costo de transición de un estado $v$ depende de su grado $d_{in}(v)$ o $d_{out}(v)$. Acotar por $O(n)$ cada estado daría $O(n^2)$, pero sumando sobre todos los estados:
  $$T = O(n) + \sum_{v \in V} O(1 + |N(v)|) = \Theta(n + m)$$

#### Elección de la Estructura de Memorización

| Estructura | Inicialización | Acceso / Escritura | Espacio | ¿Cuándo usarla? |
| :--- | :--- | :--- | :--- | :--- |
| **Vector / Matriz (Arreglo directo)** | $\Theta(|E|)$ | $O(1)$ peor caso | $\Theta(|E|)$ | **Por defecto siempre que los parámetros sean enteros acotados** ($0 \dots n$, $0 \dots W$). |
| **Diccionario (ABB / `std::map`)** | $O(1)$ | $O(\text{costo\_cmp} \cdot \log |E_{alc}|)$ | $\Theta(|E_{alc}|)$ | Cuando el espacio potencial $|E|$ es gigantesco (ej. $W = 2^n$) pero la cantidad de estados efectivamente alcanzables $|E_{alc}|$ es pequeña. |
| **Tabla de Hash (`unordered_map`)** | $O(1)$ | $O(\text{costo\_hash})$ promedio | $\Theta(|E_{alc}|)$ | Similar al ABB, pero en análisis teórico de peor caso la cátedra prefiere matrices ($O(1)$) o ABB ($O(\log |E|)$). |

> **Nota crítica sobre claves no elementales:** Si el estado es un subconjunto $U \subseteq V$ (vector booleano o conjunto de tamaño $O(n)$), hashear o comparar dos claves cuesta $O(n)$, no $O(1)$.

---

### 1.4. Top-Down (Memoización) vs. Bottom-Up (Tabulación)

| Característica | Top-Down (Recursivo con Memoización) | Bottom-Up (Iterativo por Tabulación) |
| :--- | :--- | :--- |
| **Dirección** | Desde el problema original hacia los casos base. | Desde los casos base hacia el problema original. |
| **Estados evaluados** | Calcula **únicamente** los estados alcanzables desde la llamada inicial. | Llena toda la tabla sistemáticamente (incluso estados inalcanzables). |
| **Orden de evaluación** | Implícito (el *call stack* de la recursión resuelve las dependencias automáticamente). | Explícito: el programador debe recorrer los estados en un **orden topológico del DAG de dependencias**. |
| **Uso de Memoria** | Tabla $M$ + Pila de recursión $O(\text{profundidad del árbol})$. | Solo la tabla $M$. **Permite optimizar espacio** (ej. de $O(nW)$ a $O(W)$, o de $O(n)$ a $O(1)$) descartando filas viejas. |
| **Constantes ocultas** | Mayor overhead por llamadas a funciones y recursión. | Más rápido en la práctica (bucles `for` contiguos en caché). |

#### El Grafo de Dependencias de Estados
Si pensamos a cada estado como un vértice y ponemos una arista dirigida $S_1 \to S_2$ cuando para calcular $S_2$ necesitamos el valor de $S_1$:
- Para que la PD esté bien definida, el grafo de dependencias **debe ser un DAG (grafo dirigido acíclico)**. Si hubiera un ciclo, la recursión sería infinita.
- En **Bottom-Up**, llenar la tabla consiste en procesar los estados siguiendo un **orden topológico** de este DAG (es decir, cuando vamos a calcular `M[i][j]`, todas las celdas de las que depende ya deben haber sido llenadas en iteraciones previas).

---

### 1.5. Reconstrucción de la Solución Óptima (Armado de la Solución)
**Principio de diseño fundamental de la cátedra:**
1. **Nunca** guardes la solución parcial (listas, vectores de objetos) dentro de los parámetros de la función recursiva ni como valor de retorno de cada celda de la matriz (eso multiplicaría la complejidad temporal y espacial por $O(n)$).
2. **Paso 1:** Diseñá la PD para que calcule **únicamente el valor óptimo** (un número o booleano).
3. **Paso 2:** Una vez llena la estructura de memorización $M$, reconstruí la secuencia de decisiones óptimas mediante una de dos estrategias:
   - **Estrategia A (Recorrido hacia atrás sobre la misma tabla $M$):** Empezando desde el estado inicial (ej. $(n, W)$), mirar los subestados candidatos a los que podía transicionar y verificar cuál de ellos iguala el valor guardado en $M[\text{actual}]$. Avanzar a ese subestado y repetir hasta llegar al caso base. **No requiere memoria extra**, pero **prohíbe borrar filas anteriores** de la tabla $M$.
   - **Estrategia B (Tabla auxiliar de decisiones / punteros $S$):** Durante el cálculo de $M[\text{estado}]$, guardar en una tabla paralela $S[\text{estado}]$ qué índice o decisión $k$ alcanzó el óptimo (ej. en Multiplicación de Matrices, $S[i, j] = k$). Permite reconstruir en $O(1)$ por paso sin volver a iterar sobre los candidatos.

---

## 2. Plantillas de Código y Esquemas Algorítmicos

### 2.1. Plantilla General Top-Down (C++)
```cpp
// Inicializar memo con un valor que NO pueda ser respuesta válida (ej. -1)
vector<vector<long long>> memo(N + 1, vector<long long>(W + 1, -1));

long long pd_top_down(int i, int w) {
    // 1. Casos base de invalidez (poda por factibilidad)
    if (w < 0) return -INF; 
    // 2. Casos base de terminación
    if (i == 0) return 0;

    // 3. Consulta a la estructura de memorización
    if (memo[i][w] != -1) return memo[i][w];

    // 4. Transición recursiva (Principio de Optimalidad)
    long long no_poner = pd_top_down(i - 1, w);
    long long poner    = b[i] + pd_top_down(i - 1, w - a[i]);

    // 5. Guardar y devolver
    return memo[i][w] = max(no_poner, poner);
}
```

### 2.2. Plantilla General Bottom-Up + Optimización de Espacio (C++)
Cuando la fila `i` depende **únicamente** de la fila `i - 1`, podemos reducir el espacio de $O(n \cdot W)$ a $O(W)$ usando dos vectores (`prev` y `curr`) o recorriendo `w` de derecha a izquierda:
```cpp
// Versión con 2 filas: O(n * W) tiempo, O(W) espacio auxiliar
long long pd_bottom_up_espacio_optimizado(int n, int W, const vector<int>& a, const vector<long long>& b) {
    vector<long long> prev(W + 1, 0), curr(W + 1, 0);
    for (int i = 1; i <= n; ++i) {
        for (int w = 0; w <= W; ++w) {
            curr[w] = prev[w]; // No usar el objeto i
            if (w - a[i] >= 0) {
                curr[w] = max(curr[w], b[i] + prev[w - a[i]]); // Usar el objeto i
            }
        }
        prev = curr;
    }
    return prev[W];
}
```

### 2.3. Plantilla de Reconstrucción de Solución (Mochila 0-1)
```cpp
// Requiere tener la matriz completa M[0..n][0..W] calculada: O(n) tiempo
vector<int> reconstruir_mochila(int n, int W, const vector<int>& a, const vector<vector<long long>>& M) {
    vector<int> elegidos;
    int i = n, w = W;
    while (i > 0) {
        // Si el valor cambió respecto a no considerar el objeto i, entonces lo usamos
        if (M[i][w] > M[i - 1][w]) {
            elegidos.push_back(i);
            w -= a[i];
        }
        i--;
    }
    reverse(elegidos.begin(), elegidos.end());
    return elegidos;
}
```

---

## 3. Problemas Clásicos de la Teórica 7

### 3.1. Problema de la Mochila 0-1 (Knapsack)
- **Enunciado:** Dados $n$ objetos con pesos enteros $a_1, \dots, a_n > 0$ y beneficios $b_1, \dots, b_n \ge 0$, y una capacidad máxima $W \in \mathbb{N}$, hallar un subconjunto $S \subseteq \{1, \dots, n\}$ con $\sum_{i \in S} a_i \le W$ que maximice $\sum_{i \in S} b_i$.
- **Estado:** $(i, w)$ con $0 \le i \le n$, $0 \le w \le W$, que representa el subproblema de elegir entre los primeros $i$ objetos $\{1, \dots, i\}$ con capacidad disponible $w$.
- **Recurrencia:**
  $$F(i, w) = \begin{cases} -\infty & \text{si } w < 0 \\ 0 & \text{si } i = 0 \text{ y } w \ge 0 \\ \max\big\{F(i-1, w),\ b_i + F(i-1, w - a_i)\big\} & \text{si } i > 0 \text{ y } w \ge 0 \end{cases}$$
  - **Llamado inicial:** $F(n, W)$.
- **Complejidad y Discusión Teórica (¡Pregunta típica de examen!):**
  - **Backtracking puro:** Tiempo $O(2^n)$, Espacio $O(n)$.
  - **PD con matriz:** Hay $|E| = (n+1)(W+1) = \Theta(nW)$ estados. Cada estado cuesta $O(1)$.
    - **Tiempo:** $\Theta(nW)$.
    - **Espacio:** $\Theta(nW)$ (o $\Theta(W)$ en Bottom-Up si solo queremos el valor máximo sin reconstruir el conjunto).
  - **¿Es $\Theta(nW)$ siempre mejor que $O(2^n)$?**
    - **NO.** Son incomparables a priori porque $W$ es un número de la entrada (cuya representación en binario ocupa $\log_2 W$ bits). Por eso $\Theta(nW)$ es una complejidad **pseudopolinomial**.
    - Si $W \ll 2^n / n$ (por ejemplo, $W = O(n^4)$), entonces PD en $\Theta(nW) = O(n^5)$ es muchísimo más rápida que $O(2^n)$.
    - Si $W = 2^n$, inicializar y llenar la matriz toma $\Theta(n 2^n)$ tiempo y $\Theta(n 2^n)$ memoria, lo cual es **peor** que el Backtracking básico (que tardaba $O(2^n)$ tiempo y usaba solo $O(n)$ memoria). En ese caso, si hay pocos pesos posibles alcanzables, convendría Top-Down con un **diccionario (ABB)** en lugar de una matriz.

---

### 3.2. Corte de Varillas (Rod Cutting)
- **Enunciado:** Dada una varilla de longitud entera $n$ y una tabla de precios $p_1, \dots, p_n$ (donde $p_i$ es el precio de vender un trozo de largo $i$), determinar cómo cortarla en trozos de longitud entera para maximizar la ganancia total.
- **Estado:** $\ell \in \{0, 1, \dots, n\}$, el largo restante de la varilla por cortar.
- **Recurrencia:**
  $$R(\ell) = \begin{cases} 0 & \text{si } \ell = 0 \\ \max_{1 \le k \le \ell} \big\{p_k + R(\ell - k)\big\} & \text{si } \ell > 0 \end{cases}$$
  - **Llamado inicial:** $R(n)$.
- **Superposición y Complejidad:**
  - **Backtracking:** La cantidad de llamados cumple $C(\ell) = 1 + \sum_{j=0}^{\ell-1} C(j) = 2^\ell$, por lo que el tiempo sin memorizar es $\Theta(n 2^n)$.
  - **Con PD (Top-Down o Bottom-Up):**
    - Cantidad de estados: $\Theta(n)$.
    - Costo de transición del estado $\ell$: iterar $k$ de $1$ a $\ell$ cuesta $\Theta(\ell) = O(n)$.
    - **Tiempo total:** $\sum_{\ell=1}^n \Theta(\ell) = \Theta\left(\frac{n(n+1)}{2}\right) = \Theta(n^2)$.
    - **Espacio:** $\Theta(n)$ para el vector $M[0 \dots n]$.
  - **Reconstrucción:** Desde $\ell = n$, mientras $\ell > 0$, buscamos $k \in \{1, \dots, \ell\}$ tal que $M[\ell] == p_k + M[\ell - k]$ (en $O(\ell)$), agregamos el corte $k$ y hacemos $\ell \leftarrow \ell - k$. Tiempo de reconstrucción: $O(n^2)$ sin memoria extra, o $O(n)$ si guardamos en un arreglo `primer_corte[l] = k` durante la PD.

---

### 3.3. Multiplicación en Cadena de Matrices (Parentización Óptima)
- **Enunciado:** Dadas $n$ matrices $A_1, A_2, \dots, A_n$ donde $A_i$ tiene dimensión $d_{i-1} \times d_i$ (dadas por el vector $d_0, d_1, \dots, d_n$), hallar la forma de asociar (parentizar) el producto $A_1 \cdot A_2 \cdots A_n$ que minimice la cantidad total de multiplicaciones escalares, sabiendo que multiplicar una matriz de $a \times b$ por una de $b \times c$ cuesta $a \cdot b \cdot c$.
- **Estado:** Par de índices $(i, j)$ con $1 \le i \le j \le n$, que representa el subproblema de multiplicar la subcadena de matrices $A_i A_{i+1} \cdots A_j$ (cuyo resultado tiene dimensión $d_{i-1} \times d_j$).
- **Recurrencia (probando dónde hacer el último producto $k$):**
  $$m(i, j) = \begin{cases} 0 & \text{si } i = j \\ \min_{i \le k < j} \big\{m(i, k) + m(k+1, j) + d_{i-1} \cdot d_k \cdot d_j\big\} & \text{si } i < j \end{cases}$$
  - **Llamado inicial:** $m(1, n)$.
- **Superposición y Complejidad:**
  - **Backtracking:** Para un intervalo de largo $\ell = j - i + 1$, $C(\ell) = 1 + 2\sum_{s=1}^{\ell-1} C(s) = 3^{\ell-1} \implies$ Tiempo $\Theta(n 3^n)$.
  - **Con PD:**
    - Cantidad de estados: $\frac{n(n+1)}{2} = \Theta(n^2)$ celdas (triángulo superior de la matriz $n \times n$).
    - Costo de transición por estado $(i, j)$: probar $j - i = O(n)$ valores de $k$.
    - **Tiempo total:** $\Theta(n^3)$.
    - **Espacio:** $\Theta(n^2)$. (Nota: acá **no** se puede bajar el espacio a $O(n)$ porque calcular una diagonal requiere acceder a **todas** las diagonales previas).
- **Órdenes válidos de llenado en Bottom-Up:**
  Para que al calcular $m[i][j]$ ya estén listos $m[i][k]$ (misma fila, columna a la izquierda) y $m[k+1][j]$ (misma columna, fila más abajo), podemos llenar el triángulo superior:
  1. **Por diagonales (longitud del intervalo $L = j - i + 1$ creciente de $2$ a $n$):**
     ```cpp
     for (int L = 2; L <= n; ++L) {
         for (int i = 1; i <= n - L + 1; ++i) {
             int j = i + L - 1;
             M[i][j] = INF;
             for (int k = i; k < j; ++k) {
                 long long q = M[i][k] + M[k + 1][j] + 1LL * d[i - 1] * d[k] * d[j];
                 if (q < M[i][j]) {
                     M[i][j] = q;
                     S[i][j] = k; // Guardar punto de corte óptimo
                 }
             }
         }
     }
     ```
  2. **Por filas de abajo hacia arriba:** $i$ desde $n-1$ bajando hasta $1$, y para cada $i$, $j$ desde $i+1$ hasta $n$.
  3. **Por columnas de izquierda a derecha:** $j$ desde $2$ hasta $n$, y para cada $j$, $i$ desde $j-1$ bajando hasta $1$.
- **Reconstrucción en $O(n)$ con la matriz $S$:**
  ```cpp
  void imprimir_parentesis(int i, int j, const vector<vector<int>>& S) {
      if (i == j) { cout << "A" << i; return; }
      cout << "(";
      imprimir_parentesis(i, S[i][j], S);
      imprimir_parentesis(S[i][j] + 1, j, S);
      cout << ")";
  }
  ```

---

### 3.4. Conjunto Independiente Máximo en Grafos Generales (Cuándo NO sirve PD)
- **Enunciado:** Dado un grafo $G = (V, E)$, hallar el tamaño del mayor subconjunto $I \subseteq V$ tal que no haya dos vértices en $I$ unidos por una arista.
- **Recurrencia:** Para un subconjunto de vértices disponibles $U \subseteq V$, eligiendo $v = \min(U)$:
  $$F(U) = \begin{cases} 0 & \text{si } U = \emptyset \\ \max\big\{F(U \setminus \{v\}),\ 1 + F(U \setminus N_G[v])\big\} & \text{si } U \neq \emptyset \end{cases}$$
  donde $N_G[v] = \{v\} \cup \{w \in V : vw \in E\}$ es la vecindad cerrada de $v$.
- **¿Por qué fracasa PD en el caso general?**
  - **Backtracking:** Toma tiempo $O(n 2^n)$ y espacio $O(n)$.
  - **PD:** La cantidad de subconjuntos posibles $U \subseteq V$ es $2^n$. Incluso codificando $U$ como un entero de $n$ bits (o llenando en Bottom-Up por cardinalidad $|U| = s$ de $1$ a $n$), la tabla tiene $\Theta(2^n)$ estados y operar con conjuntos cuesta $O(n)$.
  - **Resultado:** Tiempo $O(n 2^n)$ y **Espacio $\Theta(2^n)$ (o $\Theta(n 2^n)$)**.
  - **Moraleja para el examen:** La PD no mágicamente acelera cualquier backtracking. Si el espacio de estados distintos tiene el mismo orden exponencial que el árbol de llamadas ($|\text{Estados}| \approx |\text{Llamados}|$), **no hay suficiente superposición de subproblemas** y aplicar PD solo arruina la complejidad espacial sin mejorar el tiempo. *(En cambio, si el grafo fuera un árbol, el estado sería solo el nodo raíz del subárbol y un booleano $\implies 2n$ estados $\implies O(n)$ tiempo).*

---

## 4. Plantillas de Demostración de Correctitud en PD

En las clases prácticas (ej. Clase 6, Apunte Top-Down) se exige demostrar formalmente por **inducción matemática** que la función recursiva calcula lo pedido. Acá tenés las dos plantillas oficiales del curso:

### 4.1. Plantilla 1: Inducción sobre el parámetro de etapa (Ej. OptiPago / Mochila / Subset Sum)
**Objetivo:** Probar que para todo $i \in \{0, \dots, n\}$ vale el predicado:
$$P(i): \forall j \in \mathbb{Z}, \quad f(i, j) \text{ devuelve el valor óptimo para cubrir } j \text{ usando un subconjunto de } \{b_1, \dots, b_i\}.$$

- **Caso Base ($i = 0$):**
  - El conjunto de elementos disponibles es $\emptyset$.
  - Si $j \le 0$, ya está cubierto con costo $0$, y la función devuelve el neutro (ej. $(0, 0)$ o `true`).
  - Si $j > 0$, es imposible cubrirlo sin elementos, y la función devuelve el elemento absorbente (ej. $(\infty, \infty)$ o `false`). Por lo tanto, $P(0)$ es verdadero.
- **Paso Inductivo ($P(i-1) \implies P(i)$ para $1 \le i \le n$):**
  - **Hipótesis Inductiva (HI):** Supongamos que para $i-1$ y para todo $j' \in \mathbb{Z}$, $f(i-1, j')$ calcula correctamente el óptimo usando $\{b_1, \dots, b_{i-1}\}$.
  - Sea $j \in \mathbb{Z}$ arbitrario.
    - Si $j \le 0$, entra en el caso base y devuelve correctamente el óptimo.
    - Si $j > 0$, el conjunto de soluciones factibles con $\{b_1, \dots, b_i\}$ se particiona en dos subconjuntos disjuntos:
      1. **Soluciones que NO usan $b_i$:** Son exactamente las soluciones para cubrir $j$ con $\{b_1, \dots, b_{i-1}\}$. Por HI aplicada a $j' = j$, la mejor de ellas tiene valor $f(i-1, j)$.
      2. **Soluciones que SÍ usan $b_i$:** Al incluir $b_i$, el resto de los elementos pertenece a $\{b_1, \dots, b_{i-1}\}$ y debe cubrir en forma óptima al menos $j - b_i$. Por HI aplicada a $j' = j - b_i$ y la subestructura óptima, la mejor de ellas tiene valor $b_i \oplus f(i-1, j - b_i)$.
    - Como la recurrencia toma el $\min$ (o $\max$) entre ambos casos exhaustivos, $f(i, j)$ es óptimo. Vale $P(i)$. $\blacksquare$

### 4.2. Plantilla 2: Inducción Fuerte sobre el Orden Topológico de un DAG (Ej. Contar caminos / Camino mínimo en DAG)
**Objetivo:** Dado un DAG $G = (V, E)$, existe un ordenamiento topológico de sus vértices $v_1, v_2, \dots, v_n$ tal que toda arista $(v_j, v_k) \in E$ cumple $j < k$. Probamos por **inducción fuerte** sobre la posición $k \in \{1, \dots, n\}$ del orden topológico:
$$P(k): f(v_k) \text{ calcula correctamente la cantidad de caminos (o camino mínimo) desde } s \text{ hasta } v_k.$$

- **Caso Base ($k = 1$):**
  - El primer vértice $v_1$ del orden topológico tiene grado de entrada $0$ ($N^-(v_1) = \emptyset$).
  - Si $v_1 = s$, el único camino de $s$ a $s$ es el trivial de longitud 0, y por caso base $f(s) = 1$ (o $0$ para distancias).
  - Si $v_1 \neq s$, no hay caminos de $s$ a $v_1$, y la sumatoria/mínimo sobre $N^-(v_1) = \emptyset$ devuelve el neutro $0$ (o $+\infty$). Vale $P(1)$.
- **Paso Inductivo ($\forall j \le k, P(j) \implies P(k+1)$):**
  - **HI:** Para todo $j \in \{1, \dots, k\}$, $f(v_j)$ es correcto.
  - Consideremos $v_{k+1}$. Si $v_{k+1} = s$, vale por el caso base explícito de la función (ya que en un DAG no hay ciclos que vuelvan a $s$).
  - Si $v_{k+1} \neq s$, todo camino de $s$ a $v_{k+1}$ tiene al menos una arista y se descompone de manera única según su penúltimo vértice $w \in N^-(v_{k+1})$ como un camino de $s$ a $w$ seguido de la arista $(w, v_{k+1})$.
  - Como $v_1, \dots, v_n$ es un orden topológico y $(w, v_{k+1}) \in E$, necesariamente $w = v_j$ con **$j \le k$**.
  - Por lo tanto, podemos aplicar la **Hipótesis Inductiva** a todos los $w \in N^-(v_{k+1})$, concluyendo que $f(v_{k+1}) = \sum_{w \in N^-(v_{k+1})} f(w)$ es correcto. $\blacksquare$

---

## 5. Resolución y Modelado de Todos los Problemas de la Guía Práctica 6

### Ejercicio 1: El ejército del rey (Fibonacci)
- **Problema:** Calcular $f(n)$ donde $f(0) = 1, f(1) = 1$ y $f(i) = f(i-1) + f(i-2)$ para $i \ge 2$.
- **Backtracking:** Árbol binario de llamadas con hojas de valor 1 $\implies \sum \text{hojas} = f(n) \ge 2^{n/2}$ (exactamente $\Theta(\phi^n)$ con $\phi = \frac{1+\sqrt{5}}{2}$).
- **PD Top-Down / Bottom-Up:** $n+1$ estados, transición $O(1) \implies$ Tiempo $\Theta(n)$, Espacio $\Theta(n)$.
- **Optimización de espacio (Bottom-Up):** Como $f(i)$ solo depende de los 2 anteriores, guardamos solo `prev2` y `prev1` $\implies$ Tiempo $\Theta(n)$, **Espacio $O(1)$**.

---

### Ejercicio 2: Vacaciones
- **Problema:** En $n$ días de vacaciones, para cada día $i$ sabemos si abre el gimnasio ($G_i \in \{0,1\}$) y si hay competencia ($C_i \in \{0,1\}$). No se puede hacer gimnasio dos días seguidos ni competir dos días seguidos. Minimizar la cantidad de días de descanso.
- **Modelado del Estado:** Para decidir qué hacer en el día `i`, solo necesitamos saber qué hicimos en el día `i-1`.
  - Estado: `(dia, act_ayer)` donde `dia` $\in \{0, \dots, n\}$ y `act_ayer` $\in \{0 \text{ (Descanso)}, 1 \text{ (Gimnasio)}, 2 \text{ (Competencia)}\}$.
- **Recurrencia:**
  $$\text{vac}(i, \text{ayer}) = \begin{cases} 0 & \text{si } i = n \\ \min \begin{cases} 1 + \text{vac}(i+1, \text{Descanso}), \\ \text{vac}(i+1, \text{Gim}) & \text{si } G_i \land \text{ayer} \neq \text{Gim}, \\ \text{vac}(i+1, \text{Comp}) & \text{si } C_i \land \text{ayer} \neq \text{Comp} \end{cases} & \text{si } i < n \end{cases}$$
- **Complejidad:** $3n$ estados, transición $O(1) \implies$ Tiempo $\Theta(n)$, Espacio $\Theta(n)$ (o $O(1)$ en Bottom-Up guardando los 3 valores del día anterior).

---

### Ejercicio 3: Suma Subconjuntos (Subset Sum)
- **Problema:** Dado un multiconjunto $C = \{c_1, \dots, c_n\}$ de naturales y un objetivo $k \in \mathbb{N}$, decidir si existe un subconjunto que sume exactamente $k$.
- **Estado:** $(i, j)$ con $0 \le i \le n$ y $0 \le j \le k$.
- **Recurrencia:**
  $$ss(i, j) = \begin{cases} \text{true} & \text{si } j = 0 \\ \text{false} & \text{si } j \neq 0 \land (i = 0 \lor j < 0) \\ ss(i-1, j) \lor ss(i-1, j - c_i) & \text{si } i > 0 \land j > 0 \end{cases}$$
- **Complejidad:** Tiempo $\Theta(nk)$, Espacio $\Theta(nk)$ (o $\Theta(k)$ en Bottom-Up recorriendo $j$ de $k$ bajando hasta $c_i$).
- **Comparación con Backtracking:**Conviene PD cuando $n \cdot k \ll 2^n$. Si $k \gg 2^n$, la tabla tiene muchas columnas nunca visitadas y es mejor BT o Top-Down con diccionario.

---

### Ejercicio 4: Caminos en un DAG
- **Problema:** Dado un DAG $G = (V, E)$ y dos vértices $s, t$, contar la cantidad de caminos dirigidos de $s$ a $t$.
- **Estado:** Vértice $v \in V$.
- **Recurrencia (yendo hacia atrás desde $t$):**
  $$f(v) = \begin{cases} 1 & \text{si } v = s \\ \sum_{w \in N^-(v)} f(w) & \text{si } v \neq s \end{cases}$$
  Llamado inicial: $f(t)$. *(Alternativa simétrica: $g(v) = 1$ si $v = t$; $\sum_{w \in N^+(v)} g(w)$ si $v \neq t$, llamando a $g(s)$).*
- **Complejidad:**
  $$\text{Tiempo} = \Theta(n) \text{ (inicializar memo)} + \sum_{v \in V} O(1 + d_{in}(v)) = \Theta(n + m), \quad \text{Espacio} = \Theta(n).$$

---

### Ejercicio 5: OptiPago
- **Problema:** Dado un multiconjunto de billetes $B = \{b_1, \dots, b_n\}$ y un costo $c$, pagar al menos $c$ minimizando primero el monto total pagado $c' \ge c$ (mínimo exceso) y, a igual monto, minimizando la cantidad de billetes usados.
- **Truco de modelado (Orden Lexicográfico):** Devolver un par `(monto_pagado, cant_billetes)` y usar el mínimo lexicográfico $\min_{lex}$ entre pares, definiendo la suma coordenada a coordenada $(m, k) \oplus (b_i, 1) = (m + b_i, k + 1)$.
- **Estado:** $(i, j)$ con $0 \le i \le n$ (billetes disponibles $\{b_1, \dots, b_i\}$) y $0 \le j \le c$ (monto restante por cubrir).
- **Recurrencia:**
  $$\text{opti}(i, j) = \begin{cases} (0, 0) & \text{si } j \le 0 \\ (\infty, \infty) & \text{si } j > 0 \land i = 0 \\ \min_{lex}\big\{\text{opti}(i-1, j),\ \text{opti}(i-1, j - b_i) \oplus (b_i, 1)\big\} & \text{si } j > 0 \land i > 0 \end{cases}$$
- **Complejidad:** Tiempo $\Theta(n \cdot c)$, Espacio $\Theta(n \cdot c)$ (o $\Theta(c)$ en Bottom-Up con 2 filas).

---

### Ejercicio 6: AstroTrade
- **Problema:** Durante $n$ días conocemos el precio $p_j$ de un asteroide en el día $j$. Por día se puede comprar 1, vender 1, o no hacer nada. Nunca se puede tener cantidad negativa de asteroides, y al final del día $n$ debemos tener 0 asteroides. Maximizar la ganancia neta.
- **Estado:** `(dia, cant_asteroides)` con `dia` $\in \{0, \dots, n\}$ y `cant` $\in \{0, \dots, \lfloor n/2 \rfloor + 1\}$ (nunca tiene sentido acumular más de $n/2$ asteroides porque no daría el tiempo para venderlos todos antes del día $n$).
- **Recurrencia:**
  $$A(d, c) = \begin{cases} -\infty & \text{si } c < 0 \lor c > n - d \\ 0 & \text{si } d = n \land c = 0 \\ \max\big\{A(d+1, c),\ A(d+1, c+1) - p_d,\ A(d+1, c-1) + p_d\big\} & \text{si } 0 \le d < n \end{cases}$$
  - Llamado inicial: $A(0, 0)$.
- **Complejidad:** $\Theta(n^2)$ estados, transición $O(1) \implies$ Tiempo $\Theta(n^2)$, Espacio $\Theta(n^2)$ (o $\Theta(n)$ en Bottom-Up).

---

### Ejercicio 7: Cortes Económicos (Cutting Sticks)
- **Problema:** Cortar una vara de longitud $\ell$ en $m$ puntos específicos dados $C = \{c_1, \dots, c_m\}$. Cortar un trozo de longitud $L$ cuesta $L$ monedas. El orden de los cortes altera el costo total. Minimizar el costo.
- **Truco clave de modelado:** ¡No indexar el estado por metros $[0 \dots \ell]$ sino por los **índices de los cortes**!
  - Ordenamos los cortes y agregamos los extremos de la vara: $0 = c_0 < c_1 < c_2 < \dots < c_m < c_{m+1} = \ell$.
  - **Estado:** $(i, j)$ con $0 \le i < j \le m+1$, que representa el costo mínimo de realizar todos los cortes pendientes dentro del segmento $[c_i, c_j]$.
- **Recurrencia:**
  $$M(i, j) = \begin{cases} 0 & \text{si } j = i + 1 \text{ (no hay cortes intermedios)} \\ (c_j - c_i) + \min_{i < k < j} \big\{M(i, k) + M(k, j)\big\} & \text{si } j > i + 1 \end{cases}$$
  - Llamado inicial: $M(0, m+1)$.
- **Complejidad:** $\Theta(m^2)$ estados, cada uno itera $k \in (i, j)$ en $O(m) \implies$ **Tiempo $\Theta(m^3)$, Espacio $\Theta(m^2)$** (independiente de $\ell$). En Bottom-Up se llena por longitud de intervalo $d = j - i$ de $1$ a $m+1$.

---

### Ejercicio 8: Mi Buenos Aires Crecido (LIS Ponderado)
- **Problema:** Dados $N$ edificios con alturas $h_1, \dots, h_N$ y anchos $w_1, \dots, w_N$, hallar una subsecuencia de índices $i_1 < i_2 < \dots < i_k$ con alturas estrictamente crecientes ($h_{i_1} < h_{i_2} < \dots < h_{i_k}$) que maximice la suma de anchos $\sum_{j=1}^k w_{i_j}$ (y otra decreciente, quedándose con la mejor).
- **Estado:** `(act, ult)` donde `act` $\in \{1, \dots, N+1\}$ es el edificio actual y `ult` $\in \{0, \dots, N\}$ es el índice del último edificio elegido (con $h_0 = -\infty$).
- **Recurrencia:**
  $$f(\text{act}, \text{ult}) = \begin{cases} 0 & \text{si } \text{act} = N + 1 \\ f(\text{act}+1, \text{ult}) & \text{si } h_{\text{act}} \le h_{\text{ult}} \\ \max\big\{f(\text{act}+1, \text{ult}),\ w_{\text{act}} + f(\text{act}+1, \text{act})\big\} & \text{si } h_{\text{act}} > h_{\text{ult}} \end{cases}$$
- **Complejidad:** $\Theta(N^2)$ tiempo y $\Theta(N)$ espacio en Bottom-Up (también formulable en 1D definiendo $DP[i] =$ máxima suma de subsecuencia creciente que termina exactamente en el edificio $i$: $DP[i] = w_i + \max(\{0\} \cup \{DP[j] : j < i \land h_j < h_i\})$, que toma $\Theta(N^2)$ tiempo y $\Theta(N)$ espacio).

---

### Ejercicio 9: Travesía Vital (Dungeon Game)
- **Problema:** Grilla $A$ de $m \times n$ con enteros positivos, negativos o cero. Empezamos en $(1, 1)$ y vamos a $(m, n)$ moviéndonos solo abajo o a la derecha. En cada celda sumamos $A_{i,j}$ a nuestra vida. En todo momento la vida debe ser $\ge 1$. Hallar la **mínima vida inicial** necesaria en $(1, 1)$.
- **Truco clave (Pensar de atrás hacia adelante):**
  - Si vamos de $(1,1)$ a $(m,n)$, necesitaríamos saber la vida actual en el estado (lo cual es un parámetro extra no acotado).
  - En cambio, definimos $V(i, j)$ como la **mínima vida con la que debemos entrar a la celda $(i, j)$ (antes de sumar $A_{i,j}$)** para poder llegar vivos a $(m, n)$.
- **Recurrencia:**
  Para sobrevivir en $(i, j)$ necesitamos tener $\ge 1$ después de sumar $A_{i,j}$, y además alcanzar el mínimo requerido por el mejor vecino hacia el final:
  $$V(i, j) = \begin{cases} +\infty & \text{si } i > m \lor j > n \\ \max(1,\ 1 - A_{m,n}) & \text{si } i = m \land j = n \\ \max\big(1,\ \min(V(i+1, j), V(i, j+1)) - A_{i,j}\big) & \text{en otro caso} \end{cases}$$
  - Llamado inicial: $V(1, 1)$.
- **Complejidad:** $\Theta(mn)$ estados, transición $O(1) \implies$ Tiempo $\Theta(mn)$, Espacio $\Theta(\min(m, n))$ en Bottom-Up llenando de $(m, n)$ hacia $(1, 1)$.

---

### Ejercicio 10: Apilando Cajas
- **Problema:** $N$ cajas numeradas $1 \dots N$, cada una con peso $w_i$ y soporte máximo $s_i$ (cuánto peso total puede tener encima sin aplastarse). Se apilan de abajo hacia arriba respetando el orden de índices (la de más abajo tiene menor índice que las de arriba). Maximizar la cantidad de cajas apiladas.
- **Estado:** `(i, cap)` donde `i` $\in \{1, \dots, N+1\}$ es la caja considerada (de abajo hacia arriba) y `cap` es el peso máximo que todavía soportan todas las cajas ya apiladas debajo de `i`.
- **Recurrencia:**
  - Si apilamos la caja $i$ (solo válido si $w_i \le \text{cap}$), la nueva capacidad hacia arriba pasa a ser $\min(\text{cap} - w_i, s_i)$.
  $$f(i, \text{cap}) = \begin{cases} 0 & \text{si } i > N \\ f(i+1, \text{cap}) & \text{si } w_i > \text{cap} \\ \max\big\{f(i+1, \text{cap}),\ 1 + f(i+1, \min(\text{cap} - w_i, s_i))\big\} & \text{si } w_i \le \text{cap} \end{cases}$$
  - Llamado inicial: $\max_{1 \le i \le N} (1 + f(i+1, s_i))$ (o agregando una piso ficticio $0$ con soporte $S_{max} = \max_i (s_i + w_i)$).
- **Complejidad:** Tiempo $O(N \cdot \max_i s_i)$, Espacio $O(\max_i s_i)$ en Bottom-Up.

---

### Ejercicio 11: Operaciones
- **Problema:** Secuencia de naturales $v = (v_1, \dots, v_n)$ y objetivo $w \in \mathbb{N}$. Intercalar $+$, $\times$, $\uparrow$ (potencia) evaluando de izquierda a derecha para obtener exactamente $w$.
- **Observación clave para acotar estados:** Si $v_i \ge 1$ son naturales (tratando el caso $v_i = 0$ si existiera), las operaciones $+, \times, \uparrow$ nunca disminuyen el acumulado parcial. Por lo tanto, si el acumulado parcial `acum` supera $w$, podemos podar la rama (`return false`) porque nunca podrá volver a bajar a $w$.
- **Estado:** `(i, acum)` con $1 \le i \le n$ y $0 \le \text{acum} \le w$.
- **Recurrencia:**
  $$\text{op}(i, a) = \begin{cases} \text{false} & \text{si } a > w \\ a == w & \text{si } i == n \land a \le w \\ \text{op}(i+1, a + v_{i+1}) \lor \text{op}(i+1, a \cdot v_{i+1}) \lor \text{op}(i+1, a^{v_{i+1}}) & \text{si } i < n \land a \le w \end{cases}$$
  - Llamado inicial: $\text{op}(1, v_1)$.
- **Complejidad:** $\Theta(n \cdot w)$ estados, transición $O(1)$ (o $O(\log v_i)$ para la potencia) $\implies$ Tiempo $O(n \cdot w)$, Espacio $O(n \cdot w)$ para reconstruir los operadores.

---

### Ejercicio 12: Suma de Dados (Distinguibles vs. Indistinguibles)
- **Problema:** Dados $n$ dados de $k$ caras ($1 \dots k$) y una suma $s$, contar de cuántas formas se obtiene suma $s$:
  1. **Inciso a) Dados Distinguibles** (importa el orden: $(1, 2) \neq (2, 1)$):
     - **Estado:** `(d, suma)` con $0 \le d \le n$ y $0 \le \text{suma} \le s$.
     - **Recurrencia:**
       $$f(d, r) = \begin{cases} 1 & \text{si } d = 0 \land r = 0 \\ 0 & \text{si } (d = 0 \land r \neq 0) \lor r < 0 \\ \sum_{c=1}^{\min(k, r)} f(d-1, r - c) & \text{si } d > 0 \land r \ge 0 \end{cases}$$
     - **Complejidad:** $\Theta(n s)$ estados, transición $O(k) \implies$ Tiempo $O(n \cdot s \cdot k)$ (optimizable a $O(ns)$ con sumas prefijas), Espacio $O(s)$ en Bottom-Up.
  2. **Inciso b) Dados Indistinguibles** (NO importa el orden: $(1, 2)$ y $(2, 1)$ son el mismo multiconjunto):
     - **Truco de modelado para evitar permutaciones repetidas:** Imponer un **orden canónico** (por ejemplo, que los valores de los dados elegidos sean no crecientes: $c_1 \ge c_2 \ge \dots \ge c_n$).
     - **Estado:** `(d, r, max_cara)` donde `max_cara` $\in \{1, \dots, k\}$ es el máximo valor permitido para los $d$ dados restantes.
     - **Recurrencia (decisión binaria estilo cambio de monedas):** O bien ningún dado más toma el valor `max_cara` (bajamos a `max_cara - 1`), o bien al menos un dado toma el valor `max_cara` (nos queda $d-1$ dados y suma $r - \text{max\_cara}$ con el mismo tope `max_cara`):
       $$g(d, r, c) = \begin{cases} 1 & \text{si } d = 0 \land r = 0 \\ 0 & \text{si } r < 0 \lor (d > 0 \land c = 0) \lor (d = 0 \land r > 0) \\ g(d, r, c-1) + g(d-1, r - c, c) & \text{en otro caso} \end{cases}$$
     - **Complejidad:** Como si $s > nk$ la respuesta es $0$, acotamos $s \le nk$. Hay $\Theta(n \cdot k \cdot \min(s, nk))$ estados, transición $O(1) \implies$ Tiempo $O(n k \min(s, nk))$, Espacio $O(k \min(s, nk))$ en Bottom-Up.

---

### Ejercicio 13: Las Legiones del César (Reducción Progresiva de Estados)
- **Problema:** Formar una fila con $P$ patos y $D$ dodos de modo que no haya más de $m_P$ patos consecutivos ni más de $m_D$ dodos consecutivos. Contar la cantidad de filas válidas.
- **Evolución de Estados vista en Clase Práctica 6 y 7:**
  1. **Modelo Ingenuo (5 parámetros):** $g(t, n_P, n_D, k_P, k_D) \implies O((P+D) P D m_P m_D)$ estados.
  2. **Primera Reducción (eliminar redundancias):** El paso actual $t = n_P + n_D$ se deduce de $(n_P, n_D)$. Además, siempre una de las dos rachas ($k_P$ o $k_D$) vale $0$. Reemplazamos $(k_P, k_D)$ por `(k, ultTropa)` donde `ultTropa` $\in \{P, D\}$ y $k$ es el largo de la racha actual:
     - Estado: $(n_P, n_D, k, u) \implies O(P \cdot D \cdot \max(m_P, m_D))$ estados, transición $O(1)$.
  3. **Segunda Reducción — Pasos Grandes / Bloques de Rachas (3 parámetros):**
     - En lugar de decidir tropa por tropa, decidimos de una sola vez **el largo completo $i$ de la próxima racha** de tropas del tipo opuesto a la última usada.
     - **Estado:** $(n_P, n_D, u)$ con $u \in \{P, D\}$, donde $u$ indica qué tipo de tropa **debe empezar ahora** (es decir, el bloque anterior terminó con la tropa opuesta).
     - **Recurrencia:**
       $$f(n_P, n_D, P) = \begin{cases} 1 & \text{si } n_P = 0 \land n_D = 0 \\ \sum_{i=1}^{\min(n_P, m_P)} f(n_P - i, n_D, D) & \text{si } n_P + n_D > 0 \end{cases}$$
       $$f(n_P, n_D, D) = \begin{cases} 1 & \text{si } n_P = 0 \land n_D = 0 \\ \sum_{i=1}^{\min(n_D, m_D)} f(n_P, n_D - i, P) & \text{si } n_P + n_D > 0 \end{cases}$$
       *(Nota: si $n_P = 0$ y $n_D > 0$, la sumatoria de $f(0, n_D, P)$ queda vacía de $1$ a $0$ y devuelve $0$ automáticamente).*
     - **Llamado inicial:** Si $P + D == 0$ devuelve $1$; si no, devuelve $f(P, D, P) + f(P, D, D)$.
     - **Complejidad:**
       - Estados: $2(P+1)(D+1) = \Theta(PD)$.
       - Transición: $O(R)$ donde $R = \max(\min(P, m_P), \min(D, m_D))$.
       - **Tiempo:** $O(P \cdot D \cdot R)$, **Espacio:** $\Theta(P \cdot D)$.
       - **Bonus Bottom-Up en $O(PD)$ tiempo:** Llenando la matriz `M[n_P][n_D][u]`, la suma $\sum_{i=1}^{\min(n_P, m_P)} M[n_P - i][n_D][D]$ es la suma de una ventana deslizante en la columna `n_D`, que se puede mantener en $O(1)$ al incrementar `n_P` (sumando el nuevo elemento que entra a la ventana y restando el que sale). Así el tiempo total baja a $\Theta(P \cdot D)$.

---

### Ejercicio 14: Granjero (Aritmética Modular en el Estado)
- **Problema:** Grilla de $N \times M$ donde la celda $(i, j)$ tiene $a_{i,j}$ arvejas. Empezamos en alguna celda de la fila $N$ y en cada paso subimos a $(i-1, j-1)$ o $(i-1, j+1)$ hasta llegar a la fila $1$. Queremos maximizar la cantidad total de arvejas recolectadas sujeto a que **el total sea divisible por $K+1$**.
- **Truco clave de modelado:** Para saber si al final la suma total será divisible por $M_{mod} = K + 1$, no necesitamos recordar la suma acumulada entera en el estado, sino únicamente **el resto de la suma módulo $(K+1)$**.
- **Estado:** `(fila, col, resto)` con `fila` $\in \{1, \dots, N\}$, `col` $\in \{1, \dots, M\}$ y `resto` $\in \{0, 1, \dots, K\}$.
- **Recurrencia:**
  Definimos $f(i, j, r)$ como la máxima suma de arvejas desde la fila $i$, columna $j$ hasta la fila $1$ tal que la suma desde el inicio tenga resto congruente, o equivalentemente: $f(i, j, r) =$ máxima cantidad de arvejas recolectables desde $(i, j)$ hasta la fila $1$ cuya suma tenga resto $r \pmod{K+1}$:
  - Sea $r' = (r - (a_{i,j} \bmod (K+1)) + (K+1)) \bmod (K+1)$ el resto que necesitamos conseguir en las filas $i-1 \dots 1$:
  $$f(i, j, r) = \begin{cases} -\infty & \text{si } j < 1 \lor j > M \\ a_{1,j} & \text{si } i = 1 \land (a_{1,j} \bmod (K+1) == r) \\ -\infty & \text{si } i = 1 \land (a_{1,j} \bmod (K+1) \neq r) \\ a_{i,j} + \max\big\{f(i-1, j-1, r'),\ f(i-1, j+1, r')\big\} & \text{si } i > 1 \end{cases}$$
  - **Llamado inicial:** $\max_{1 \le j \le M} f(N, j, 0)$.
- **Complejidad:** $\Theta(N \cdot M \cdot K)$ estados, transición $O(1) \implies$ **Tiempo $\Theta(N \cdot M \cdot K)$, Espacio $\Theta(N \cdot M \cdot K)$** (o $\Theta(M \cdot K)$ sin reconstrucción).

---

## 6. Checklist y Consejos Clave para el Examen de PD

1. **¿Cómo reconocer que un problema es de PD?**
   - Pide optimizar ($\max / \min$) o contar ($\#$) sobre una estructura secuencial, intervalo, grilla o DAG.
   - Una decisión local greedy falla porque compromete recursos futuros (ej. capacidad $W$, presupuesto $C$, paridad/resto modular).
   - Hay cotas chicas o moderadas en los parámetros numéricos (ej. $N, W \le 10^3$ o $N \le 300$ para $O(N^3)$).
2. **Trampas frecuentes a evitar en el parcial:**
   - **Pasar estructuras grandes en el estado:** Nunca pongas un `vector` o `set` como parámetro de la función recursiva si podés representarlo con un índice $i$.
   - **Acumuladores dentro de la llamada recursiva:** En vez de hacer `f(i + 1, acum + ganancia[i])`, hacé `ganancia[i] + f(i + 1)`. Si metés `acum` como parámetro del estado sin necesidad, multiplicás la cantidad de estados por la suma máxima posible y arruinás la superposición de subproblemas. Solo poné un acumulador en el estado si las **restricciones de factibilidad** dependen de él (ej. el peso $w$ en Mochila o el resto $r \bmod (K+1)$ en Granjero).
   - **Olvidar el costo de inicialización:** La complejidad de inicializar una matriz de $N \times W$ es $\Theta(NW)$, incluso si el algoritmo Top-Down visita pocos estados.
   - **Confundir superposición con un ejemplo:** Siempre justificá superposición mostrando que $|\text{Estados}| = O(\text{polinomio})$ vs. $|\text{Llamados BT}| = \Omega(\text{exponencial})$.
