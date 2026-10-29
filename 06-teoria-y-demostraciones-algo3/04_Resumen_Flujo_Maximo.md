# Resumen Completo: Flujo Máximo y Corte Mínimo en Redes

> **Materia:** Algoritmos y Estructuras de Datos III / Técnicas de Diseño de Algoritmos (Exactas - UBA)  
> **Unidad:** 2do Parcial — Flujo en Redes (Network Flow)  
> **Fuentes integradas:** Teórica 10 (*Flujo en Redes*), Clase Práctica 10 (Diapositivas y Handout de Modelado con Flujo y Corte Mínimo) y Guía Práctica 9 (*Flujo*).

---

## Índice

1. [Definiciones Fundamentales y Red de Flujo](#1-definiciones-fundamentales-y-red-de-flujo)
2. [Supuestos Simplificadores y Transformaciones Estándar](#2-supuestos-simplificadores-y-transformaciones-estándar)
3. [Red Residual y Camino de Aumento](#3-red-residual-y-camino-de-aumento)
4. [El Método de Ford-Fulkerson](#4-el-método-de-ford-fulkerson)
5. [Cortes s-t y el Teorema de Flujo Máximo / Corte Mínimo](#5-cortes-s-t-y-el-teorema-de-flujo-máximo--corte-mínimo)
6. [El Algoritmo de Edmonds-Karp: Demostración y Complejidad](#6-el-algoritmo-de-edmonds-karp-demostración-y-complejidad)
7. [Teorema de Integralidad del Flujo](#7-teorema-de-integralidad-del-flujo)
8. [Receta General para Resolver y Demostrar Problemas de Modelado](#8-receta-general-para-resolver-y-demostrar-problemas-de-modelado)
9. [Catálogo de Patrones de Modelado (Teórica, Práctica y Guía 9)](#9-catálogo-de-patrones-de-modelado-teórica-práctica-y-guía-9)
   - [Patrón I: Caminos Disjuntos en Aristas y Vértices (Teorema de Menger)](#patrón-i-caminos-disjuntos-en-aristas-y-vértices-teorema-de-menger)
   - [Patrón II: Matching Bipartito, Asignación y Circulación con Demandas](#patrón-ii-matching-bipartito-asignación-y-circulación-con-demandas)
   - [Patrón III: Decisiones Binarias e Implicaciones vía Corte Mínimo](#patrón-iii-decisiones-binarias-e-implicaciones-vía-corte-mínimo)
10. [Recorrido Completo por los Ejercicios de la Guía Práctica 9](#10-recorrido-completo-por-los-ejercicios-de-la-guía-práctica-9)
11. [Checklist de Examen para Ejercicios de Flujo](#11-checklist-de-examen-para-ejercicios-de-flujo)

---

## 1. Definiciones Fundamentales y Red de Flujo

### 1.1 Red de Flujo (*Flow Network*)
Una **red de flujo** es una cuádrupla $(G, s, t, c)$ donde:
- $G = (V, E)$ es un **digrafo** (grafo dirigido) con $n = |V|$ vértices y $m = |E|$ aristas dirigidas.
- $s \in V$ es un vértice distinguido llamado **fuente** (*source*), de donde se origina el flujo.
- $t \in V$ ($t \neq s$) es un vértice distinguido llamado **sumidero** (*sink*), donde se consume el flujo.
- $c : E \to \mathbb{R}_{\ge 0}$ (usualmente $\mathbb{N}_0$) es la **función de capacidad** que asigna a cada arista dirigida $e = (u, v) \in E$ una capacidad no negativa $c(u, v) \ge 0$. Si $(u, v) \notin E$, se suele definir $c(u, v) = 0$.

### 1.2 Flujo Factible (*Factible Flow*)
Un **flujo** en la red $(G, s, t, c)$ es una función $f : E \to \mathbb{R}_{\ge 0}$ que asigna a cada arista $e = (u, v) \in E$ la cantidad de unidades que circulan por ella, cumpliendo dos conjuntos de restricciones fundamentales:

1. **Restricción de Capacidad (*Capacity Constraint*):**
   $$\forall e = (u, v) \in E : \quad 0 \le f(u, v) \le c(u, v)$$
   El flujo por una arista es no negativo y nunca excede su capacidad.

2. **Conservación del Flujo (*Flow Conservation* / Ley de Kirchhoff):**
   Para cada vértice $v \in V$, definimos:
   - **Flujo saliente de $v$:** $f^{\text{out}}(v) = \sum_{(v, w) \in E} f(v, w)$
   - **Flujo entrante a $v$:** $f^{\text{in}}(v) = \sum_{(u, v) \in E} f(u, v)$
   - **Balance neto de $v$:** $b_f(v) = f^{\text{out}}(v) - f^{\text{in}}(v)$

   La ley de conservación exige que para todo **vértice interno** $v \in V \setminus \{s, t\}$, todo lo que entra debe salir:
   $$\forall v \in V \setminus \{s, t\} : \quad \sum_{(u, v) \in E} f(u, v) = \sum_{(v, w) \in E} f(v, w) \quad \Longleftrightarrow \quad b_f(v) = 0$$

### 1.3 Valor de un Flujo y Problema del Flujo Máximo
El **valor de un flujo $f$**, denotado $\text{val}(f)$ o $|f|$, es el flujo neto que abandona la fuente $s$:
$$\text{val}(f) = |f| = f^{\text{out}}(s) - f^{\text{in}}(s) = b_f(s)$$

> **Propiedad fundamental (Conservación Global):** Sumando los balances de todos los vértices:
> $$\sum_{v \in V} b_f(v) = \sum_{v \in V} \left(f^{\text{out}}(v) - f^{\text{in}}(v)\right) = \sum_{e \in E} f(e) - \sum_{e \in E} f(e) = 0$$
> Como $b_f(v) = 0$ para todo $v \notin \{s, t\}$, se deduce inmediatamente que:
> $$b_f(s) + b_f(t) = 0 \implies \text{val}(f) = b_f(s) = -b_f(t) = f^{\text{in}}(t) - f^{\text{out}}(t)$$
> Es decir: **todo el flujo neto que sale de la fuente $s$ llega exactamente al sumidero $t$**.

- **Problema de Flujo Máximo (*Maximum Flow Problem*):** Dada una red $(G, s, t, c)$, hallar un flujo factible $f^*$ que maximice $\text{val}(f^*)$.

---

## 2. Supuestos Simplificadores y Transformaciones Estándar

En la Teórica 10 se adoptan tres supuestos simplificadores que **no quitan generalidad** (cualquier red general se transforma linealmente en una red equivalente que los cumple):

### 2.1 Sin aristas antiparalelas
Asumimos que si $(u, v) \in E$, entonces $(v, u) \notin E$.
- **¿Cómo eliminarlas si existen?** Si en la red original están tanto $(u, v)$ con capacidad $c_1$ como $(v, u)$ con capacidad $c_2$, subdividimos una de ellas agregando un **vértice ficticio** $x_{uv}$: reemplazamos $(u, v)$ por dos aristas en serie $(u, x_{uv})$ y $(x_{uv}, v)$, ambas con capacidad $c_1$.
- **¿Por qué se pide esto?** Para que en la red residual $G_f$ no se confunda la arista residual de retroceso $(v, u)$ (proveniente del flujo en $(u, v)$) con la arista residual de avance de $(v, u)$.

### 2.2 Sin aristas entrantes a $s$ ni salientes de $t$
Asumimos que $d_{\text{in}}(s) = 0$ y $d_{\text{out}}(t) = 0$.
- Con este supuesto, el valor del flujo se simplifica a:
  $$\text{val}(f) = \sum_{(s, v) \in E} f(s, v) = \sum_{(u, t) \in E} f(u, t)$$
- Si la red original tiene aristas entrantes a $s$ o salientes de $t$ (y no necesitamos que el flujo vuelva a pasar por $s$ o $t$), o si existen **múltiples fuentes** $S = \{s_1, \dots, s_k\}$ y **múltiples sumideros** $T = \{t_1, \dots, t_r\}$, agregamos:
  - Una **super-fuente** $s^*$ con aristas $(s^*, s_i)$ de capacidad $\infty$ (o igual a la oferta máxima de $s_i$).
  - Un **super-sumidero** $t^*$ con aristas $(t_j, t^*)$ de capacidad $\infty$ (o igual a la demanda máxima de $t_j$).

### 2.3 Capacidades en los vértices (*Vertex Splitting*)
Las redes de flujo estándar solo tienen capacidades en las **aristas**. Si un problema impone que por un vértice $v \in V \setminus \{s, t\}$ no pueden pasar más de $c(v)$ unidades de flujo:
- **Transformación (División de vértices / *Vertex Splitting*):**
  1. Reemplazamos el vértice $v$ por dos vértices: $v_{\text{in}}$ (entrada) y $v_{\text{out}}$ (salida).
  2. Agregamos una **arista interna** dirigida $(v_{\text{in}}, v_{\text{out}})$ con capacidad $c(v_{\text{in}}, v_{\text{out}}) = c(v)$.
  3. Toda arista original entrante $(u, v)$ pasa a entrar a $v_{\text{in}}$: $(u, v_{\text{in}})$.
  4. Toda arista original saliente $(v, w)$ pasa a salir de $v_{\text{out}}$: $(v_{\text{out}}, w)$.

```
       (u, v)                        (u, v_in)          c(v)          (v_out, w)
  u ----------> [ v (cap c(v)) ] ----------> w   ===>   u -----> (v_in) ======> (v_out) -----> w
```

---

## 3. Red Residual y Camino de Aumento

### 3.1 ¿Por qué un enfoque Greedy directo falla?
Un algoritmo goloso ingenuo que busque iterativamente un camino de $s$ a $t$ con capacidad disponible en el grafo original y envíe todo el flujo posible **no alcanza el óptimo**.

**Contraejemplo clásico (El Rombo):**
Supongamos $s \to u$ (cap 1), $s \to v$ (cap 1), $u \to v$ (cap 1), $u \to t$ (cap 1), $v \to t$ (cap 1).
- Si primero elegimos el camino $s \to u \to v \to t$ y mandamos 1 unidad de flujo, saturamos $(s, u)$, $(u, v)$ y $(v, t)$.
- Ya no queda ningún camino de $s$ a $t$ en el grafo original con capacidad libre: ¡nos estancamos con $\text{val}(f) = 1$!
- Sin embargo, el flujo máximo es $\text{val}(f^*) = 2$ (enviando 1 por $s \to u \to t$ y 1 por $s \to v \to t$).
- **Lección:** Necesitamos un mecanismo para **"arrepentirnos"** o **deshacer/redirigir** el flujo enviado por $(u, v)$. Ese mecanismo es la **red residual**.

### 3.2 Definición de Red Residual $G_f$
Dado un flujo factible $f$ en la red $(G=(V,E), s, t, c)$, la **red residual** $G_f = (V, E_f)$ con función de **capacidad residual** $c_f : E_f \to \mathbb{R}_{>0}$ tiene el mismo conjunto de vértices $V$ y, para cada arista original $e = (u, v) \in E$:

1. **Arista directa / de avance (*forward edge*):** Si $f(u, v) < c(u, v)$, incluimos $(u, v) \in E_f$ con capacidad residual:
   $$c_f(u, v) = c(u, v) - f(u, v) > 0$$
   *(Representa cuánto flujo adicional podemos enviar de $u$ a $v$).*

2. **Arista inversa / de retroceso (*backward edge*):** Si $f(u, v) > 0$, incluimos $(v, u) \in E_f$ con capacidad residual:
   $$c_f(v, u) = f(u, v) > 0$$
   *(Representa cuánto flujo enviado previamente de $u$ a $v$ podemos cancelar/devolver de $v$ a $u$).*

> **Observación sobre el tamaño de $G_f$:** Cada arista $e \in E$ genera a lo sumo 2 aristas en $E_f$, por lo tanto $|E_f| \le 2|E| = 2m$, y construir/recorrer $G_f$ toma tiempo $O(n + m)$.

### 3.3 Camino de Aumento (*Augmenting Path*) y Operación de Aumento
Un **camino de aumento** $P$ es un **camino simple dirigido de $s$ a $t$ en la red residual $G_f$**.

La **capacidad residual (o cuello de botella / *bottleneck*)** del camino $P$ es el mínimo de las capacidades residuales de sus aristas:
$$\Delta(P) = c_f(P) = \min_{e \in P} c_f(e) > 0$$

**Operación `Aumentar(f, P)`:** Definimos un nuevo flujo $f'$ sobre $G$ modificando $f$ en $\Delta = \Delta(P)$ a lo largo de $P$:
$$f'(u, v) = \begin{cases} f(u, v) + \Delta & \text{si } (u, v) \in P \text{ es arista directa } ((u, v) \in E) \\ f(u, v) - \Delta & \text{si } (v, u) \in P \text{ es arista inversa } ((u, v) \in E) \\ f(u, v) & \text{si ni } (u, v) \text{ ni } (v, u) \text{ están en } P \end{cases}$$

**Lema de Correctitud del Aumento:** Si $f$ es un flujo factible en $G$ y $P$ es un camino de aumento en $G_f$ con cuello de botella $\Delta > 0$, entonces $f'$ es un **flujo factible** en $G$ y su valor verifica:
$$\text{val}(f') = \text{val}(f) + \Delta > \text{val}(f)$$
*Demostración breve:*
- **Capacidad:** Si $(u,v) \in P$ es directa, $\Delta \le c_f(u,v) = c(u,v) - f(u,v) \implies f'(u,v) = f(u,v) + \Delta \le c(u,v)$ y $f'(u,v) \ge 0$. Si $(v,u) \in P$ es inversa, $\Delta \le c_f(v,u) = f(u,v) \implies f'(u,v) = f(u,v) - \Delta \ge 0$ y $f'(u,v) \le c(u,v)$.
- **Conservación:** En cualquier vértice intermedio $v \in P \setminus \{s, t\}$, el camino $P$ entra por una arista y sale por otra. En los 4 casos posibles (directa-directa, directa-inversa, inversa-directa, inversa-inversa), el balance neto $f'^{\text{out}}(v) - f'^{\text{in}}(v)$ permanece idéntico a $f^{\text{out}}(v) - f^{\text{in}}(v) = 0$.
- **Valor:** Como $P$ es simple, sale de $s$ exactamente una vez (sumando $+\Delta$ al flujo saliente o restando $-\Delta$ al entrante), por lo que $\text{val}(f') = \text{val}(f) + \Delta$. $\blacksquare$

---

## 4. El Método de Ford-Fulkerson

Se lo llama **método** (y no algoritmo único) porque no especifica cómo elegir el camino de aumento $P$ en cada paso:

```
Ford-Fulkerson(G, s, t, c):
1. Inicializar f(e) <- 0 para toda arista e en E
2. Construir la red residual G_f
3. Mientras exista un camino dirigido P de s a t en G_f:
4.     Delta <- min_{e en P} c_f(e)
5.     Para cada arista (u, v) en P:
6.         Si (u, v) pertenece a E (es directa):
7.             f(u, v) <- f(u, v) + Delta
8.         Sino (es inversa, (v, u) pertenece a E):
9.             f(v, u) <- f(v, u) - Delta
10.    Actualizar G_f
11. Devolver f
```

### Análisis de Terminación y Complejidad de Ford-Fulkerson
- **Caso capacidades enteras ($c : E \to \mathbb{N}_0$):**
  - En cada iteración, las capacidades residuales son enteras positivas, por lo que $\Delta(P) \ge 1$.
  - El valor del flujo aumenta en al menos 1 unidad por iteración: $\text{val}(f') \ge \text{val}(f) + 1$.
  - Sea $F = \text{val}(f^*)$ el valor del flujo máximo (acotado por $\sum_{(s,v)\in E} c(s,v)$). El ciclo `Mientras` ejecuta a lo sumo $F$ iteraciones.
  - Encontrar $P$ con DFS o BFS en $G_f$ y actualizar $f$ cuesta $O(m)$ (asumiendo grafo conexo, $n \le m+1$).
  - **Complejidad temporal:** **$O(m \cdot F)$** — **pseudo-polinomial** (depende de la magnitud numérica de $F$, que puede ser exponencial en el tamaño en bits de la entrada).
- **El peor caso de Ford-Fulkerson (con DFS):**
  - En el rombo con capacidades $c(s,u)=c(s,v)=c(u,t)=c(v,t)=M$ (por ejemplo $M = 10^9$) y $c(u,v)=1$, si alternamos entre los caminos $s \to u \to v \to t$ y $s \to v \to u \to t$, en cada paso $\Delta = 1$ y el algoritmo realiza $2M = 2 \cdot 10^9$ iteraciones aunque $n=4, m=5$.
- **Caso capacidades racionales:** Siempre termina (multiplicando por el mínimo común denominador se reduce al caso entero).
- **Caso capacidades irracionales:** Ford-Fulkerson puede **no terminar nunca** y converger a un valor estrictamente menor que el flujo máximo.

---

## 5. Cortes $s$-$t$ y el Teorema de Flujo Máximo / Corte Mínimo

Para demostrar que cuando no hay caminos de aumento en $G_f$ el flujo $f$ es efectivamente **máximo**, necesitamos una cota superior dual: los **cortes $s$-$t$**.

### 5.1 Definición de Corte $s$-$t$ y su Capacidad
Un **corte $s$-$t$** en la red $(G=(V,E), s, t, c)$ es una partición de $V$ en dos conjuntos disjuntos $(S, T)$ (es decir, $T = V \setminus S$) tal que:
$$s \in S \quad \text{y} \quad t \in T$$

La **capacidad del corte $(S, T)$**, denotada $c(S, T)$, es la suma de las capacidades de las aristas que **salen de $S$ hacia $T$**:
$$c(S, T) = \sum_{\substack{u \in S, \, v \in T \\ (u, v) \in E}} c(u, v)$$

> **¡Cuidado fundamental de examen!** En la capacidad $c(S, T)$ **SOLO** suman las aristas dirigidas de $S$ hacia $T$ ($u \in S \to v \in T$). Las aristas que van de $T$ hacia $S$ ($v \in T \to u \in S$) **NO** suman ni restan en $c(S, T)$.

El **flujo neto a través del corte $(S, T)$** es:
$$f(S, T) - f(T, S) = \sum_{\substack{u \in S, \, v \in T \\ (u, v) \in E}} f(u, v) - \sum_{\substack{v \in T, \, u \in S \\ (v, u) \in E}} f(v, u)$$

### 5.2 Lema del Valor del Flujo a través de cualquier Corte (Dualidad Débil)
**Lema 1 (Invarianza del flujo neto por corte):** Para todo flujo factible $f$ y para **cualquier** corte $s$-$t$ $(S, T)$:
$$\text{val}(f) = f(S, T) - f(T, S)$$
*Demostración:* Como $b_f(u) = 0$ para todo $u \in S \setminus \{s\}$, tenemos:
$$\text{val}(f) = b_f(s) = \sum_{u \in S} b_f(u) = \sum_{u \in S} \left(\sum_{(u, v) \in E} f(u, v) - \sum_{(w, u) \in E} f(w, u)\right)$$
Separando según si el otro extremo pertenece a $S$ o a $T = V \setminus S$:
- Las aristas con ambos extremos en $S$ ($u \in S, v \in S$) aparecen una vez sumando y una vez restando, por lo que **se cancelan**.
- Las aristas con $u \in S, v \in T$ quedan sumando: $+f(S, T)$.
- Las aristas con $w \in T, u \in S$ quedan restando: $-f(T, S)$.
Por lo tanto, $\text{val}(f) = f(S, T) - f(T, S)$. $\blacksquare$

**Corolario (Cota Superior / Dualidad Débil):** Para todo flujo factible $f$ y todo corte $s$-$t$ $(S, T)$:
$$\text{val}(f) \le c(S, T)$$
*Demostración:* Como $f(u, v) \le c(u, v)$ para $u \in S, v \in T$ y $f(v, u) \ge 0$ para $v \in T, u \in S$:
$$\text{val}(f) = f(S, T) - f(T, S) \le f(S, T) - 0 \le c(S, T)$$
**Condición de optimalidad (holgura complementaria):** $\text{val}(f) = c(S, T)$ si y solo si:
1. Toda arista que sale de $S$ hacia $T$ está **saturada**: $\forall (u, v) \in E \text{ con } u \in S, v \in T \implies f(u, v) = c(u, v)$.
2. Toda arista que vuelve de $T$ hacia $S$ está **vacía (flujo nulo)**: $\forall (v, u) \in E \text{ con } v \in T, u \in S \implies f(v, u) = 0$.

### 5.3 Teorema de Flujo Máximo / Corte Mínimo (*Max-Flow Min-Cut Theorem*)
**Teorema (Ford & Fulkerson, 1956):** Sea $f$ un flujo factible en una red $(G, s, t, c)$. Las siguientes tres afirmaciones son equivalentes:
1. **$f$ es un flujo máximo** en $G$.
2. **La red residual $G_f$ no contiene ningún camino de aumento** (ningún camino dirigido de $s$ a $t$).
3. **Existe un corte $s$-$t$ $(S, T)$ tal que $\text{val}(f) = c(S, T)$** (y por ende $(S, T)$ es un **corte mínimo**).

*Demostración completa del ciclo de equivalencias:*
- **$(1) \implies (2)$:** Por contrarrecíproco. Si existiera un camino de aumento $P$ en $G_f$, aumentando por $P$ obtendríamos un flujo factible $f'$ con $\text{val}(f') = \text{val}(f) + \Delta(P) > \text{val}(f)$, contradiciendo que $f$ es máximo.
- **$(2) \implies (3)$ (Construcción del corte mínimo):** Supongamos que en $G_f$ no hay camino de $s$ a $t$. Definimos:
  $$S = \{v \in V : \text{existe un camino dirigido de } s \text{ a } v \text{ en } G_f\}, \qquad T = V \setminus S$$
  Claramente $s \in S$ y, por hipótesis, $t \notin S \implies t \in T$, luego $(S, T)$ es un corte $s$-$t$ válido.
  Consideremos cualquier par de vértices $u \in S$ y $v \in T$:
  - **Si $(u, v) \in E$ (arista de $S$ a $T$):** Si fuera $f(u, v) < c(u, v)$, entonces la arista directa $(u, v)$ estaría en $E_f$. Como $u \in S$ es alcanzable desde $s$ en $G_f$, $v$ también sería alcanzable desde $s$ en $G_f$, contradiciendo que $v \in T$. Por lo tanto, **$f(u, v) = c(u, v)$** (saturada).
  - **Si $(v, u) \in E$ (arista de $T$ a $S$):** Si fuera $f(v, u) > 0$, entonces la arista inversa $(u, v)$ estaría en $E_f$ con capacidad residual $c_f(u, v) = f(v, u) > 0$, haciendo a $v$ alcanzable desde $u \in S$, contradicción. Por lo tanto, **$f(v, u) = 0$** (vacía).
  Aplicando el Lema 1:
  $$\text{val}(f) = f(S, T) - f(T, S) = c(S, T) - 0 = c(S, T)$$
- **$(3) \implies (1)$:** Por el Corolario de Dualidad Débil, para cualquier flujo factible $f'$ vale $\text{val}(f') \le c(S, T) = \text{val}(f)$, luego $f$ es flujo máximo (y $(S, T)$ es corte mínimo). $\blacksquare$

> **¿Cómo recuperar el Corte Mínimo $(S, T)$ en la práctica?**
> 1. Corremos Edmonds-Karp hasta obtener el flujo máximo $f^*$.
> 2. En la red residual final $G_{f^*}$, corremos un **BFS o DFS desde $s$**.
> 3. El conjunto $S$ son todos los vértices visitados (alcanzables desde $s$ en $G_{f^*}$), y $T = V \setminus S$. Las aristas del corte mínimo son exactamente las aristas $(u, v) \in E$ con $u \in S$ y $v \in T$. Esto toma tiempo adicional $O(n + m)$.

---

## 6. El Algoritmo de Edmonds-Karp: Demostración y Complejidad

**Edmonds y Karp (1972)** demostraron que si en el método de Ford-Fulkerson elegimos en cada iteración el **camino de aumento más corto en cantidad de aristas** (usando **BFS** en la red residual $G_f$, donde cada arista de $E_f$ tiene peso 1), el algoritmo termina siempre en una cantidad **fuertemente polinomial** de iteraciones $O(n \cdot m)$, independientemente de las capacidades $c$.

### 6.1 Lema de Monotonía de las Distancias en $G_f$
Sea $d_f(v) = \delta_{G_f}(s, v)$ la distancia mínima en cantidad de aristas desde $s$ hasta $v$ en $G_f$ ($\infty$ si es inalcanzable).
**Lema 2 (Monotonía):** Si $f'$ se obtiene de $f$ aumentando por un camino mínimo $P$ en $G_f$, entonces para todo $v \in V$:
$$d_{f'}(v) \ge d_f(v)$$
*Idea de la demostración (por contradicción sobre el vértice $v$ con menor $d_{f'}(v)$ que viola la propiedad):*
- Sea $v$ el vértice con mínimo $d_{f'}(v)$ tal que $d_{f'}(v) < d_f(v)$, y sea $(u, v) \in E_{f'}$ la última arista de un camino mínimo de $s$ a $v$ en $G_{f'}$, de modo que $d_{f'}(v) = d_{f'}(u) + 1$.
- Por minimalidad de $v$, para $u$ se cumple $d_{f'}(u) \ge d_f(u)$.
- **Caso 1: $(u, v) \in E_f$.** Entonces en $G_f$ ya valía $d_f(v) \le d_f(u) + 1 \le d_{f'}(u) + 1 = d_{f'}(v)$, contradicción.
- **Caso 2: $(u, v) \notin E_f$.** Como $(u, v)$ apareció en $E_{f'}$ recién después de aumentar por $P$, el camino $P$ debió usar la arista opuesta **$(v, u)$** en $G_f$. Como $P$ era un camino mínimo desde $s$ en $G_f$, esto implica que $d_f(u) = d_f(v) + 1 \iff d_f(v) = d_f(u) - 1$. Pero entonces:
  $$d_{f'}(v) = d_{f'}(u) + 1 \ge d_f(u) + 1 = (d_f(v) + 1) + 1 = d_f(v) + 2 > d_f(v)$$
  ¡Contradicción! Luego $d_{f'}(v) \ge d_f(v)$ para todo $v \in V$. $\blacksquare$

### 6.2 Aristas Críticas y Cota de $O(n \cdot m)$ Iteraciones
En cada aumento por un camino $P$, al menos una arista $e = (u, v) \in P$ alcanza el cuello de botella ($c_f(u, v) = \Delta(P)$) y **desaparece** de la red residual $G_{f'}$. Decimos que $(u, v)$ es una **arista crítica** de esa iteración.

**Lema 3 (Distancia entre apariciones como arista crítica):** Una misma arista dirigida $(u, v)$ puede ser crítica a lo sumo $O(n)$ veces (más precisamente, $\le n/2$ veces).
*Demostración:*
1. Cuando $(u, v)$ es crítica por primera vez en el flujo $f$, está en un camino mínimo $P$ de $G_f$, luego:
   $$d_f(v) = d_f(u) + 1$$
2. Al saturarse, $(u, v)$ desaparece de la red residual. Para que $(u, v)$ vuelva a aparecer en la red residual en algún flujo posterior $f'$, el algoritmo debe antes enviar flujo por la arista opuesta $(v, u)$ a lo largo de un camino mínimo en $G_{f'}$, lo cual exige:
   $$d_{f'}(u) = d_{f'}(v) + 1$$
3. Cuando $(u, v)$ vuelve a ser crítica en un flujo posterior $f''$, usando la monotonía de distancias ($d_{f''}(u) \ge d_{f'}(u)$ y $d_{f'}(v) \ge d_f(v)$):
   $$d_{f''}(u) \ge d_{f'}(u) = d_{f'}(v) + 1 \ge d_f(v) + 1 = (d_f(u) + 1) + 1 = d_f(u) + 2$$
4. Es decir, cada vez que $(u, v)$ vuelve a ser crítica, la distancia $d(u)$ desde $s$ **aumenta en al menos 2 unidades**. Como $d(u)$ empieza siendo $\ge 0$ y mientras $(u, v)$ pueda estar en un camino simple a $t$ debe ser $d(u) \le n - 2$, $(u, v)$ puede ser crítica a lo sumo $\frac{n}{2}$ veces.
5. Como hay a lo sumo $2m$ aristas posibles en $E_f$ y cada iteración tiene al menos una arista crítica, la cantidad total de iteraciones (aumentos) es a lo sumo:
   $$2m \cdot \frac{n}{2} = n \cdot m = O(n \cdot m)$$

### 6.3 Complejidad Total de Edmonds-Karp
Cada iteración ejecuta un BFS en $G_f$ en tiempo $O(m)$ (grafo conexo). Combinando la cota por capacidad entera $F = |f^*|$ y la cota polinomial de Edmonds-Karp:
$$\boxed{\text{Complejidad de Edmonds-Karp} = O\big(\min(m \cdot |f^*|, \, n \cdot m^2)\big)}$$

> **Tip crucial para análisis de complejidad en parciales:** En la materia, siempre expresamos el costo de correr flujo como $O(\min(n m^2, \, m |f^*|))$, donde $n = |V_{\text{red}}|$ y $m = |E_{\text{red}}|$ son los tamaños de la red construida. En muchísimos problemas de asignación o caminos disjuntos, $|f^*|$ es chico (por ejemplo $|f^*| \le N$), por lo que $O(m |f^*|)$ da una cota mucho más ajustada que $O(n m^2)$ (ej. $O(N^3)$ en lugar de $O(N^5)$).

---

## 7. Teorema de Integralidad del Flujo

**Teorema de Integralidad:** Si todas las capacidades de la red son enteras ($c : E \to \mathbb{N}_0$), entonces existe un flujo máximo $f^*$ tal que **$f^*(e) \in \mathbb{N}_0$ para toda arista $e \in E$**. Más aún, el método de Ford-Fulkerson (y en particular Edmonds-Karp) computa siempre un flujo máximo entero.

*Demostración:* Por inducción en las iteraciones de Ford-Fulkerson:
- **Caso base:** El flujo inicial $f_0(e) = 0$ es entero para toda $e \in E$.
- **Paso inductivo:** Si $f_k$ es entero y $c$ es entera, todas las capacidades residuales $c_{f_k}(e)$ son diferencias de enteros, luego enteras. Por ende, el cuello de botella $\Delta = \min_{e \in P} c_{f_k}(e)$ es un entero positivo, y $f_{k+1}$ (que suma o resta $\Delta$) sigue siendo entero en toda arista. $\blacksquare$

> **¿Por qué es el teorema más importante para modelar?**
> Porque nos permite modelar **decisiones discretas** (asignar o no una persona a una tarea, usar o no una arista en un camino, orientar una arista hacia un lado u otro): si ponemos capacidad $1$, el Teorema de Integralidad garantiza que en el flujo hallado por Edmonds-Karp el flujo por esa arista será **exactamente $0$ o $1$** (nunca $0.5$), permitiendo una biyección directa entre flujos enteros y soluciones discretas del problema.

---

## 8. Receta General para Resolver y Demostrar Problemas de Modelado

En la Clase Práctica 10 se establece una **estructura de 5 pasos obligatorios** que todo ejercicio de modelado con flujo debe incluir en un parcial:

1. **Construcción explícita de la red $(G=(V,E), s, t, c)$:**
   - Definir claramente qué conjuntos de vértices forman $V$ (incluyendo $s$ y $t$) y cuántos hay en función de la entrada ($|V| = \dots$).
   - Definir cada familia de aristas dirigidas en $E$ y su capacidad $c(e)$ (indicando cuántas aristas aporta cada familia, $|E| = \dots$).
2. **Interpretación física del flujo:**
   - Explicar qué representa que circulen $k$ unidades de flujo por cada tipo de arista y qué restricción del enunciado modela cada capacidad $c(e)$ y la conservación del flujo en cada capa de vértices.
3. **Demostración de Correctitud (Doble Implicación $\iff$):**
   - **Si es un problema de factibilidad / asignación / caminos:** Probar que *"Existe una solución válida del problema de tamaño $K \iff$ Existe un flujo factible entero en la red de valor $|f| = K$"*.
     - **($\Rightarrow$) De Solución a Flujo:** Dada una solución válida del problema, definir explícitamente cuánto vale $f(e)$ en cada arista y verificar que cumple: (a) Capacidad $0 \le f(e) \le c(e)$, (b) Conservación en cada vértice interno, y (c) $\text{val}(f) = K$.
     - **($\Leftarrow$) De Flujo a Solución:** Dado un flujo factible $f$ de valor $K$, invocar primero el **Teorema de Integralidad** para asumir sin pérdida de generalidad que $f(e) \in \mathbb{Z}_{\ge 0}$, y mostrar cómo reconstruir una solución del problema que respeta todas las restricciones del enunciado.
   - **Si es un problema de Corte Mínimo:** Probar que *"Existe una solución de costo/beneficio $W \iff$ Existe un corte $s$-$t$ $(S, T)$ de capacidad finita $c(S, T) = \text{cte} \pm W$"*:
     - Mostrar qué significa que un vértice $v$ caiga en $S$ vs. que caiga en $T$.
     - Explicar por qué las aristas de capacidad $\infty$ impiden que un corte de capacidad finita viole las dependencias lógicas ($u \in S \implies v \in S$).
4. **Recuperación de la solución:** Explicar cómo leer la respuesta final en base a $f^*$ (o al conjunto alcanzable $S$ en $G_{f^*}$ si es corte mínimo).
5. **Análisis de Complejidad:**
   - Calcular $|V|$ y $|E|$ en términos de los parámetros del problema original.
   - Acotar el flujo máximo $|f^*|$ (si aplica).
   - Concluir con el costo de construir la red más el costo de Edmonds-Karp: $O(|V| + |E| + \min(|V||E|^2, \, |E||f^*|))$.

---

## 9. Catálogo de Patrones de Modelado (Teórica, Práctica y Guía 9)

### Patrón I: Caminos Disjuntos en Aristas y Vértices (Teorema de Menger)

#### 1. Caminos Dirigidos Disjuntos en Aristas (Guía 9, Ej. 3 y Ej. 4a)
- **Problema:** Dado un digrafo $D = (V, E)$ y dos vértices $s, t$, hallar la máxima cantidad de caminos dirigidos de $s$ a $t$ que no compartan aristas (pueden compartir vértices).
- **Red:** El mismo digrafo con capacidad **$c(e) = 1$** para toda arista $e \in E$.
- **Caso Grafo No Dirigido:** Si el grafo original $G=(V,E)$ es no dirigido, reemplazamos cada arista no dirigida $\{u, v\}$ por las dos aristas dirigidas $(u, v)$ y $(v, u)$, ambas con capacidad $1$.
  - *Detalle técnico crucial (Cancelación de flujos opuestos):* Si un flujo entero usa tanto $f(u,v)=1$ como $f(v,u)=1$, podemos cancelar ambos ($f(u,v)=f(v,u)=0$) sin alterar la conservación de flujo en $u$ ni en $v$ ni el valor $|f|$, garantizando que nunca se use una misma calle en ambos sentidos.
- **Recuperación de los $k = |f^*|$ caminos:** Desde $s$, seguimos aristas con $f(e) = 1$ hasta llegar a $t$ (si hay ciclos con flujo 1, se descartan; pero o bien descomponemos greedily de $s$ a $t$ restando 1 al flujo de las aristas usadas en cada paso).
- **Complejidad:** Como $|f^*| \le \min(d_{\text{out}}(s), n) \le n$, Edmonds-Karp tarda $O(m \cdot |f^*|) = O(n \cdot m)$.

#### 2. Caminos Disjuntos en VérticesInternos (Guía 9, Ej. 4b — *Popular*)
- **Problema:** Máxima cantidad de caminos de $s$ a $t$ que no compartan **vértices internos** (esquinas).
- **Red:** Aplicamos **Vertex Splitting** a todo vértice interno $v \in V \setminus \{s, t\}$:
  - Creamos $v_{\text{in}}$ y $v_{\text{out}}$ con arista $(v_{\text{in}}, v_{\text{out}})$ de capacidad **$1$**.
  - Las aristas originales $(u, v)$ pasan a ser $(u_{\text{out}}, v_{\text{in}})$ con capacidad **$1$** (o $\infty$).
- **Teorema de Menger (Versión Corte):** Por el Teorema de Max-Flow Min-Cut, la máxima cantidad de caminos internamente disjuntos en vértices (o aristas) de $s$ a $t$ es exactamente igual a la **mínima cantidad de vértices internos (o aristas) que hay que eliminar** para desconectar $s$ de $t$.

---

### Patrón II: Matching Bipartito, Asignación y Circulación con Demandas

#### 1. Matching Bipartito Máximo (Teórica 10 / Guía 9, Ej. 5)
- **Problema:** Dado un grafo bipartito $G = (A \cup B, E)$ con $|A| \le |B| \le N$, hallar el emparejamiento (matching) de tamaño máximo.
- **Red:**
  - Fuente $s$ conectada a todo $a \in A$ con capacidad $c(s, a) = 1$.
  - Para cada arista $\{a, b\} \in E$ ($a \in A, b \in B$), arista dirigida $(a, b)$ con capacidad $c(a, b) = 1$ (o $\infty$).
  - Todo $b \in B$ conectado al sumidero $t$ con capacidad $c(b, t) = 1$.
- **Complejidad:** $|V| = |A| + |B| + 2 = O(N)$, $|E| = |E_{\text{orig}}| + |A| + |B| = O(N^2)$, y el flujo máximo cumple $|f^*| \le |A| \le N$. Por lo tanto, Edmonds-Karp tarda **$O(m \cdot |f^*|) = O(N \cdot m) \subseteq O(N^3)$**.

#### 2. Asignación con Capacidades Múltiples y Capas Intermedias
- **Familias y Mesas / Casamiento (Guía 9, Ej. 6):**
  - $m$ familias (la familia $i$ tiene $f_i$ integrantes) y $n$ mesas (la mesa $j$ tiene capacidad $c_j$). Ningún par de integrantes de la misma familia puede sentarse en la misma mesa.
  - **Red:**
    - Arista $(s, \text{Fam}_i)$ con capacidad $f_i$.
    - Arista $(\text{Fam}_i, \text{Mesa}_j)$ con capacidad **$1$** para todo par $(i, j)$ (fuerza a lo sumo 1 miembro de la familia $i$ en la mesa $j$).
    - Arista $(\text{Mesa}_j, t)$ con capacidad $c_j$.
  - **Condición de éxito:** Es posible ubicar a todos $\iff |f^*| = \sum_{i=1}^m f_i$.

- **Guardias de Médicos en el Hospital con Feriados (Clase Práctica 10 / Guía 9, Ej. 8):**
  - $m$ médicos, $n$ días de feriado divididos en $k$ períodos $F_1, \dots, F_k$.
  - Restricciones: (1) Se necesita exactamente 1 médico por día $j$. (2) El médico $i$ solo puede trabajar los días $S_i$. (3) El médico $i$ trabaja a lo sumo $c$ días en total. (4) El médico $i$ trabaja **a lo sumo 1 día en cada período de feriado $F_r$**.
  - **Truco de la Capa Intermedia (Médico $\times$ Período):** Para imponer la restricción (4) sin perder la (3), intercalamos nodos $P_{i, r}$ que representan *"el médico $i$ en el período $F_r$"*:
    - $(s, \text{Med}_i)$ con capacidad **$c$** (máximo total de días del médico $i$).
    - $(\text{Med}_i, P_{i, r})$ con capacidad **$1$** para cada período $r \in \{1, \dots, k\}$ (a lo sumo 1 día del médico $i$ en el período $F_r$).
    - $(P_{i, r}, \text{Dia}_j)$ con capacidad **$1$** si el día $j \in F_r$ y además $j \in S_i$.
    - $(\text{Dia}_j, t)$ con capacidad **$1$** para cada uno de los $n$ días.
  - **Condición:** Existe asignación válida $\iff |f^*| = n$.

- **Matrices con Sumas de Filas y Columnas Dadas (Guía 9, Ej. 7) y Realización de Digrafos (Guía 9, Ej. 9):**
  - **Matrices (Ej. 7):** Construir matriz de $m \times n$ con entradas en $\{0, \dots, k\}$ tal que la fila $i$ sume $r_i$ y la columna $j$ sume $c_j$. Red: $(s, \text{Fila}_i)$ cap $r_i$, $(\text{Fila}_i, \text{Col}_j)$ cap $k$, $(\text{Col}_j, t)$ cap $c_j$. Factible $\iff \sum r_i = \sum c_j = |f^*|$.
  - **Digrafos con grados de entrada y salida dados (Ej. 9):** Nodos de salida $u_{\text{out}}$ y de entrada $v_{\text{in}}$. $(s, u_{\text{out}})$ cap $d_{\text{out}}(u)$, $(u_{\text{out}}, v_{\text{in}})$ cap $1$ para todo $u \neq v$ (sin bucles), $(v_{\text{in}}, t)$ cap $d_{\text{in}}(v)$.

- **Eulerizando un Grafo Mixto $G = (V, E, A)$ (Clase Práctica 10 / Guía 9, Ej. 10):**
  - Un grafo mixto tiene aristas no dirigidas $E$ y dirigidas $A$. Queremos orientar cada arista de $E$ para que el digrafo resultante tenga un **ciclo euleriano dirigido** (es decir, sea fuertemente conexo/conexo y todo vértice cumpla $d_{\text{in}}(v) = d_{\text{out}}(v)$).
  - **Paso 1 (Condición necesaria de paridad):** Sea $d(v)$ el grado total de $v$ (contando tanto $E$ como $A$). Para que al final sea $d_{\text{in}}(v) = d_{\text{out}}(v) = d(v)/2$, es necesario que **$d(v)$ sea par** para todo $v \in V$ y que para todo $v$ el grado de entrada ya fijado por $A$ cumpla $d_{\text{in}}^A(v) \le d(v)/2$. Si falla para algún $v$, devolver `IMPOSIBLE`.
  - **Paso 2 (Demanda de entradas por vértice):** A cada vértice $v$ le faltan exactamente:
    $$r(v) = \frac{d(v)}{2} - d_{\text{in}}^A(v) \ge 0$$
    aristas entrantes provenientes de orientar aristas de $E$. Notar que $\sum_{v \in V} r(v) = |E|$.
  - **Paso 3 (Red de Flujo de Asignación de Orientaciones):**
    - Creamos un nodo $x_e$ por cada arista no dirigida $e = \{u, v\} \in E$.
    - Arista $(s, x_e)$ con capacidad **$1$** (cada arista no dirigida tiene 1 "punta de flecha" para asignar a $u$ o a $v$).
    - Aristas $(x_e, u)$ y $(x_e, v)$ con capacidad **$1$** (si el flujo va a $u$, orientamos $v \to u$; si va a $v$, orientamos $u \to v$).
    - Arista $(v, t)$ con capacidad **$r(v)$** para todo $v \in V$.
  - **Condición:** Existe orientación euleriana $\iff |f^*| = |E|$ (y el grafo subyacente es conexo).

---

### Patrón III: Decisiones Binarias e Implicaciones vía Corte Mínimo

Este es el patrón más sofisticado y frecuente en los parciales. En vez de interpretar qué viaja por las aristas, **usamos el valor del Corte Mínimo $c(S, T)$ para optimizar una función objetivo con decisiones binarias e implicaciones**.

#### La Regla de Oro del Modelado por Corte Mínimo
Para cada elemento/decisión $i$, creamos un vértice $v_i$. Todo corte $s$-$t$ $(S, T)$ toma una decisión binaria sobre $v_i$:
- **$v_i \in S$ (del lado de la fuente $s$):** Tomamos la decisión $A$ (ej. "seleccionar el proyecto $i$", "comprar la máquina $i$", "dejar el nodo en el conjunto independiente").
- **$v_i \in T$ (del lado del sumidero $t$):** Tomamos la decisión $B$ (ej. "no hacer el proyecto $i$", "alquilar/tercerizar").

**¿Cómo codificar costos e implicaciones con capacidades?**
1. **Costo por elegir $v_i \in T$:** Ponemos una arista **$(s, v_i)$ con capacidad $w_i$**. Si $v_i \in T$, la arista $(s, v_i)$ cruza de $S$ a $T$ y **paga $w_i$** en el corte.
2. **Costo por elegir $v_i \in S$:** Ponemos una arista **$(v_i, t)$ con capacidad $c_i$**. Si $v_i \in S$, la arista $(v_i, t)$ cruza de $S$ a $T$ y **paga $c_i$** en el corte.
3. **Implicación dura ($u \in S \implies v \in S$) / Prohibición ($u \in S \land v \in T$):**
   Ponemos una arista dirigida **$(u, v)$ con capacidad $\infty$** (en la práctica, $\infty = 1 + \sum \text{pesos finitos}$).
   - **¿Por qué funciona?** Si ocurriera $u \in S$ y $v \in T$, la arista $(u, v)$ cruzaría de $S$ a $T$ aportando $\infty$ a $c(S, T)$. Como el corte trivial $(\{s\}, V \setminus \{s\})$ tiene capacidad finita, **ningún corte mínimo jamás tendrá $u \in S$ y $v \in T$**. Por lo tanto, en todo corte de capacidad finita:
     $$(u, v) \text{ tiene capacidad } \infty \quad \Longleftrightarrow \quad (u \in S \implies v \in S)$$

---

#### 1. Selección de Proyectos / Clausura de Peso Máximo (*Project Selection*, Teórica 10)
- **Problema:** Dados $n$ proyectos donde cada proyecto $i$ tiene un rédito neto $w_i \in \mathbb{Z}$ (si $w_i > 0$ da ganancia; si $w_i < 0$ tiene costo $|w_i| = -w_i$) y un DAG de dependencias (para hacer $i$ es obligatorio hacer $j$, es decir $i \to j$), elegir un subconjunto factible de proyectos $X$ que maximice $\sum_{i \in X} w_i$.
- **Truco de conversión de Maximizar Ganancia a Minimizar Pérdida (Corte Mínimo):**
  Sea $P = \sum_{i : w_i > 0} w_i$ la **ganancia bruta máxima ideal** (la suma de todos los proyectos rentables).
  Para cualquier selección factible $X$ (que identificaremos con los proyectos que quedan en $S$, $X = S \setminus \{s\}$):
  $$\text{Ganancia}(X) = \sum_{i \in X} w_i = \underbrace{\sum_{i : w_i > 0} w_i}_{P} - \underbrace{\sum_{\substack{i \notin X \\ w_i > 0}} w_i}_{\substack{\text{proyectos rentables} \\ \text{que dejamos afuera } (i \in T)}} - \underbrace{\sum_{\substack{i \in X \\ w_i < 0}} (-w_i)}_{\substack{\text{proyectos costosos} \\ \text{que incluimos } (i \in S)}}$$
  ¡Maximizar $\text{Ganancia}(X)$ es exactamente equivalente a **minimizar la pérdida** respecto de $P$!
- **Construcción de la Red:**
  - Para cada proyecto rentable ($w_i > 0$): arista **$(s, i)$ con capacidad $w_i$** (si $i \in T$, no lo hacemos y perdemos $w_i$).
  - Para cada proyecto costoso ($w_i < 0$): arista **$(i, t)$ con capacidad $-w_i = |w_i|$** (si $i \in S$, lo hacemos y pagamos $-w_i$).
  - Para cada dependencia *"hacer $i$ requiere hacer $j$"*: arista **$(i, j)$ con capacidad $\infty$** (fuerza $i \in S \implies j \in S$).
- **Fórmula fundamental:** Para todo corte $(S, T)$ de capacidad finita ($c(S, T) \le P$), el conjunto $X = S \setminus \{s\}$ es factible y cumple:
  $$c(S, T) = \sum_{\substack{i \in T \\ w_i > 0}} w_i + \sum_{\substack{i \in S \\ w_i < 0}} (-w_i) = P - \sum_{i \in X} w_i \quad \Longrightarrow \quad \boxed{\text{Ganancia Máxima} = P - c(S^*, T^*) = P - |f^*|}$$

#### 2. Cubrimiento de Vértices de Peso Mínimo (*Min-Weight Vertex Cover*) y Conjunto Independiente de Peso Máximo (*Max-Weight Independent Set*) en Grafos Bipartitos
Sea $G = (A \cup B, E)$ un grafo **bipartito** donde cada vértice $v \in A \cup B$ tiene un peso no negativo $w(v) \ge 0$.
- **Problema A (Min-Weight Vertex Cover — ej. Guía 9, Ej. 18):** Elegir un subconjunto de vértices $C \subseteq A \cup B$ de peso mínimo tal que toda arista $(a, b) \in E$ tenga al menos un extremo en $C$ ($a \in C \lor b \in C$).
- **Problema B (Max-Weight Independent Set — ej. Guía 9, Ej. 16 y Ej. 17):** Elegir un subconjunto de vértices $I \subseteq A \cup B$ de peso máximo sin aristas internas ($\forall (a,b) \in E, \neg(a \in I \land b \in I)$).
- **Relación:** $I$ es un Conjunto Independiente $\iff C = (A \cup B) \setminus I$ es un Vertex Cover. Por lo tanto:
  $$\text{Peso}(I) = \sum_{v \in A \cup B} w(v) - \text{Peso}(C)$$
- **Construcción de la Red Bipartita con $\infty$ en el medio:**
  - Arista **$(s, a)$ con capacidad $w(a)$** para todo $a \in A$.
  - Arista **$(b, t)$ con capacidad $w(b)$** para todo $b \in B$.
  - Arista **$(a, b)$ con capacidad $\infty$** para toda arista de conflicto $(a, b) \in E$.
- **Interpretación del Corte $(S, T)$ de capacidad finita:**
  - Como ninguna arista $(a, b)$ de capacidad $\infty$ puede cruzar de $S$ a $T$, **nunca puede ocurrir $a \in S \land b \in T$**.
  - Es decir, para toda arista $(a, b) \in E$, se cumple $(a \in T) \lor (b \in S)$.
  - ¿Cuáles son las aristas finitas que cruzan de $S$ a $T$ y se pagan en $c(S, T)$?
    - Las aristas $(s, a)$ tales que **$a \in T$** (aportan $w(a)$).
    - Las aristas $(b, t)$ tales que **$b \in S$** (aportan $w(b)$).
  - Por lo tanto:
    - **El Vertex Cover de peso mínimo** es $C^* = (A \cap T) \cup (B \cap S)$, con peso igual a $c(S^*, T^*) = |f^*|$.
    - **El Independent Set de peso máximo** es su complemento $I^* = (A \cap S) \cup (B \cap T)$, con peso igual a $\sum_{v \in A \cup B} w(v) - |f^*|$.

> **¡Truco de asimetría en Bipartitos!** Notar cómo en el lado izquierdo ($A$) estar en el Independent Set es quedar en $S$ ($a \in S$), mientras que en el lado derecho ($B$) estar en el Independent Set es quedar en $T$ ($b \in T$). ¡Esa inversión de lados entre $A$ y $B$ es lo que permite convertir el conflicto simétrico $\neg(a \in I \land b \in I)$ en la condición de corte dirigido $\neg(a \in S \land b \in T)$!

---

## 10. Recorrido Completo por los Ejercicios de la Guía Práctica 9

A continuación se resume la resolución e idea clave de los **19 ejercicios de la Guía 9**, organizados por bloque:

| Ej. | Título | Idea Clave / Modelado de la Red | Complejidad |
| :--- | :--- | :--- | :--- |
| **1–2** | Seguimiento de Ford-Fulkerson y Edmonds-Karp | Trazar aumentos en $G_f$, identificar aristas directas e inversas, y hallar el corte mínimo $(S, T)$ vía alcanzabilidad desde $s$ en $G_{f^*}$. | $O(m)$ por paso |
| **3** | Caminos disjuntos en aristas (digrafo) | Capacidad $1$ en toda arista. Por integralidad, flujo de valor $k \iff k$ caminos disjuntos en aristas. | $O(nm)$ |
| **4** | *Popular* (Caminos disjuntos en calles y esquinas) | **(a) Calles:** Grafo no dirigido $\to$ dos aristas dirigidas opuestas de cap $1$ (cancelando flujos antiparalelos). **(b) Esquinas:** *Vertex splitting* $v_{\text{in}} \to v_{\text{out}}$ con cap $1$ para toda esquina interna. | $O(nm)$ |
| **5** | Matching Máximo Bipartito | Red $s \to A \to B \to t$ con todas las capacidades iguales a $1$. | $O(n \cdot m)$ |
| **6** | *Casamiento* (Familias y Mesas) | $(s, \text{Fam}_i)$ cap $f_i$; $(\text{Fam}_i, \text{Mesa}_j)$ cap $1$; $(\text{Mesa}_j, t)$ cap $c_j$. Éxito $\iff |f^*| = \sum f_i$. | $O(nm \sum f_i)$ |
| **7** | *Sumas en una matriz* | $(s, \text{Fila}_i)$ cap $r_i$; $(\text{Fila}_i, \text{Col}_j)$ cap $k$; $(\text{Col}_j, t)$ cap $c_j$. Entrada $M_{ij} = f(\text{Fila}_i, \text{Col}_j)$. | $O(nm(n+m)^2)$ |
| **8** | *Hospitales* (Médicos y feriados) | Capa intermedia $P_{i, r}$ (médico $i$, período $r$): $s \xrightarrow{c} \text{Med}_i \xrightarrow{1} P_{i, r} \xrightarrow{1} \text{Dia}_j \xrightarrow{1} t$. | $O(m \cdot n^2)$ |
| **9** | *Realización de digrafos* | Bipartito $V_{\text{out}} \to V_{\text{in}}$ con cap $1$ para $u \neq v$; $(s, u_{\text{out}})$ cap $d_{\text{out}}(u)$; $(v_{\text{in}}, t)$ cap $d_{\text{in}}(v)$. | $O(n^3)$ |
| **10** | *Eulerizando un grafo mixto* | Verificar paridad de $d(v)$. Demanda $r(v) = d(v)/2 - d_{\text{in}}^A(v)$. Nodos $x_e$ por $e \in E$: $s \xrightarrow{1} x_e \xrightarrow{1} \{u, v\}$ y $v \xrightarrow{r(v)} t$. | $O(m^2 n)$ |
| **11** | *Cena de zorros* (CF 510E — Mesas circulares con suma prima) | Todo primo $>2$ es impar $\implies$ suma prima requiere **1 par + 1 impar** (salvo $2+2$ que no es primo). Grafo bipartito Pares ($A$) vs Impares ($B$) con arista si $a_i + a_j$ es primo. Para formar unión de ciclos simples de longitud $\ge 3$, cada zorro debe tener **grado exactamente 2** en el subgrafo elegido: $(s, a)$ cap $2$, $(a, b)$ cap $1$, $(b, t)$ cap $2$. Factible $\iff |f^*| = n$ (con $|A|=|B|=n/2$). | $O(n^3)$ |
| **12** | *Arreglo y operaciones* (CF 498C — Dividir por primos en pares de distinta paridad) | Como los pares permitidos $(i_k, j_k)$ tienen distinta paridad de índice, el grafo de pares es **bipartito** (Índices Impares vs Índices Pares). Además, las divisiones por distintos factores primos $p$ **no interactúan entre sí**. Para cada primo $p$ que divide a algún $a_i$, armamos una red donde la capacidad de $i$ (con $s$ o con $t$) es el exponente $v_p(a_i)$ con que $p$ divide a $a_i$, y las aristas $(i_k, j_k)$ tienen cap $\infty$. Sumamos los flujos máximos de cada primo $p$. | $O(\text{primos} \cdot n m)$ |
| **13** | *Máquinas y tareas* (Corte Mínimo básico) | Tareas $A_i$ ($s \to A_i$ cap beneficio o penalidad por tercerizar) que requieren máquinas $B_j$ ($B_j \to t$ cap costo de compra de la máquina). Si $A_i$ usa $B_j$ o alquilarla cuesta $c_{ij}$, arista $(A_i, B_j)$ cap $c_{ij}$ (o $\infty$ si es obligatoria). | $O(nm^2)$ |
| **14** | *Sufijo de suma máxima* / Clausura | Caso particular de Selección de Proyectos donde elegir la posición $i$ obliga a elegir $i+1$: aristas $(i, i+1)$ de capacidad $\infty$. | $O(n^3)$ |
| **15** | *Edificios y restricciones* (CF 1146G — Alturas $0 \dots h$ y multas) | Para cada edificio $i \in \{1..n\}$ creamos una **cadena de nodos booleanos** $v_{i, 1}, v_{i, 2}, \dots, v_{i, h}$ donde $v_{i, k} \in S \iff \text{altura}(i) \ge k$. Para que sea consistente ($\text{altura}(i) \ge k \implies \text{altura}(i) \ge k-1$), ponemos aristas **$(v_{i, k}, v_{i, k-1})$ de capacidad $\infty$**. La ganancia marginal de pasar de altura $k-1$ a $k$ es $k^2 - (k-1)^2 = 2k-1$ (arista $(s, v_{i, k})$ cap $2k-1$). Cada restricción $j$ que multa con $c_j$ si algún edificio en $[l_j, r_j]$ supera $x_j$ se modela con un nodo $R_j$: arista $(R_j, t)$ cap $c_j$ y aristas $(v_{i, x_j+1}, R_j)$ cap $\infty$ para todo $i \in [l_j, r_j]$. | $O(V E^2)$ |
| **16** | *Juego de cartas* (CF 808F — Suma de mágicos no prima) | Búsqueda binaria en el nivel $L$. Para un nivel fijo, queremos el **Conjunto Independiente de Peso Máximo** (suma de poderes $p_i$) sin dos cartas cuya suma de números mágicos $c_i + c_j$ sea prima. Como $1+1=2$ es primo, a lo sumo podemos elegir **una** carta con $c_i = 1$ (quedarnos con la de mayor poder). Con eso, todo conflicto primo ocurre entre Par e Impar $\implies$ grafo bipartito $\implies$ Min-Cut. | $O(\log n \cdot n^3)$ |
| **17** | *Alumnos en el examen* (LeetCode 1349) | Un alumno en $(r, c)$ solo tiene conflicto con asientos en las columnas $c-1$ y $c+1$. ¡Si particionamos los asientos según la **paridad de la columna** (Columnas Pares vs Columnas Impares), el grafo de conflictos es **bipartito**! Se resuelve hallando el Conjunto Independiente Máximo: $|V_{\text{sanos}}| - |f^*|$. | $O((nm)^{2.5})$ |
| **18** | *Destruyendo el grafo* (POJ 2125) | Para cada arista dirigida $(u, v) \in E$, debemos o bien pagar $w^+(u)$ para borrar todas las salientes de $u$, o bien pagar $w^-(v)$ para borrar todas las entrantes a $v$. Es un **Minimum Weight Vertex Cover en el grafo bipartito de división de vértices** ($V^+ \cup V^-$): $(s, u^+)$ cap $w^+(u)$, $(v^-, t)$ cap $w^-(v)$, y $(u^+, v^-)$ cap $\infty$ por cada $(u, v) \in E$. Las aristas cortadas dan exactamente las operaciones a realizar. | $O(nm^2)$ |
| **19** | *Cartas en la grilla* (AtCoder ABC259G) | Elegir filas y columnas con ganancias/costos tales que nunca se elija una fila $i$ y una columna $j$ cuya intersección tenga $a_{i,j} < 0$. Red bipartita Filas ($S$) vs Columnas ($T$) con corte mínimo. | $O((n+m)^3)$ |

---

## 11. Checklist de Examen para Ejercicios de Flujo

Antes de entregar un ejercicio de Flujo en el Segundo Parcial, verificá estos 7 puntos:

1. **¿Tu problema pide maximizar caminos/asignaciones o optimizar decisiones con dependencias/conflictos?**
   - Si reparte unidades conservadas (médicos, personas, caminos, grados): es **Flujo / Asignación**.
   - Si elige subconjuntos con ganancias/costos e implicaciones ("si elijo $A$ debo elegir/pagar $B$") o conflictos en un grafo bipartito: es **Corte Mínimo** con aristas $\infty$.
2. **¿Definiste explícitamente $V$, $E$, $s$, $t$ y $c(e)$?** No dibujes solo un ejemplo: escribí formalmente los conjuntos de vértices y las capacidades.
3. **¿Mencionaste el Teorema de Integralidad?** En la vuelta ($\Leftarrow$) de la prueba de correctitud, siempre escribí: *"Como todas las capacidades son enteras, por el Teorema de Integralidad existe un flujo máximo entero $f^*(e) \in \mathbb{Z}_{\ge 0}$..."*.
4. **Si el grafo original es no dirigido y modelás caminos disjuntos:** ¿Aclaraste que reemplazás cada arista $\{u, v\}$ por $(u, v)$ y $(v, u)$ de capacidad 1, y que si ambas tienen flujo 1 se pueden cancelar?
5. **Si hay restricción de capacidad en los vértices:** ¿Hiciste *Vertex Splitting* ($v_{\text{in}} \to v_{\text{out}}$)?
6. **Si usaste Corte Mínimo:** ¿Verificaste la dirección de las aristas de capacidad $\infty$? Recordá que $(u, v)$ con capacidad $\infty$ **prohíbe que $u \in S$ y $v \in T$** (es decir, fuerza $u \in S \implies v \in S$).
7. **¿Expresaste la complejidad final en función de los parámetros de la entrada original?** Calculá $|V|$ y $|E|$ de tu red y reemplazalos en $O(\min(|V||E|^2, \, |E||f^*|))$.
