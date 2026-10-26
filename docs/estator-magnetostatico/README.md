# Simulación Magnetostática 3D — Bobinas de Estator Trifásico (ANSYS Maxwell)

Ejercicio 4 del parcial. Este documento fija las **condiciones iniciales** (geometría,
materiales, excitación) que se usan tanto para la simulación real en ANSYS Maxwell
como para la vista previa ilustrativa en HTML (`preview/`), de modo que ambas partan
de los mismos números.

> Todos los valores marcados `[TYPICAL]` son valores de referencia tomados de literatura
> estándar de máquinas eléctricas para un motor de inducción trifásico pequeño
> (fraccionario, ~1.5 kW, 4 polos), NO de un datasheet específico. Antes de usarlos en el
> informe final, reemplázalos por los del motor de referencia que elijas y cita la fuente
> (datasheet del fabricante o el paper/texto de máquinas eléctricas que uses).
> Marcado `[VERIFY]` = confirmar contra la documentación de tu versión de ANSYS.

## 1. Geometría del estator

| Parámetro | Valor | Nota |
|---|---|---|
| Diámetro exterior del estator | 120 mm | `[TYPICAL]` |
| Diámetro interior (bore) | 75 mm | `[TYPICAL]` |
| Entrehierro (air gap) | 0.5 mm | `[TYPICAL]` |
| Longitud axial (stack length) | 80 mm | `[TYPICAL]` |
| Número de ranuras | 36 | `[TYPICAL]`, común para motor 4 polos, 3 fases, 3 ranuras/polo/fase |
| Tipo de ranura | Semi-cerrada, trapezoidal | `[TYPICAL]` |
| Número de polos | 4 | `[TYPICAL]` |

## 2. Material del núcleo

| Parámetro | Valor | Fuente |
|---|---|---|
| Material | Acero al silicio laminado (tipo M19/M270, 29 ga) | `[TYPICAL]` — reemplazar por curva B-H real del fabricante |
| Permeabilidad relativa inicial | ~4000–8000 (no lineal) | `[TYPICAL]` |
| B de saturación | 1.6–1.8 T | `[TYPICAL]` |
| Factor de apilado (stacking factor) | 0.95 | `[TYPICAL]` |

En ANSYS Maxwell, este material se asigna con su **curva B-H no lineal completa**
(no la aproximación lineal), vía *Edit Material → BH Curve*. `[VERIFY]` nombre exacto
del menú según versión.

## 3. Devanado trifásico (excitación)

| Parámetro | Valor | Nota |
|---|---|---|
| Número de fases | 3 (A, B, C) | — |
| Desfase eléctrico entre fases | 120° | — |
| Vueltas por bobina (N) | 50 | `[TYPICAL]` |
| Corriente de fase (pico), I | 5 A | `[TYPICAL]`, corriente nominal de un motor fraccionario |
| Frecuencia eléctrica | 60 Hz | `[TYPICAL]`, ajustar a 50 Hz si aplica |
| Conexión | Estrella (Y) | `[TYPICAL]` |
| FMM por bobina (N·I) | 250 A·turn | Calculado: N × I |
| Material del conductor | Cobre | — |

Corrientes instantáneas (si se usa *Transient*/snapshot para *Magnetostatic*):

```
I_A(t) = I_pk · cos(ωt)
I_B(t) = I_pk · cos(ωt − 120°)
I_C(t) = I_pk · cos(ωt + 120°)
```

## 4. Tipo de análisis

- Solver: **Magnetostatic** (snapshot a un instante de tiempo fijo) o **Eddy
  Current/Transient** si se requiere ver el campo rotante — `[VERIFY]` disponibilidad
  según licencia AEDT/Maxwell.
- Región de aire (Background): *Open Region*, balloon ~100% alrededor del modelo.
- Sin acoplamiento térmico/estructural en este alcance (excluido por el enunciado).

## 5. Qué representa la vista previa HTML

El archivo en `preview/` **no es una simulación FEA real** — es una aproximación
analítica 2D (superposición de campos tipo Biot-Savart de conductores filamentales
ubicados en los centros de ranura, más visualización de malla ilustrativa) para dar
una idea visual del resultado esperado (mapa de |B|, líneas de campo, FMM por fase)
**antes** de correr el modelo real en ANSYS Maxwell. Los valores numéricos mostrados
son solo ilustrativos y no deben citarse como resultado de simulación en el informe.

## 6. Checklist antes de correr en ANSYS real

- [ ] Reemplazar dimensiones `[TYPICAL]` por las del motor de referencia elegido
- [ ] Cargar curva B-H real del fabricante del acero
- [ ] Verificar FMM y corriente contra datasheet/paper citado
- [ ] Definir malla con refinamiento en entrehierro y dientes
- [ ] Correr estudio de convergencia de malla (mínimo 2–3 niveles)
- [ ] Verificación analítica de FMM = N·I y orden de magnitud de B vía circuito magnético equivalente

## 7. Plan de ejecución — CAD → ANSYS

Flujo de trabajo para este ejercicio, coordinado mediante subagentes (ruflo /
`claude-flow` MCP, ahora conectado; coordinación vía `SendMessage` entre agentes
nombrados, según la convención *Agent Comms* del `CLAUDE.md` del repo):

1. **`cad-solidworks`** — genera un macro VBA paramétrico de SolidWorks que
   construye la geometría del estator (núcleo + patrón de ranuras + volúmenes de
   bobina por fase) usando los parámetros de las secciones 1–3 de este documento,
   y exporta `stator.step`.
   - Entregables: `cad/solidworks/stator_estator_macro.swp|.bas` +
     `cad/solidworks/README.md`.
2. **`ansys-maxwell`** — espera la señal de `cad-solidworks`, luego escribe el
   script de configuración de ANSYS Maxwell 3D (PyAEDT) que importa `stator.step`,
   asigna el material no lineal del núcleo, crea los devanados trifásicos y la
   excitación (N, I, frecuencia de la sección 3), y configura el análisis
   magnetostático.
   - Entregables: `ansys/maxwell/setup_stator_magnetostatic.py` +
     `ansys/maxwell/README.md`.

**Importante:** ambos entregables son scripts/macros para correr localmente — este
entorno no puede operar las GUI de SolidWorks ni de ANSYS, por lo que nada se
ejecuta automáticamente. Las dimensiones y parámetros usados deben ser siempre los
de las secciones 1–3 de este documento (fuente única de verdad); no se vuelven a
derivar en cada subagente.

## 8. Simulación realizada — ANSYS Workbench 16.0 *Magnetostatic*

ANSYS Maxwell (AEDT) **no está instalado** en el equipo; el ejercicio se resolvió con
el sistema **Magnetostatic** de Workbench 16.0 (Mechanical/Emag, elementos
SOLID117). El script PyAEDT de `ansys/maxwell/` queda como alternativa si se dispone
de Maxwell.

### Archivos

| Archivo | Contenido |
|---|---|
| [`cad/solidworks/stator_magnetostatico.SLDPRT`](../../cad/solidworks/stator_magnetostatico.SLDPRT) | Pieza SolidWorks 2026 (núcleo + 36 barras, multicuerpo) |
| [`ansys/estator/stator.IGS`](../../ansys/estator/stator.IGS) | Exportación IGES (37 sólidos B-rep, entidad 186, mm) |
| [`ansys/estator/estator_magnetostatico.wbpj`](../../ansys/estator/estator_magnetostatico.wbpj) | Proyecto Workbench (resuelto y guardado) |
| [`ansys/estator/excitacion_trifasica.mac`](../../ansys/estator/excitacion_trifasica.mac) | Comandos APDL: corrientes trifásicas + frontera |
| `flux_density_B.png`, `flux_density_B_3d.png`, `field_intensity_H.png` | Figuras de resultados (esta carpeta) |

### Geometría

- Núcleo: anillo Ø 120 / Ø 75 mm, longitud 80 mm, 36 ranuras **abiertas** rectangulares
  4 × 12 mm (de r = 37.5 a 49.5 mm) `[TYPICAL]`.
- Bobinas: 36 barras de cobre 3 × 10 mm (r = 38.5–48.5 mm) a lo largo de los 80 mm;
  holgura de aire de 0.5 mm. **Sin cabezas de bobina** (aproximación 2D extruida).
- Construida por API de SolidWorks: anillo extruido, ranura semilla + patrón
  circular ×36, barra semilla (cuerpo separado) + patrón de cuerpos ×36.
- DesignModeler: caja de aire 180 × 180 × 80 mm (*Add Frozen*), Boolean *Subtract*
  conservando las herramientas, *Form New Part* → 1 parte, 39 cuerpos con topología
  compartida (núcleo, 36 barras, aire exterior, aire del bore + ranuras).

### Materiales

| Cuerpo | Material | μr |
|---|---|---|
| Núcleo | AceroM19 (lineal) | 5000 `[TYPICAL]` — reemplazar por curva B-H real |
| 36 barras | Cobre | 1 |
| Aire (2 cuerpos) | Air | 1 |

### Malla

Barrido (*Sweep*) en Z con 4 divisiones en todos los cuerpos (la malla tetraédrica
automática no convergió por las holguras de 0.5 mm): **152 289 nodos / 31 944
elementos**.

### Excitación (instante t = 0)

Devanado de una capa, paso completo, q = 3; secuencia cada 18 ranuras
`A A A −C −C −C B B B −A −A −A C C C −B −B −B`. Con I_pk = 5 A y N = 50:
I_A = +5 A, I_B = I_C = −2.5 A → N·I = ±250 A·vuelta (fase A) y ±125 A·vuelta
(fases B y C). Se aplica como densidad de corriente de fuente JS en Z sobre los
elementos de cada barra (componente `BOBINAS`):
JS = N·I / A_barra = 250 / 3×10⁻⁵ = **8.33 MA/m²** (A) y 4.17 MA/m² (B, C).

### Condiciones de frontera

*Magnetic Flux Parallel* (AZ = 0) en las 6 caras de la caja de aire, aplicado con
APDL (el objeto de Mechanical en 2 caras sólo satisface el requisito de "al menos una
carga"). En las caras extremas z = 0 y z = 80 mm equivale a un modelo 2D infinito.

### Resultados

| Resultado | Mínimo | Máximo |
|---|---|---|
| Densidad de flujo total \|B\| | 1.4 × 10⁻⁷ T | **0.213 T** (dientes junto a las ranuras de fase A) |
| Intensidad de campo total \|H\| | 0.12 A/m | **72 336 A/m** (aire/cobre de las ranuras) |

Se observa la distribución de **4 polos** esperada (2 pares de polos, ejes de las
fases desfasados 120° eléctricos = 60° mecánicos).

Verificación de orden de magnitud: sin rotor, el flujo cierra por el aire del bore
(diámetro 75 mm). Con N·I_polo ≈ 3 × 250 + 3 × 125 ≈ 1125 A·vuelta y un recorrido en
aire del orden de 2 × 37.5 mm: B ≈ μ0·N·I / g ≈ 4π×10⁻⁷ · 1125 / 0.075 ≈ 0.019 T en
el bore; la concentración en los dientes (μr = 5000) eleva el pico a ~0.2 T. Ambos
coinciden en orden de magnitud con la simulación.

Figuras: [`flux_density_B.png`](flux_density_B.png) (vista frontal),
[`flux_density_B_3d.png`](flux_density_B_3d.png) (isométrica, núcleo + barras),
[`field_intensity_H.png`](field_intensity_H.png).

### Limitaciones

- **Sin rotor**: el entrehierro real (0.5 mm) no se modela; con rotor de acero B en el
  entrehierro y los dientes sería del orden de 0.7–1.5 T.
- Núcleo lineal (sin saturación); cabezas de bobina omitidas.
- Malla sin estudio de convergencia (checklist §6 pendiente).
