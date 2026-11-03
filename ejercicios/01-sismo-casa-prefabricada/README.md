# Ej. 1 — Casa prefabricada ante sismo (3D)

| | |
|---|---|
| **Enunciado** | Simulación mecánica estática de casa prefabricada ante sismo en 3D |
| **Herramienta** | ANSYS Workbench / Mechanical 16.0 — *Transient Structural* |
| **Estado** | ✅ Resuelto |
| **Sección del informe** | [`informe/`](../../informe/README.md) → Ej. 1 |

> El enunciado pide una simulación "mecánica estática"; se resolvió como
> **Transient Structural** porque la excitación sísmica es una historia de
> aceleración en el tiempo. Los valores marcados `[TYPICAL]` son de referencia y
> deben citarse o reemplazarse antes del informe final.

## Estructura de la carpeta

```
01-sismo-casa-prefabricada/
├── README.md
├── final cad to exportv2.IGS           # CAD casa + bloque base (modelo B)
├── ansys/
│   ├── ansys sim.wbpj                  # proyecto Workbench 16.0: sistema A (original) y B (sobre bloque)
│   └── ansys sim_files/                # datos del proyecto (resultados del solver ignorados por git)
├── datos/
│   ├── synthetic_strong_motion_15s.csv # acelerograma usado en A (101 filas)
│   ├── base_displacement_xz.csv        # desplazamiento X/Z de la base usado en B (302 filas)
│   └── legado/                         # versión anterior de 39 filas (no usada)
├── scripts/
│   ├── generate_accelerogram.py        # genera el acelerograma sintético
│   └── generate_base_displacement.py   # integra a desplazamiento X/Z para el modelo B
└── figuras/                            # capturas para el informe
```

El proyecto tiene dos sistemas: **A** (secciones 1–6, casa sola con aceleración
inercial) y **B "Sismo base XZ"** (sección 8, casa unida a un bloque de concreto que
recibe el movimiento del suelo en dos direcciones horizontales).

## 1. Modelo

| Parámetro | Valor |
|---|---|
| Tipo de análisis | Transient Structural (Mechanical 16.0) |
| Geometría | 2 sólidos con contactos *bonded* |
| Malla | 13 016 nodos / 5 907 elementos |
| Eje vertical | +Y |

## 2. Condiciones de frontera y cargas

| Carga | Definición |
|---|---|
| Fixed Support | Cara inferior completa (base de la casa) |
| Standard Earth Gravity | −Y, 9.8066 m/s² |
| Acceleration (sismo) | *Define By Components*: X = tabla del CSV, Y = Z = 0. Carga inercial sobre todos los cuerpos (*Base Excitation = No*) |

### Acelerograma

[`datos/synthetic_strong_motion_15s.csv`](datos/synthetic_strong_motion_15s.csv) es
**sintético**, no un registro real, generado por
[`scripts/generate_accelerogram.py`](scripts/generate_accelerogram.py). Su envolvente
imita El Centro 1940 (Imperial Valley, componente NS): subida en 0–2 s, fase fuerte en
2–10 s y decaimiento en 10–15 s. Es una suma de 15 senoides de 0.4–15 Hz con semilla
fija 42. **PGA = 3.43 m/s² (~0.35 g)** a t = 9.0 s. Para el informe se recomienda
reemplazarlo por un registro real (PEER NGA-West2 o la red acelerográfica local)
`[TYPICAL]`.

## 3. Configuración del análisis

| Parámetro | Valor |
|---|---|
| Número de pasos de carga | 1 |
| Tiempo final | 15 s |
| Auto Time Stepping | Off |
| Δt | 0.15 s (100 subpasos, coincide con el CSV) |

## 4. Resultados

| Resultado | En t = 15 s | Máximo en el tiempo |
|---|---|---|
| Deformación total | 1.1629 mm | **1.2478 mm** (t = 0.6 s) |
| Esfuerzo equivalente (von Mises) | 4.1608 MPa | **4.7848 MPa** |
| Sonda de deformación en el techo (Total) | — | máx. 1.2478 mm, mín. 1.0836 mm |

## 5. Figuras para el informe

Las figuras viven en [`figuras/`](figuras/) y el informe LaTeX las referencia
directamente (ver [`informe/README.md`](../../informe/README.md)).

| ID | Archivo | Contenido | Estado |
|---|---|---|---|
| fig:ej1-geometria | `figuras/geometria.png` | Geometría de la casa y ejes | ⬜ pendiente |
| fig:ej1-malla | `figuras/malla.png` | Malla (13 016 nodos) | ⬜ pendiente |
| fig:ej1-cargas | `figuras/condiciones_frontera.png` | Soporte fijo, gravedad, aceleración | ⬜ pendiente |
| fig:ej1-acelerograma | `figuras/acelerograma.png` | Aceleración vs. tiempo (CSV) | ⬜ pendiente |
| fig:ej1-deformacion | [`figuras/total_deformation.jpg`](figuras/total_deformation.jpg) | Deformación total | ✅ |
| fig:ej1-vonmises | [`figuras/equivalent_stress.jpg`](figuras/equivalent_stress.jpg) | Esfuerzo de von Mises | ✅ |
| fig:ej1-sonda | [`figuras/roof_deformation_probe.jpg`](figuras/roof_deformation_probe.jpg) | Sonda de deformación del techo vs. tiempo | ✅ |
| fig:ej1b-desplazamiento | [`figuras/desplazamiento_base.png`](figuras/desplazamiento_base.png) | B: desplazamiento impuesto Ux, Uz vs. tiempo | ✅ |
| fig:ej1b-deformacion | [`figuras/base_deformacion_total.png`](figuras/base_deformacion_total.png) | B: deformación total en t = 3.6 s | ✅ |
| fig:ej1b-vonmises | [`figuras/base_von_mises.png`](figuras/base_von_mises.png) | B: von Mises en t = 10.6 s (máximo) | ✅ |
| fig:ej1b-techo-x | [`figuras/base_techo_ux.png`](figuras/base_techo_ux.png) | B: desplazamiento X del techo vs. tiempo | ✅ |
| fig:ej1b-techo-z | [`figuras/base_techo_uz.png`](figuras/base_techo_uz.png) | B: desplazamiento Z del techo vs. tiempo | ✅ |
| fig:ej1b-reaccion | [`figuras/base_reaccion.png`](figuras/base_reaccion.png) | B: fuerza de reacción en la base vs. tiempo | ✅ |

## 6. Limitaciones

- La gravedad se aplica como escalón en t = 0. Por eso la historia del techo está
  dominada por un sobrepico de la carga gravitatoria que decae hacia ~3 s. La
  contribución sísmica es pequeña porque el modelo sólido es muy rígido.
- Mejora sugerida (no aplicada): rampa de gravedad en un primer paso de carga antes
  del sismo, o un análisis estático previo como condición inicial.
- Los archivos de resultados del solver (`file.rst`, ~526 MB) superan el límite de
  100 MB de GitHub y están excluidos por `.gitignore`; se regeneran con *Solve*.

## 7. Referencias

- `[VERIFY]` Registro El Centro 1940 — PEER NGA-West2 Ground Motion Database.
- `[VERIFY]` Propiedades del material de la casa prefabricada (fuente pendiente).

## 8. Modelo B — casa sobre bloque base, sismo en X y Z

La casa se apoya sobre un bloque de concreto. El sismo se aplica **solo al bloque**
como movimiento impuesto del suelo, y la casa se mueve porque está unida a él. Así
las fuerzas en la casa son inerciales, como en un sismo real.

### Modelo

| Parámetro | Valor |
|---|---|
| Sistema | B "Sismo base XZ" — Transient Structural (Mechanical 16.0) |
| Geometría | [`final cad to exportv2.IGS`](final%20cad%20to%20exportv2.IGS) (metros), importado en DesignModeler y cortado con *Slice* por el plano ZX en y = 0 |
| Bloque base | 9 × 3 × 5 m (y = −3…0), **Concrete** |
| Casa | 6 × 3 × 3 m (y = 0…3.01), paredes de 10 mm con puerta y ventana, **Structural Steel** |
| Cuerpos | 3: casa, pared de la puerta, bloque |
| Contactos | Casa–bloque **Bonded** (unida, no desliza); pared de puerta–casa Bonded; pared de puerta–bloque suprimido (cara de 10 mm sin elementos de contacto, la pared ya va unida a la casa) |
| Malla | 9 231 nodos / 4 144 elementos |
| Large Deflection | Off (modelo lineal) |

> Primero se probó contacto *Frictional* (μ = 0.6). Convergía muy lento (bisecciones
> desde t ≈ 3 s) y se detuvo; se cambió a Bonded según el planteamiento: casa fija al
> bloque.

### Cargas y pasos

| Paso | Tiempo | Definición |
|---|---|---|
| 1 | 0–1 s | Solo gravedad (−Y), *Time Integration Off* (asentamiento estático) |
| 2 | 1–16 s | Sismo: Δt = 0.05 s (300 subpasos), *Time Integration On* |
| Displacement | cara inferior del bloque | X y Z = tabla de [`datos/base_displacement_xz.csv`](datos/base_displacement_xz.csv), Y = 0 |

El desplazamiento se obtiene en
[`scripts/generate_base_displacement.py`](scripts/generate_base_displacement.py):
componente X = mismo acelerograma sintético del modelo A (semilla 42), componente Z =
registro independiente (semilla 7) escalado a 0.85·PGA. Se integra dos veces con
corrección de línea base (pasa-altos Butterworth 0.1 Hz de fase cero + rampas coseno
de 1 s), así la base empieza y termina en reposo.

| Componente | PGA | PGV | PGD |
|---|---|---|---|
| X | 4.21 m/s² | 0.761 m/s | 22.62 cm |
| Z | 3.36 m/s² | 0.621 m/s | 16.25 cm |

### Resultados (solución completa 0–16 s, 175 s de cómputo)

| Resultado | Valor |
|---|---|
| Deformación total máx. | **0.241 m** en t = 3.6 s; es el desplazamiento del suelo (0.2408 m), todo el modelo se traslada junto |
| Von Mises solo gravedad | 4.19 MPa |
| Von Mises máx. en el tiempo | **8.06 MPa** en t = 10.6 s (paredes de la casa) |
| Techo, desplazamiento X | +0.184 / −0.226 m (base: −0.2262 m) |
| Techo, desplazamiento Z | +0.156 / −0.162 m (base: −0.1624 m) |
| Reacción en la base, Y | 3.10 MN (peso del bloque + casa) |
| Reacción en la base, X / Z | máx. 2.77 MN / 2.30 MN (ver limitaciones) |

**Interpretación:** la casa de acero es muy rígida frente al contenido de frecuencias
del sismo (0.4–15 Hz). El techo sigue al bloque con diferencias por debajo del
milímetro, es decir, deriva de entrepiso despreciable. El sismo casi duplica el
esfuerzo respecto a la gravedad sola (8.06 vs. 4.19 MPa), muy por debajo del límite
elástico del acero (250 MPa).

### Limitaciones del modelo B

- La reacción horizontal es ruidosa (oscila paso a paso). La estimación m·a con la
  aceleración de la tabla (≈ 3.4 m/s² × 316 t ≈ 1.1 MN) es menor que el pico
  reportado. Es el efecto conocido de imponer desplazamientos en un integrador de
  Newmark sin amortiguamiento numérico. Mejora sugerida: *Numerical Damping* en
  Analysis Settings, o aplicar el sismo como aceleración de base.
- La deriva del techo se lee comparando picos. Para una curva de deriva habría que
  exportar las tablas de la sonda y restar el desplazamiento de la base.
- El registro es sintético `[TYPICAL]`; reemplazar por un registro real para el informe.

Materiales: *Structural Steel* y *Concrete* de la biblioteca General Materials de
ANSYS Engineering Data 16.0 `[VERIFY]` (citar la fuente de las propiedades en el informe).
