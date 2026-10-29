# Guía de Estudio Exhaustiva: Algoritmos Greedy (Golosos)
**Materia:** Técnicas de Diseño de Algoritmos (TDA) / Algoritmos y Estructuras de Datos III — FCEyN, UBA  
**Unidad:** Segundo Parcial — Tema 2: Algoritmos Golosos (Greedy) y Demostraciones de Optimalidad  
**Fuentes integradas:** Teórica 8, Apunte de Demostraciones (Prim e Intervalos), Clase Práctica 8 (Handout, Diapositivas y Pizarrón TT), Guía Práctica 7 completa.

---

## 1. Fundamentos Teóricos y Visión General

### 1.1. ¿Qué es un Algoritmo Greedy (Goloso)?
Un **algoritmo goloso (greedy)** construye una solución paso a paso eligiendo, en cada iteración, la opción que **localmente parece mejor** de acuerdo con algún criterio fijo (por ejemplo, el elemento de menor peso, el que termina antes, el de mayor densidad), siempre manteniendo la **factibilidad** de la solución parcial.
- **Característica definitoria:** Una vez que un algoritmo greedy toma una decisión, **esa decisión es definitiva** (nunca vuelve atrás ni reconsidera elecciones pasadas, a diferencia de Backtracking o Programación Dinámica).
- **Relación con Programación Dinámica:** Un algoritmo greedy puede pensarse como un caso extremo de PD donde poseemos una **propiedad de elección golosa** (*greedy choice property*) que nos garantiza a priori cuál de las ramas recursivas conduce a una solución óptima, eliminando la necesidad de explorar las demás ramas.
- **Eficiencia:** Suelen ser algoritmos muy simples y rápidos, dominados casi siempre por el tiempo de ordenar la entrada ($O(n \log n)$) o mantener una cola de prioridad ($O(n \log n)$ o $O(m \log n)$).

---

### 1.2. ¿Cómo saber si un Algoritmo Greedy es Correcto o Falso?
En el Segundo Parcial de TDA, las preguntas sobre Greedy siempre caen en una de dos categorías:
1. **El criterio Greedy es FALSO:** Para demostrar que una estrategia golosa **NO** encuentra siempre el óptimo, **alcanza con exhibir un contraejemplo concreto** (una instancia pequeña del problema donde se muestre cuál es la solución que construye el algoritmo greedy, cuál es su valor, y cuál es otra solución factible con mejor valor).
2. **El criterio Greedy es CORRECTO:** La intuición suele engañar en algoritmos golosos. Por eso, **todo algoritmo greedy propuesto DEBE venir acompañado de una demostración formal de correctitud**.

---

## 2. Métodos y Plantillas de Demostración para Greedy

La cátedra enseña principalmente el **Argumento de Intercambio (Exchange Argument)** (en sus dos presentaciones equivalentes: por *prefijo común / inducción en el paso de diferencia* o por *invariante de ciclo*) y la técnica de **El Goloso se Mantiene Adelante (Greedy Stays Ahead)**.

---

### 2.1. Plantilla A: Argumento de Intercambio (Prefijo Común / Paso a Paso)
Esta es la estructura paso a paso utilizada en las clases prácticas (ej. Selección de Actividades, Ruta Eficiente, Deadlines, Producto Escalar):

1. **Orden Canónico:** Fijar un orden común para comparar cualquier solución con la solución Greedy.
   - Sea $S = (g_1, g_2, \dots, g_k)$ la solución devuelta por el algoritmo Greedy.
   - Sea $O = (o_1, o_2, \dots, o_m)$ una solución óptima cualquiera, cuyos elementos están ordenados bajo el mismo criterio (por ejemplo, de menor a mayor tiempo o posición).
2. **Primer Punto de Diferencia:**
   - Supongamos que $S$ y $O$ coinciden en sus primeros $r$ elementos ($g_1 = o_1, \dots, g_r = o_r$) y difieren en la posición $r+1$, es decir, **$g_{r+1} \neq o_{r+1}$**. *(Si no difieren en ninguna posición, $S = O$ y ya es óptima).*
3. **Propiedad Greedy (Desigualdad Clave):**
   - Como los primeros $r$ elementos de $S$ y $O$ son idénticos, en el paso $r+1$ el elemento $o_{r+1}$ era un candidato factible disponible para el algoritmo Greedy.
   - Como Greedy eligió $g_{r+1}$ en lugar de $o_{r+1}$, por la regla de selección golosa se cumple que **$g_{r+1}$ es al menos tan bueno localmente como $o_{r+1}$** (por ejemplo, $f(g_{r+1}) \le f(o_{r+1})$ o $x_{g_{r+1}} \ge x_{o_{r+1}}$).
4. **Construcción de la Solución Modificada $O'$ (El Intercambio):**
   - Definimos una nueva solución $O'$ modificando $O$ para que incluya a $g_{r+1}$ en la posición $r+1$:
     - **Caso 1 ($g_{r+1} \notin O$):** Reemplazamos directamente $o_{r+1}$ por $g_{r+1}$:
       $$O' = (O \setminus \{o_{r+1}\}) \cup \{g_{r+1}\} = (o_1, \dots, o_r, g_{r+1}, o_{r+2}, \dots, o_m).$$
     - **Caso 2 ($g_{r+1} \in O$, es decir $g_{r+1} = o_j$ para algún $j > r+1$):** Intercambiamos (*swap*) las posiciones de $o_{r+1}$ y $o_j = g_{r+1}$ dentro de $O$ (o reemplazamos $o_{r+1}$ por $g_{r+1}$ y demostramos por contradicción que $j$ no podía ser $\ge r+2$).
5. **Demostración de Validez (Factibilidad) y Optimalidad de $O'$:**
   - **Factibilidad:** Probar que $O'$ sigue siendo una solución válida:
     - *Hacia atrás (con $1 \dots r$):* $g_{r+1}$ es compatible con $o_1, \dots, o_r$ porque $o_1 = g_1, \dots, o_r = g_r$ y el algoritmo Greedy solo elige elementos factibles.
     - *Hacia adelante (con $r+2 \dots m$):* Usando la **Propiedad Greedy** del paso 3 (ej. $f(g_{r+1}) \le f(o_{r+1}) \le s(o_{r+2})$), probar que $g_{r+1}$ tampoco genera conflicto con el resto de $O$.
   - **Optimalidad:** Probar que el valor objetivo de $O'$ es tan bueno como el de $O$ (ej. $|O'| = |O|$, o $\text{costo}(O') \le \text{costo}(O)$). Como $O$ era óptima, **$O'$ también es óptima**, y además coincide con $S$ en los primeros $r+1$ elementos.
6. **Conclusión Inductiva (Fin del Intercambio):**
   - Repitiendo este argumento inductivamente a lo sumo $k$ veces (o tomando desde el principio la solución óptima $O$ que maximizaba el largo $r$ del prefijo común con $S$ y llegando a una contradicción), obtenemos una solución óptima $O^*$ cuyos primeros $k$ elementos coinciden con $S = (g_1, \dots, g_k)$.
   - Finalmente, probamos que $O^*$ no puede tener un elemento adicional $o_{k+1}$ (porque si fuera compatible con $g_1, \dots, g_k$, el algoritmo Greedy no habría terminado en el paso $k$). Luego $S = O^*$ y $S$ es óptima. $\blacksquare$

---

### 2.2. Plantilla B: Invariante de Ciclo ("Greedy siempre es parte de una solución óptima")
Es el esquema formal presentado en el apunte teórico `08b_Demos_Prim_e_Intervalos_Greedy.pdf` para Prim y Selección de Intervalos:

- **Enunciado del Invariante $P(i)$:**
  $$\text{Al finalizar la iteración } i \text{ del ciclo, la solución parcial } G_i \text{ construida por Greedy está contenida en alguna solución óptima } O \text{ (o existe } O \text{ óptima tal que } O \cap I_i = G_i\text{)}.$$
- **Demostración por Inducción en $i$:**
  1. **Caso Base ($i = 0$):** Antes de empezar el ciclo, $G_0 = \emptyset$, que trivialmente está contenido en cualquier solución óptima $O$.
  2. **Paso Inductivo ($P(i) \implies P(i+1)$):**
     - Por Hipótesis Inductiva, existe una solución óptima $O$ que extiende a $G_i$.
     - Sea $x$ la decisión tomada por Greedy en el paso $i+1$:
       - Si Greedy **descarta** un elemento $a_{i+1}$ (ej. en intervalos), probamos que $a_{i+1}$ es incompatible con $G_i \subseteq O$, por lo que $a_{i+1} \notin O$, y la misma $O$ sirve para $P(i+1)$.
       - Si Greedy **agrega** $x$ ($G_{i+1} = G_i \cup \{x\}$):
         - **Subcaso 1 ($x \in O$):** Entonces $G_{i+1} \subseteq O$, y la misma $O$ cumple $P(i+1)$.
         - **Subcaso 2 ($x \notin O$):** Identificamos un elemento $y \in O \setminus G_i$ y definimos $O' = (O \setminus \{y\}) \cup \{x\}$. Demostramos que $O'$ es factible y tiene costo óptimo ($\text{costo}(O') \le \text{costo}(O)$ o $|O'| = |O|$). Como $G_i \subseteq O$ e $y \notin G_i$, tenemos $G_{i+1} = G_i \cup \{x\} \subseteq O'$. Vale $P(i+1)$.
  3. **Finalización:** Al terminar todas las iteraciones ($i = n$), el invariante $P(n)$ garantiza que la solución final de Greedy coincide con una solución óptima $O$. $\blacksquare$

---

### 2.3. Plantilla C: El Goloso se Mantiene Adelante (Greedy Stays Ahead)
1. Definir una función de progreso $f(x_1, \dots, x_i)$ luego de $i$ pasos (ej. en Selección de Actividades, $f(i) =$ tiempo de finalización de la $i$-ésima actividad elegida; en Ruta Eficiente, $f(i) =$ kilómetro de la $i$-ésima estación donde paramos).
2. Probar por inducción en $i \ge 1$ que la solución Greedy $G = (g_1, \dots, g_k)$ siempre va "más adelante" que cualquier solución óptima $O = (o_1, \dots, o_m)$:
   $$P(i): \text{Para todo } i \le \min(k, m), \quad f(g_i) \le f(o_i) \quad (\text{o } x_{g_i} \ge x_{o_i}).$$
3. Usar $P(\min(k, m))$ para probar por contradicción que Greedy no pudo haberse quedado corto (ej. si $k < m$, entonces como $f(g_k) \le f(o_k) \le s(o_{k+1})$, la actividad $o_{k+1}$ era compatible con $g_k$ y Greedy habría elegido al menos una actividad más, absurdo).

---

## 3. Algoritmos Clásicos de la Teórica 8 y Apunte 08b

### 3.1. Selección de Actividades (Interval Scheduling)
- **Problema:** Dados $n$ intervalos $I = \{a_1, \dots, a_n\}$ donde $a_i = [s_i, f_i)$, hallar un subconjunto de actividades mutuamente compatibles (disjuntas) de **máximo cardinal**.
- **Criterios Greedy que FALLAN (Contraejemplos):**
  - *Elegir la que empieza primero ($\min s_i$):* Falla si hay una actividad muy larga $[0, 100)$ y dos cortas $[1, 2), [3, 4)$.
  - *Elegir la de menor duración ($\min (f_i - s_i)$):* Falla con $[0, 5), [4, 7), [6, 11)$, donde la más corta $[4, 7)$ bloquea a las otras dos.
  - *Elegir la que tiene menos solapamientos:* Falla en un grafo de intervalos clásico de 11 intervalos donde el intervalo central tiene grado 3 pero elegirlo impide tomar 4 intervalos independientes.
- **Criterio Greedy ÓPTIMO:** Ordenar las actividades por **tiempo de finalización creciente** ($f_1 \le f_2 \le \dots \le f_n$) e ir agregando iterativamente la primera actividad compatible con la última seleccionada ($s_i \ge f_{\text{última}}$).
- **Complejidad:** $\Theta(n \log n)$ por el ordenamiento + $\Theta(n)$ recorrido lineal = **$\Theta(n \log n)$ tiempo**, $O(n)$ espacio.
- **Demostración (Versión Invariante del Apunte `08b`):**
  - Ordenadas por $f_1 \le \dots \le f_n$, sea $I_i = \{a_1, \dots, a_i\}$ y $G_i$ el conjunto elegido por Greedy tras considerar $I_i$.
  - **Invariante $P(i)$:** Existe una solución óptima $O$ tal que $O \cap I_i = G_i$.
  - **Base ($i = 0$):** $I_0 = G_0 = \emptyset \implies O \cap \emptyset = \emptyset$ para cualquier óptima $O$.
  - **Paso inductivo ($P(i) \implies P(i+1)$):** Sea $O$ óptima tal que $O \cap I_i = G_i$. En la iteración $i+1$, Greedy evalúa $a_{i+1}$:
    - **Caso 1: Greedy descarta $a_{i+1}$.** Entonces $G_{i+1} = G_i$. Como la descartó, $a_{i+1}$ se solapa con la última actividad de $G_i$. Pero $G_i \subseteq O$ y $O$ es compatible, así que $a_{i+1} \notin O$. Luego $O \cap I_{i+1} = O \cap I_i = G_i = G_{i+1}$.
    - **Caso 2: Greedy agrega $a_{i+1}$ ($G_{i+1} = G_i \cup \{a_{i+1}\}$).**
      - Si $a_{i+1} \in O$, entonces $O \cap I_{i+1} = (O \cap I_i) \cup \{a_{i+1}\} = G_i \cup \{a_{i+1}\} = G_{i+1}$.
      - Si $a_{i+1} \notin O$, sabemos que $O \setminus G_i$ no puede ser vacío (si fuera vacío, $O = G_i$, pero $G_i \cup \{a_{i+1}\}$ es compatible y más grande que $O$, contradiciendo que $O$ es óptima). Sea $b \in O \setminus G_i$ la actividad de $O \setminus G_i$ que **termina primero**. Como $O \cap I_i = G_i$, $b \notin I_i$, así que el índice de $b$ es $\ge i+2$ y por el ordenamiento **$f(a_{i+1}) \le f(b)$**. Definimos $O' = (O \setminus \{b\}) \cup \{a_{i+1}\}$.
        - *Compatibilidad de $O'$:* $a_{i+1}$ es compatible con $G_i$ por el chequeo del algoritmo; y para toda $c \in O \setminus (G_i \cup \{b\})$, por elección de $b$ como la que termina primero en $O \setminus G_i$ y ser $c$ compatible con $b$, vale $s(c) \ge f(b) \ge f(a_{i+1})$, luego $a_{i+1}$ es compatible con $c$.
        - *Optimalidad y extensión:* $|O'| = |O|$ y $O' \cap I_{i+1} = G_i \cup \{a_{i+1}\} = G_{i+1}$. $\blacksquare$

---

### 3.2. Problema del Cambio de Monedas
- **Problema:** Dadas denominaciones $1 = c_1 < c_2 < \dots < c_r$ y un monto $m \in \mathbb{N}$, expresar $m = \sum_{i=1}^r c_i x_i$ ($x_i \in \mathbb{N}_0$) minimizando la cantidad total de monedas $\sum_{i=1}^r x_i$.
- **Estrategia Greedy:** Usar siempre la mayor cantidad posible de la moneda de mayor valor $\le$ monto restante ($x_i = \lfloor m_{\text{rest}} / c_i \rfloor$).
- **¿Es correcto en general?** **NO.**
  - **Contraejemplo clásico:** Denominaciones $C = \{1, 3, 4\}$ y monto $m = 6$. Greedy elige $4 + 1 + 1$ ($3$ monedas), mientras que el óptimo es $3 + 3$ ($2$ monedas).
- **Teorema (Condición suficiente de divisibilidad):** Si cada denominación divide a la siguiente (**$c_i \mid c_{i+1}$** para todo $1 \le i < r$, ej. $\{1, 5, 10, 50, 100\}$ o potencias $b^i$), entonces **el algoritmo Greedy es óptimo** y corre en $O(r \log r)$ (u $O(r)$ si ya están ordenadas).
- **Demostración:**
  - Sea $q_i = c_{i+1} / c_i \in \mathbb{N}_{\ge 2}$.
  - **Lema 1:** En cualquier solución óptima $O = (x_1, \dots, x_r)$, se cumple $x_i < q_i$ para todo $1 \le i < r$. *(Dem: Si fuera $x_i \ge q_i$, podríamos reemplazar $q_i$ monedas de valor $c_i$ por $1$ moneda de valor $c_{i+1} = q_i c_i$, manteniendo la suma $m$ y reduciendo en $q_i - 1 \ge 1$ la cantidad de monedas, absurdo).*
  - **Lema 2 (Por inducción en $i$):** Para todo $1 \le i < r$, la suma de todas las monedas de denominación $\le c_i$ en $O$ es estrictamente menor que $c_{i+1}$:
    $$\sum_{j=1}^i c_j x_j \le \sum_{j=1}^i c_j (q_j - 1) = \sum_{j=1}^i (c_{j+1} - c_j) = c_{i+1} - c_1 = c_{i+1} - 1 < c_{i+1}.$$
  - **Conclusión:** Mirando $m = c_r x_r + \sum_{j=1}^{r-1} c_j x_j$, como el resto $\sum_{j=1}^{r-1} c_j x_j < c_r$, por unicidad del cociente y resto de la división entera, necesariamente $x_r = \lfloor m / c_r \rfloor$, que es exactamente lo que elige Greedy. Por inducción hacia atrás, $O$ coincide con Greedy en todas las denominaciones. $\blacksquare$

---

### 3.3. Árbol Generador Mínimo (AGM / MST): Kruskal y Prim
Dado un grafo conexo no dirigido $G = (V, E)$ con pesos $c : E \to \mathbb{R}$, buscamos un subgrafo conexo acíclico (árbol generador) $T = (V, E_T)$ que minimice $c(T) = \sum_{e \in E_T} c(e)$.

#### A. Algoritmo de Kruskal
- **Idea Greedy:** Ordenar las aristas por peso no decreciente $c(e_1) \le \dots \le c(e_m)$. Empezar con el bosque $(V, \emptyset)$ e iterar sobre las aristas agregando $e = \{u, v\}$ si y solo si no forma ciclo con las ya elegidas (chequeado con **Union-Find / Disjoint Set**: `Find(u) != Find(v)`). Cortar al llegar a $n - 1$ aristas.
- **Complejidad:** Ordenar las aristas cuesta $O(m \log m) = O(m \log n)$ (pues $m \le n^2$). Las $O(m)$ operaciones `Find` y $n-1$ operaciones `Union` cuestan $O(m \log n)$ (o $O(m \alpha(n))$). **Total: $O(m \log n)$ tiempo**, $O(n + m)$ espacio.
- **Demostración de Correctitud (Intercambio en Ciclos):**
  - Sea $K_i$ el conjunto de $i$ aristas elegidas por Kruskal y supongamos por HI que existe un AGM $O$ tal que $K_i \subseteq E(O)$.
  - Sea $e = \{u, v\}$ la $(i+1)$-ésima arista agregada por Kruskal. Si $e \in E(O)$, $K_{i+1} \subseteq E(O)$ y listo.
  - Si $e \notin E(O)$, al agregar $e$ al árbol $O$ se forma un único ciclo $C$ en $O \cup \{e\}$.
  - Como Kruskal eligió $e = \{u, v\}$, los extremos $u$ y $v$ estaban en **distintas componentes conexas** del bosque $(V, K_i)$. Por lo tanto, al recorrer el camino $C \setminus \{e\}$ entre $u$ y $v$ en $O$, debe existir al menos una arista $e' \in C \setminus \{e\}$ que también une dos componentes distintas de $(V, K_i)$ (en particular, $e' \notin K_i$).
  - Como $e'$ no formaba ciclo con $K_i$ pero Kruskal eligió $e$ antes que $e'$, por el orden creciente de pesos vale **$c(e) \le c(e')$**.
  - Definimos $O' = (O \setminus \{e'\}) \cup \{e\}$. Al quitar una arista del único ciclo de $O \cup \{e\}$, $O'$ sigue siendo un árbol generador, contiene a $K_{i+1} = K_i \cup \{e\}$, y su peso es $c(O') = c(O) + c(e) - c(e') \le c(O)$. Como $O$ era un AGM, $c(O') = c(O)$ y $O'$ es un AGM que extiende a $K_{i+1}$. $\blacksquare$

#### B. Algoritmo de Prim (Apunte `08b_Demos_Prim_e_Intervalos_Greedy.pdf`)
- **Idea Greedy:** Empezar desde un vértice raíz $r \in V$ con $T_0 = (\{r\}, \emptyset)$. En cada paso $i = 1 \dots n-1$, elegir una arista $e = vw$ de **peso mínimo en la frontera de $T_{i-1}$** (es decir, con $v \in V(T_{i-1})$ y $w \notin V(T_{i-1})$) y agregar $w$ y $vw$ para formar $T_i$.
- **Complejidad:**
  - Con arreglo de distancias a la frontera: **$O(n^2)$** (óptimo en grafos densos $m = \Theta(n^2)$).
  - Con Min-Heap binario y listas de adyacencia: **$O((n + m) \log n) = O(m \log n)$**.
- **Demostración de Correctitud Completa (Invariante en Cortes):**
  - **Invariante $P(i)$:** Para cada $0 \le i \le n-1$, el subgrafo $T_i$ tiene $i$ aristas, es un árbol, y está contenido en algún AGM $A$ de $G$.
  - **Caso Base ($i = 0$):** $T_0 = (\{r\}, \emptyset)$ tiene $0$ aristas, es un árbol y está contenido en cualquier AGM de $G$ (que existe por ser $G$ conexo).
  - **Paso Inductivo ($P(i) \implies P(i+1)$ para $0 \le i < n-1$):**
    - Sea $S_i = V(T_i)$. Como $|S_i| = i + 1 < n$ y $G$ es conexo, la frontera de $S_i$ no es vacía y Prim elige una arista $vw$ de peso mínimo con $v \in S_i, w \notin S_i$.
    - Como $T_i$ es conexo y sin ciclos y agregamos una hoja nueva $w \notin S_i$ con una sola arista $vw$, $T_{i+1}$ es un árbol con $i+1$ aristas.
    - Por HI, existe un AGM $A$ tal que $T_i \subseteq A$. Si $vw \in E(A)$, entonces $T_{i+1} \subseteq A$.
    - Si $vw \notin E(A)$: en el árbol generador $A$ existe un único camino $P$ entre $v \in S_i$ y $w \notin S_i$. Al ir de $S_i$ a $V \setminus S_i$, el camino $P$ debe cruzar la frontera de $S_i$ por al menos una arista $xy \in E(P)$ con $x \in S_i$ e $y \notin S_i$ ($xy \neq vw$).
    - Como $xy$ también estaba en la frontera de $T_i$ y Prim eligió $vw$ de peso mínimo en dicha frontera, se cumple que **$c(vw) \le c(xy)$**.
    - Sea $A' = A + vw - xy$. Como $A + vw$ tiene un único ciclo $C = P + vw$ y quitamos $xy \in E(C)$, $A'$ sigue siendo conexo y tiene $n-1$ aristas, por lo que $A'$ es un árbol generador.
    - Además, $c(A') = c(A) + c(vw) - c(xy) \le c(A)$. Como $A$ era mínimo, $c(A') = c(A)$ y $A'$ es un AGM.
    - Finalmente, como $xy$ tiene $y \notin S_i$, $xy \notin E(T_i)$, por lo que $T_{i+1} = T_i + vw \subseteq A'$. Vale $P(i+1)$.
  - **Finalización ($i = n-1$):** Por $P(n-1)$, $T_{n-1}$ es un árbol de $n-1$ aristas contenido en un AGM $A$ (que también tiene $n-1$ aristas). Luego $T_{n-1} = A$, por lo que $T_{n-1}$ es un AGM. $\blacksquare$

---

### 3.4. Codificación de Huffman
- **Problema:** Dados $n$ símbolos con frecuencias/pesos $w_1, \dots, w_n > 0$, construir un código binario libre de prefijos (representado como un árbol binario donde los símbolos son las hojas a profundidad $\ell_i$) que minimice la longitud ponderada $\sum_{i=1}^n w_i \ell_i$.
- **Propiedad Greedy:** Los dos símbolos de menor frecuencia $x, y$ pueden ubicarse como hojas hermanas a la máxima profundidad del árbol óptimo.
- **Algoritmo:** Insertar los $n$ símbolos en un **Min-Heap**. En cada una de las $n-1$ iteraciones: hacer dos `ExtractMin()` para obtener $x$ e $y$, crear un nodo padre $z$ con hijos $x, y$ y frecuencia $w_z = w_x + w_y$, e insertar $z$ en el Min-Heap.
- **Complejidad:** $n$ inserciones iniciales + $(n-1)$ iteraciones con $2$ extracciones y $1$ inserción en el heap de tamaño $\le n \implies$ **$O(n \log n)$ tiempo**, $O(n)$ espacio.

---

### 3.5. Mochila Fraccionaria
- **Problema:** Igual a Mochila 0-1, pero se puede tomar una fracción $x_i \in [0, 1]$ de cada objeto, obteniendo beneficio $x_i v_i$ con peso $x_i w_i$.
- **Criterio Greedy Óptimo:** Ordenar los objetos por **densidad (beneficio por unidad de peso) decreciente**:
  $$\frac{v_1}{w_1} \ge \frac{v_2}{w_2} \ge \dots \ge \frac{v_n}{w_n}$$
  y cargar todo lo que entre de cada objeto hasta llenar la capacidad $W$.
- **Complejidad:** **$O(n \log n)$** tiempo.

---

## 4. Resolución y Demostración de Todos los Problemas de la Guía Práctica 7

### Ejercicio 1: Caramelos
- **Problema:** Dados $n$ bolsas con $a_i$ caramelos, elegir $k$ bolsas maximizando la suma.
- **Solución:** Ordenar de mayor a menor y tomar los primeros $k$ en $O(n \log n)$ (o mantener un Min-Heap de tamaño $k$ en $O(n \log k)$, o `nth_element` / QuickSelect en $O(n)$ promedio).

---

### Ejercicio 2: Ruta Eficiente (Estaciones de Servicio a Mar del Plata)
- **Problema:** Ruta de longitud $M$ con estaciones en $0 = x_1 < x_2 < \dots < x_n = M$ (con $x_{i+1} - x_i \le C$). El tanque lleno rinde $C$ km. Empezamos en $x_1 = 0$ y queremos llegar a $x_n = M$ haciendo la **mínima cantidad de paradas** para cargar nafta.
- **Estrategia Greedy:** Estando en una estación $x_{\text{actual}}$, avanzar siempre hasta la **estación más lejana $x_j$ que esté a distancia $\le C$** (es decir, el mayor $j$ tal que $x_j - x_{\text{actual}} \le C$).
- **Complejidad:** Como las estaciones ya vienen ordenadas ($x_1 < \dots < x_n$), avanzamos un único índice $i$ de $1$ a $n$ sin retroceder nunca $\implies$ **$\Theta(n)$ tiempo**, $O(n)$ espacio para guardar la respuesta (u $O(1)$ auxiliar).
- **Demostración de Correctitud (Intercambio):**
  - Sea $G = (g_1, \dots, g_k)$ la secuencia de índices elegida por Greedy y $O = (o_1, \dots, o_m)$ una solución óptima ordenada crecientemente ($g_1 = o_1 = 1$).
  - Sea $r+1$ la primera posición donde difieren ($g_1 = o_1, \dots, g_r = o_r$ y $g_{r+1} \neq o_{r+1}$).
  - **Propiedad Greedy:** Como desde $o_r = g_r$ la estación $o_{r+1}$ está a distancia $x_{o_{r+1}} - x_{g_r} \le C$ y Greedy eligió la más lejana alcanzable $g_{r+1}$, se cumple que **$x_{g_{r+1}} > x_{o_{r+1}}$** (es decir, $g_{r+1} > o_{r+1}$).
  - **¿Puede ser $g_{r+1} \ge o_{r+2}$?** No, porque si fuera $x_{g_{r+1}} \ge x_{o_{r+2}}$, entonces $x_{o_{r+2}} - x_{o_r} \le x_{g_{r+1}} - x_{g_r} \le C$, lo que significaría que en $O$ se podía ir directamente de $o_r$ a $o_{r+2}$ salteando la parada $o_{r+1}$, contradiciendo que $O$ tenía cantidad mínima de paradas. Por lo tanto, **$o_{r+1} < g_{r+1} < o_{r+2}$**.
  - **Construcción de $O'$:** Reemplazamos $o_{r+1}$ por $g_{r+1}$: $O' = (o_1, \dots, o_r, g_{r+1}, o_{r+2}, \dots, o_m)$.
  - **Factibilidad de $O'$:**
    - De $o_r$ a $g_{r+1}$: $x_{g_{r+1}} - x_{o_r} = x_{g_{r+1}} - x_{g_r} \le C$ (por validez de Greedy).
    - De $g_{r+1}$ a $o_{r+2}$: como $x_{o_{r+1}} < x_{g_{r+1}} < x_{o_{r+2}}$, la distancia se achicó:
      $$0 < x_{o_{r+2}} - x_{g_{r+1}} < x_{o_{r+2}} - x_{o_{r+1}} \le C.$$
  - **Conclusión:** $O'$ es factible, tiene $|O'| = |O| = m$ paradas (es óptima) y coincide con $G$ en un elemento más. Por inducción, $G$ es óptima. $\blacksquare$

---

### Ejercicio 3: Suma Subconjuntos Greedy (Contraejemplo)
- **Estrategia propuesta:** Elegir repetidamente el mayor elemento del conjunto que no supere la suma restante $t$.
- **Contraejemplo:** Conjunto $S = \{1, 2, 4, 5, 8, 10\}$ y objetivo $t = 13$.
  - Greedy elige $10$, le resta $3$, luego elige $2$ y $1 \implies \{10, 2, 1\}$ (tamaño $3$).
  - El óptimo es $\{8, 5\}$ (tamaño $2$). *(Peor aún: si $S = \{2, 5, 8, 10\}$ y $t = 13$, Greedy elige $10$ y luego no puede sumar $3$, fallando en encontrar solución cuando $\{8, 5\}$ sí sumaba $13$).*

---

### Ejercicio 4: Cubrimiento por Vértices (Vertex Cover) Greedy (Contraejemplo)
- **Estrategia propuesta:** Elegir iterativamente el vértice que cubra la mayor cantidad de aristas aún no cubiertas (mayor grado actual) y borrar sus aristas incidentes.
- **Contraejemplo:** Consideremos un árbol (o grafo bipartito) con un vértice central $u$ conectado a 4 hojas $a_1, a_2, a_3, a_4$ (grado de $u$ es $4$), donde además cada $a_i$ está conectado a un vértice $b_i$ (grado de cada $a_i$ es $3$ si además conectamos algo, o simplemente $u$ conectado a $a_1, a_2, a_3$ de grado 2 cada uno porque cada $a_i$ tiene una hoja propia $b_i$).
  - Más simple aún:
    - Vértice $u$ conectado a $a_1, a_2, a_3$ ($\deg(u) = 3$).
    - Cada $a_i$ ($i=1,2,3$) está conectado a $u$ y a una hoja exclusiva $b_i$ ($\deg(a_i) = 2$, $\deg(b_i) = 1$).
    - **Greedy:** Elige primero $u$ (grado 3). Al borrar $u$, quedan las 3 aristas sueltas $(a_1, b_1), (a_2, b_2), (a_3, b_3)$, obligando a elegir 3 vértices más $\implies$ **Total Greedy = 4 vértices** ($\{u, a_1, a_2, a_3\}$).
    - **Óptimo:** Elegir $\{a_1, a_2, a_3\}$ cubre tanto las aristas hacia $u$ como las aristas hacia $b_i$ $\implies$ **Total Óptimo = 3 vértices**.

---

### Ejercicio 5: Planificación de Tareas con Deadlines (Duración Unitaria)
- **Problema:** $n$ tareas de duración $1$ unidad de tiempo cada una (empezando en $t = 0$). La tarea $i$ tiene tiempo límite (deadline) $d_i \in \mathbb{N}$ (si se ejecuta en el intervalo $[t, t+1]$, debe cumplir $t + 1 \le d_i$). Maximizar la cantidad de tareas realizadas a tiempo.
- **Lema de Forma Normal (Orden Canónico):** Si un conjunto de $k$ tareas es factible en algún orden, entonces también es factible si se las ejecuta ordenadas por **deadline no decreciente** ($d_{i_1} \le d_{i_2} \le \dots \le d_{i_k}$).
  - *Prueba del Lema:* Si dos tareas consecutivas en la planificación tienen $d_a > d_b$ y se ejecutan en los instantes $t$ y $t+1$ (con $t \le d_a$ y $t+1 \le d_b$), al intercambiarlas la tarea $b$ termina en $t < t+1 \le d_b$ y la tarea $a$ termina en $t+1 \le d_b < d_a$, siguiendo ambas a tiempo.
- **Estrategia Greedy:** Ordenar todas las tareas por deadline creciente $d_1 \le d_2 \le \dots \le d_n$. Mantener el tiempo actual $t = 0$; para cada tarea $i$, si $t + 1 \le d_i$, agendarla e incrementar $t \leftarrow t + 1$.
- **Complejidad:** **$\Theta(n \log n)$** tiempo por el ordenamiento.
- **Demostración de Correctitud (Intercambio con 2 Casos — Clase Práctica 8):**
  - Sea $G = (g_1, \dots, g_k)$ la solución Greedy y $O = (o_1, \dots, o_m)$ una solución óptima, ambas ordenadas por deadline creciente (gracias al Lema de Forma Normal).
  - Supongamos que coinciden hasta la posición $r$ ($g_1 = o_1, \dots, g_r = o_r$) y difieren en $r+1$ ($g_{r+1} \neq o_{r+1}$).
  - En el paso $r+1$ (que se ejecuta entre el instante $r$ y $r+1$), la tarea $o_{r+1}$ cumple $d(o_{r+1}) \ge r + 1$ y apareció después de $o_r = g_r$ en la lista ordenada. Como Greedy eligió la primera tarea disponible con deadline $\ge r+1$ después de $g_r$, necesariamente $g_{r+1}$ aparece antes que $o_{r+1}$ en la lista, por lo que **$r + 1 \le d(g_{r+1}) \le d(o_{r+1})$**.
  - **Caso 1 ($g_{r+1} \notin O$):** Definimos $O' = (O \setminus \{o_{r+1}\}) \cup \{g_{r+1}\}$ ubicando a $g_{r+1}$ en el turno $r+1$. Como $r + 1 \le d(g_{r+1})$, $g_{r+1}$ termina a tiempo, y todas las demás tareas de $O'$ conservan exactamente el mismo turno que tenían en $O$. Luego $O'$ es válida y óptima.
  - **Caso 2 ($g_{r+1} \in O$, es decir $g_{r+1} = o_j$ para algún $j > r+1$):** Definimos $O'$ intercambiando (*swap*) las posiciones de $o_{r+1}$ y $o_j = g_{r+1}$ en $O$ (ponemos $g_{r+1}$ en el turno $r+1$ y $o_{r+1}$ en el turno $j$).
    - $g_{r+1}$ en el turno $r+1$ es válida porque $r + 1 \le d(g_{r+1})$.
    - $o_{r+1}$ en el turno $j$ es válida porque $o_j = g_{r+1}$ era válida en el turno $j$ en $O$, lo que implica $j \le d(o_j) = d(g_{r+1}) \le d(o_{r+1})$.
    - Las demás tareas no se mueven. Luego $O'$ es válida, tiene $|O'| = |O|$ y coincide con $G$ en $r+1$ posiciones. $\blacksquare$

---

### Ejercicio 6: Producto Escalar Mínimo
- **Problema:** Dados dos vectores $v, w \in \mathbb{R}^n$, reordenar sus coordenadas para minimizar $\sum_{i=1}^n v_i w_i$.
- **Estrategia Greedy:** Ordenar $v$ de forma **creciente** ($v_1 \le v_2 \le \dots \le v_n$) y $w$ de forma **decreciente** ($w_1 \ge w_2 \ge \dots \ge w_n$).
- **Complejidad:** **$\Theta(n \log n)$** tiempo.
- **Demostración de Correctitud (Clase Práctica 8):**
  - **Lema de Invariancia:** Como la suma es conmutativa, reordenar ambos vectores simultáneamente aplicando la misma permutación $\pi$ a ambos no altera el producto escalar. Por lo tanto, podemos fijar sin pérdida de generalidad a $v$ ordenado crecientemente ($v_1 \le v_2 \le \dots \le v_n$) y buscar únicamente la permutación óptima de $w$.
  - Sea $w = (w_1, \dots, w_n)$ el orden decreciente de Greedy y sea $\hat{w} = (\hat{w}_1, \dots, \hat{w}_n)$ una permutación óptima de $w$ que coincide con $w$ en las primeras $r$ posiciones y difiere en $r+1$ ($\hat{w}_{r+1} \neq w_{r+1}$).
  - Como $w_{r+1}$ es el máximo entre los elementos restantes $\{w_{r+1}, \dots, w_n\}$, tenemos **$w_{r+1} > \hat{w}_{r+1}$**, y además $w_{r+1}$ debe aparecer más adelante en $\hat{w}$, digamos $\hat{w}_j = w_{r+1}$ con **$j > r + 1$**.
  - Construimos $\hat{w}'$ intercambiando las posiciones $r+1$ y $j$ en $\hat{w}$ (es decir, $\hat{w}'_{r+1} = \hat{w}_j = w_{r+1}$ y $\hat{w}'_j = \hat{w}_{r+1}$).
  - Calculamos el cambio en la función objetivo:
    $$\begin{aligned}
    v \cdot \hat{w}' - v \cdot \hat{w} &= (v_{r+1} \hat{w}'_{r+1} + v_j \hat{w}'_j) - (v_{r+1} \hat{w}_{r+1} + v_j \hat{w}_j) \\
    &= v_{r+1}(w_{r+1} - \hat{w}_{r+1}) + v_j(\hat{w}_{r+1} - w_{r+1}) \\
    &= (v_{r+1} - v_j)(w_{r+1} - \hat{w}_{r+1}).
    \end{aligned}$$
  - Como $v$ está ordenado crecientemente y $r+1 < j$, tenemos **$v_{r+1} - v_j \le 0$**.
  - Como $w$ está ordenado decrecientemente, tenemos **$w_{r+1} - \hat{w}_{r+1} > 0$**.
  - El producto de un número $\le 0$ por uno $> 0$ es $\le 0$, por lo tanto **$v \cdot \hat{w}' \le v \cdot \hat{w}$**. Así, $\hat{w}'$ también es óptimo y coincide con Greedy en $r+1$ posiciones. $\blacksquare$

---

### Ejercicio 7: Demoras (Minimizar Suma de Tiempos de Finalización)
- **Problema:** $n$ trabajos con tiempos de procesamiento $t_1, \dots, t_n > 0$. Si se ejecutan en orden $\pi_1, \dots, \pi_n$, el trabajo $\pi_k$ termina en $C_{\pi_k} = \sum_{j=1}^k t_{\pi_j}$. Minimizar $\sum_{k=1}^n C_{\pi_k}$.
- **Reescritura Algebraica:**
  $$\sum_{k=1}^n C_{\pi_k} = \sum_{k=1}^n (n - k + 1) \cdot t_{\pi_k}.$$
- **Reducción al Ejercicio 6:** Esto es exactamente el producto escalar entre el vector fijo decreciente $(n, n-1, \dots, 1)$ y el vector $(t_{\pi_1}, \dots, t_{\pi_n})$. Por el Ejercicio 6, para minimizarlo debemos ordenar los tiempos $t_i$ de forma **creciente** (*Shortest Processing Time first*, SPT): $t_{\pi_1} \le t_{\pi_2} \le \dots \le t_{\pi_n}$. Complejidad: $\Theta(n \log n)$.

---

### Ejercicio 8: Max MEX
- **Problema:** Reordenar un multiconjunto $S$ de $n$ números naturales para maximizar $\sum_{i=1}^n \text{mex}(\{s_1, \dots, s_i\})$, donde $\text{mex}(X) = \min(\mathbb{N}_0 \setminus X)$ es el mínimo entero no negativo ausente en $X$.
- **Estrategia Greedy:** Para que el $\text{mex}$ suba lo más rápido posible desde el principio, debemos poner una aparición de $0, 1, 2, \dots, k-1$ (mientras existan en $S$) en las primeras posiciones en orden estrictamente creciente, y luego colocar todos los elementos repetidos o mayores a $k$ al final en cualquier orden.
- **Complejidad en $\Theta(n)$:** Como el $\text{mex}$ de un conjunto de $n$ elementos nunca puede superar $n$, todos los números $> n$ se pueden mandar directamente al final y usar **Counting Sort / Bucket Sort** sobre el rango $[0, n]$ para ordenar en tiempo lineal **$\Theta(n)$**.

---

### Ejercicio 9: Bicoloreo Greedy
- **Problema:** Algoritmo que recorre los vértices en orden $v_1, \dots, v_n$ y asigna a cada $v_i$ el menor color $\ge 1$ que no tengan sus vecinos anteriores.
  - **a) ¿Encuentra siempre 2-coloreo en bipartitos?** **NO.** Contraejemplo: el camino de 4 vértices $P_4$: $a - b - c - d$. Si el orden de los vértices es $(a, d, b, c)$:
    - $a$ recibe color $1$.
    - $d$ (no es vecino de $a$) recibe color $1$.
    - $b$ (vecino de $a$) recibe color $2$.
    - $c$ (vecino de $b$ con color 2 y de $d$ con color 1) se ve forzado a recibir el **color $3$**.
  - **b) En grafos bipartitos completos $K_{r,s}$:** **SÍ**, encuentra un 2-coloreo para **cualquier** orden de los vértices. *Demostración:* Sean $A, B$ las dos partes de la bipartición. El primer vértice $v_1$ (digamos $v_1 \in A$) recibe color 1. Como $K_{r,s}$ es bipartito completo, $v_1$ es adyacente a **todos** los vértices de $B$ y a **ninguno** de $A$. Por lo tanto, cualquier otro vértice de $A$ nunca tendrá vecinos en $A$ y podrá usar siempre el color 1; y cualquier vértice de $B$ siempre tendrá a $v_1$ (color 1) como vecino anterior y a ningún otro vecino en $B$, por lo que todos los de $B$ recibirán color 2.

---

### Ejercicio 10: Caballeros (Torres Norte y Sur)
- **Problema:** $2n$ caballeros. El caballero $i$ consume $N_i$ en la Torre Norte y $S_i$ en la Torre Sur. Debemos mandar exactamente $n$ caballeros al Norte y $n$ al Sur minimizando el consumo total.
- **Truco Algebraico (Cambio de variable):** Sea $X \subseteq \{1, \dots, 2n\}$ con $|X| = n$ el conjunto de caballeros enviados al Norte (y $\bar{X}$ al Sur). El costo total es:
  $$\text{Costo}(X) = \sum_{i \in X} N_i + \sum_{i \notin X} S_i = \sum_{i=1}^{2n} S_i + \sum_{i \in X} (N_i - S_i).$$
- Como $\sum_{i=1}^{2n} S_i$ es una constante fija, minimizar el costo total equivale a elegir los $n$ elementos con menor diferencia $d_i = N_i - S_i$.
- **Algoritmo Greedy:** Ordenar los caballeros por $N_i - S_i$ creciente y enviar los primeros $n$ al Norte y los últimos $n$ al Sur. Complejidad: $\Theta(n \log n)$.

---

### Ejercicio 11: División Pandémica (Corte Grande / Búsqueda Local Greedy)
- **Problema:** Grafo $G = (V, E)$ de amistades ($|V| = n$ par). Dividir $V$ en dos grupos $A, B$ de modo que la cantidad de aristas internas (amigos en el mismo grupo) sea a lo sumo $|E|/2$ (equivalentemente, las aristas que cruzan entre $A$ y $B$ sean $\ge |E|/2$).
- **Estrategia Greedy Constructiva:** Recorrer los vértices $v_1, \dots, v_n$ uno por uno. Al procesar $v_i$, contar cuántos de sus vecinos ya procesados están en $A$ ($d_A(v_i)$) y cuántos en $B$ ($d_B(v_i)$), y ubicar a $v_i$ en el conjunto donde tenga **menos** vecinos:
  - Si $d_A(v_i) \le d_B(v_i)$, poner $v_i \in A$; si no, poner $v_i \in B$.
- **Demostración:** En el paso en que se inserta $v_i$, de las $d_{\text{prev}}(v_i) = d_A(v_i) + d_B(v_i)$ aristas que van de $v_i$ a vértices anteriores, la cantidad de aristas que quedan dentro del mismo conjunto es $\min(d_A(v_i), d_B(v_i)) \le \frac{1}{2} d_{\text{prev}}(v_i)$. Sumando sobre todos los vértices $i = 1 \dots n$ (como toda arista de $E$ tiene un extremo que se procesa después del otro):
  $$|E_{\text{internas}}| = \sum_{i=1}^n \min(d_A(v_i), d_B(v_i)) \le \frac{1}{2} \sum_{i=1}^n d_{\text{prev}}(v_i) = \frac{|E|}{2}.$$
- **Complejidad:** **$\Theta(|V| + |E|)$** tiempo (una sola pasada por listas de adyacencia).

---

### Ejercicio 12: Parejas de Baile
- **Problema:** Dos multiconjuntos de habilidades $A$ (tamaño $n$) y $B$ (tamaño $m$), ya ordenados de forma creciente. Dos personas pueden bailar si $|a_i - b_j| \le 1$. Maximizar la cantidad de parejas disjuntas.
- **Algoritmo Greedy (Dos Punteros):** Mantener $i = 1, j = 1$:
  - Si $|A[i] - B[j]| \le 1$: formar pareja $(A[i], B[j])$, avanzar `i++` y `j++`.
  - Si $A[i] < B[j] - 1$: $A[i]$ es demasiado chico incluso para el menor disponible en $B$, avanzar `i++`.
  - Si $A[i] > B[j] + 1$: $B[j]$ es demasiado chico para el menor disponible en $A$, avanzar `j++`.
- **Complejidad:** **$\Theta(n + m)$** tiempo, $O(1)$ espacio auxiliar.
- **Demostración por Intercambio:** Si la menor persona emparejable $a_i$ o $b_j$ se empareja en el óptimo $O$ con alguien mayor $b_{j'}$ ($j' > j$), mientras que $b_j$ era compatible con $a_i$, podemos reemplazar a $b_{j'}$ por $b_j$ en la pareja con $a_i$ (y si $b_j$ estaba emparejada con algún $a_{i'}$ con $i' > i$, entonces $a_i \le a_{i'}$ y $b_j \le b_{j'}$ con $|a_i - b_{j'}| \le 1$ y $|a_{i'} - b_j| \le 1$ implican $|a_{i'} - b_{j'}| \le 1$, permitiendo el *swap*).

---

### Ejercicio 13: Suma Golosa
- **Problema:** Sumar un multiconjunto de $n$ números de a dos a la vez; sumar $a$ y $b$ cuesta $a + b$ y el resultado vuelve al multiconjunto hasta que queda un solo número. Minimizar el costo total acumulado de las $n-1$ sumas.
- **Modelado y Equivalencia con Huffman:**
  - Si representamos las sumas como un árbol binario donde los $n$ números iniciales son las hojas a profundidad $\ell_i$, cada número $w_i$ se suma exactamente $\ell_i$ veces al costo total: $\text{Costo} = \sum_{i=1}^n w_i \ell_i$.
  - Por lo tanto, el problema es **exactamente isomorfo al árbol de Huffman**.
- **Algoritmo Greedy:** Insertar todos los números en un **Min-Heap**. Mientras haya más de 1 elemento, extraer los dos mínimos $x, y$, sumar $x + y$ al costo acumulado e insertar $x + y$ en el Min-Heap.
- **Complejidad:** **$\Theta(n \log n)$** tiempo, $O(n)$ espacio.
