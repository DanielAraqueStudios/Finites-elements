# Simulación Sísmica 3D — Casa Prefabricada (ANSYS Mechanical)

Ejercicio 1 del parcial. Simulación de la respuesta de una casa prefabricada ante un
sismo, en ANSYS Workbench / Mechanical 16.0.

> El enunciado pide una simulación "mecánica estática"; se resolvió como
> **Transient Structural** porque la excitación sísmica es una historia de
> aceleración en el tiempo. Los valores marcados `[TYPICAL]` son de referencia y
> deben citarse o reemplazarse antes del informe final.

## Archivos

| Archivo | Contenido |
|---|---|
| [`ansys/earthquake/ansys sim.wbpj`](../../ansys/earthquake/ansys%20sim.wbpj) | Proyecto Workbench 16.0 (resuelto y guardado) |
| [`ansys/earthquake/generate_accelerogram.py`](../../ansys/earthquake/generate_accelerogram.py) | Genera el acelerograma sintético |
| [`ansys/earthquake/synthetic_strong_motion_15s.csv`](../../ansys/earthquake/synthetic_strong_motion_15s.csv) | Acelerograma usado (101 filas, 0–15 s, Δt = 0.15 s) |
| `total_deformation.jpg`, `equivalent_stress.jpg`, `roof_deformation_probe.jpg` | Figuras de resultados (esta carpeta) |

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

`synthetic_strong_motion_15s.csv` es **sintético**, no un registro real. Su envolvente
imita El Centro 1940 (Imperial Valley, componente NS): subida en 0–2 s, fase fuerte en
2–10 s y decaimiento en 10–15 s. Es una suma de 15 senoides de 0.4–15 Hz con
semilla fija 42. **PGA = 3.43 m/s² (~0.35 g)** a t = 9.0 s. Para el informe se
recomienda reemplazarlo por un registro real (PEER NGA-West2 o la red acelerográfica
local) `[TYPICAL]`.

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

Figuras: [`total_deformation.jpg`](total_deformation.jpg),
[`equivalent_stress.jpg`](equivalent_stress.jpg),
[`roof_deformation_probe.jpg`](roof_deformation_probe.jpg).

## 5. Limitaciones

- La gravedad se aplica como escalón en t = 0. Por eso la historia del techo está
  dominada por un sobrepico de la carga gravitatoria que decae hacia ~3 s. La
  contribución sísmica es pequeña porque el modelo sólido es muy rígido.
- Mejora sugerida (no aplicada): rampa de gravedad en un primer paso de carga
  antes del sismo, o un análisis estático previo como condición inicial.
- Los archivos de resultados del solver (`file.rst`, ~526 MB) superan el límite de
  100 MB de GitHub: no deben subirse al repositorio.
