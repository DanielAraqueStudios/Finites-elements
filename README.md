# Finites-elements

Repositorio de trabajo para el parcial de **Elementos Finitos** — simulaciones de
sistemas mecánicos, térmicos, electromagnéticos y de fluidos, principalmente en
ANSYS, con documentación de condiciones iniciales y resultados por ejercicio.

## Estructura

```
Finites-elements/
├── ansys/
│   ├── earthquake/                # Ej. 1 — proyecto Workbench + acelerograma sintético
│   ├── cuy/                       # Ej. 3 — proyecto Workbench + geometría IGES/CAD
│   └── maxwell/                   # Ej. 4 — script PyAEDT del estator
├── cad/
│   └── solidworks/                # Ej. 4 — macro de geometría del estator
└── docs/
    ├── earthquake/README.md       # Ej. 1 — modelo, cargas, resultados y figuras
    ├── cuy/README.md              # Ej. 3 — modelo, cargas, resultados y figuras
    └── estator-magnetostatico/
        └── README.md              # Ej. 4 — condiciones iniciales de la simulación magnetostática
```

Cada ejercicio vive en su propia carpeta dentro de `docs/` (o la carpeta que
corresponda al tipo de entregable), con:

- Un `README.md` con las condiciones iniciales (geometría, materiales, cargas,
  excitación) y sus fuentes.
- Los archivos de simulación asociados (scripts, datos exportados, geometría)
  cuando aplique.

## Enunciado del parcial

> Entregar un informe de simulación con resultados detallados, con figuras claras y
> descritas donde se aprecien variables de interés de las siguientes simulaciones,
> impreso y en formato IEEE.
>
> Encontrar valores típicos necesarios para la simulación: fuerzas, temperaturas,
> velocidades, etc. (referencias científicas).
>
> En grupos de máximo dos integrantes.

| # | Ejercicio | Herramienta | Estado |
|---|---|---|---|
| 1 | Simulación mecánica estática de casa prefabricada ante sismo en 3D | ANSYS | Resuelto (Transient Structural) — ver [`docs/earthquake/`](docs/earthquake/README.md) |
| 2 | Simulación de deformación y esfuerzos de perfil de Canal tipo "C" para viga de acero al aplicarle un peso de 50 Ton, 2D | MATLAB-PDEtool | *Excluido de este repo (MATLAB)* |
| 3 | Simulación térmica estática de un "cuy" (conejillo de indias) al horno, con dimensiones reales, en 3D | ANSYS | Resuelto (Steady-State Thermal) — ver [`docs/cuy/`](docs/cuy/README.md) |
| 4 | Simulación magnetostática de bobinas de estator trifásico de motor en 3D | ANSYS | En progreso — ver [`docs/estator-magnetostatico/`](docs/estator-magnetostatico/README.md) |
| 5 | Simulación CFD transiente en CFX de un helicóptero tipo Apache con dos dominios rotativos (rotor principal, rotor de cola) en 3D | ANSYS | — |
| 6 | Simulación CFD multifase de boquilla de aspersión de fertilizante líquido sobre planta de alcachofa | ANSYS | — |
| 7 | Simulación de colisión de auto NASCAR contra muro de contención en 3D | ANSYS | — |
| 8 | Simulación de RCS de aeronave F-22 vs. RCS de misil Exocet | MATLAB-PO/facets | *Excluido de este repo (MATLAB)* |
| 9 | Simulación CFD transiente de aerogenerador HAWT en 3D y obtención de curva de Torque vs. tiempo | ANSYS | — |
| 10 | Simulación de ciclón en 3D ([referencia en video](https://www.youtube.com/watch?v=mHbHtuBw)) | SolidWorks | — |

## Convenciones

- Unidades SI en todo el repositorio.
- Todo valor numérico sin fuente confirmada se marca `[TYPICAL]` (valor de
  referencia a reemplazar) o `[VERIFY]` (a confirmar contra la documentación de
  la versión de ANSYS usada).
- Los resultados de simulación se entregan en formato IEEE, con variables de
  interés claramente etiquetadas en las figuras.
- Los proyectos ANSYS se versionan en `ansys/<ejercicio>/` con versión Workbench 16.0.
  Los archivos de resultados del solver (`*.rst`, `*.rth`, carpetas `*_files/dp0/SYS/MECH`)
  pueden superar los 100 MB y no deben subirse a GitHub.
