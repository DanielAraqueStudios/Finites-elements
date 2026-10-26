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
├── ansys/
│   ├── ansys sim.wbpj                  # proyecto Workbench 16.0 (resuelto)
│   └── ansys sim_files/                # datos del proyecto (resultados del solver ignorados por git)
├── datos/
│   ├── synthetic_strong_motion_15s.csv # acelerograma usado (101 filas)
│   └── legado/                         # versión anterior de 39 filas (no usada)
├── scripts/
│   └── generate_accelerogram.py        # genera el acelerograma sintético
└── figuras/                            # capturas para el informe
```

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
