# Elementos Finitos — Parcial de simulación

Simulaciones por el método de elementos finitos de sistemas **mecánicos, térmicos,
electromagnéticos y de fluidos**, principalmente en ANSYS Workbench 16.0, con la
documentación de modelo, condiciones de frontera, resultados y figuras de cada
ejercicio, y la estructura del informe final en LaTeX (formato IEEE).

![Ejercicios resueltos](https://img.shields.io/badge/ejercicios_resueltos-3%2F10-blue)
![ANSYS](https://img.shields.io/badge/ANSYS_Workbench-16.0-yellow)
![SolidWorks](https://img.shields.io/badge/SolidWorks-2026-red)
![Informe](https://img.shields.io/badge/informe-IEEE_LaTeX-lightgrey)

## Contenido

- [Enunciado](#enunciado)
- [Ejercicios](#ejercicios)
- [Resultados destacados](#resultados-destacados)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Informe LaTeX](#informe-latex)
- [Cómo abrir los proyectos](#cómo-abrir-los-proyectos)
- [Convenciones](#convenciones)

## Enunciado

> Entregar un informe de simulación con resultados detallados, con figuras claras y
> descritas donde se aprecien variables de interés de las siguientes simulaciones,
> impreso y en formato IEEE.
>
> Encontrar valores típicos necesarios para la simulación: fuerzas, temperaturas,
> velocidades, etc. (referencias científicas).
>
> En grupos de máximo dos integrantes.

## Ejercicios

| # | Ejercicio | Herramienta | Tipo de análisis | Estado |
|---|---|---|---|---|
| 1 | [Casa prefabricada ante sismo (3D)](ejercicios/01-sismo-casa-prefabricada/README.md) | ANSYS | Transient Structural | ✅ Resuelto |
| 2 | [Viga de acero con perfil canal "C" bajo 50 t (2D)](ejercicios/02-viga-canal-c/README.md) | MATLAB PDE Toolbox | Estático lineal 2D | ⬜ Pendiente (código fuera del repo) |
| 3 | ["Cuy" al horno con dimensiones reales (3D)](ejercicios/03-cuy-horno/README.md) | ANSYS | Steady-State Thermal | ✅ Resuelto |
| 4 | [Bobinas de estator trifásico (3D)](ejercicios/04-estator-magnetostatico/README.md) | ANSYS + SolidWorks | Magnetostatic | ✅ Resuelto |
| 5 | [Helicóptero Apache, dos dominios rotativos (3D)](ejercicios/05-helicoptero-apache-cfd/README.md) | ANSYS CFX | CFD transitorio | ⬜ Pendiente |
| 6 | [Boquilla de fertilizante sobre alcachofa](ejercicios/06-boquilla-fertilizante-multifase/README.md) | ANSYS | CFD multifase | ⬜ Pendiente |
| 7 | [Choque de auto NASCAR contra muro (3D)](ejercicios/07-choque-nascar/README.md) | ANSYS | Dinámica explícita | ⬜ Pendiente |
| 8 | [RCS de F-22 vs. misil Exocet](ejercicios/08-rcs-f22-vs-exocet/README.md) | MATLAB (PO / facetas) | Electromagnetismo de alta frecuencia | ⬜ Pendiente (código fuera del repo) |
| 9 | [Aerogenerador HAWT, curva de torque (3D)](ejercicios/09-aerogenerador-hawt-cfd/README.md) | ANSYS | CFD transitorio | ⬜ Pendiente |
| 10 | [Ciclón (3D)](ejercicios/10-ciclon-solidworks/README.md) ([referencia en video](https://www.youtube.com/watch?v=mHbHtuBw)) | SolidWorks | Flow Simulation | ⬜ Pendiente |

## Resultados destacados

| Ej. | Variable | Resultado | Figura |
|---|---|---|---|
| 1 | Deformación total máx. / von Mises máx. | 1.248 mm / 4.785 MPa | [deformación](ejercicios/01-sismo-casa-prefabricada/figuras/total_deformation.jpg) |
| 3 | Temperatura núcleo / piel | 87.9 °C / 182.1 °C | [corte de temperatura](ejercicios/03-cuy-horno/figuras/temperature_section.png) |
| 4 | \|B\| máx. / \|H\| máx. | 0.213 T / 72 336 A/m | [densidad de flujo](ejercicios/04-estator-magnetostatico/figuras/flux_density_B.png) |

## Estructura del repositorio

```
Finites-elements/
├── README.md
├── ejercicios/                          # un ejercicio por carpeta, misma estructura en todos
│   ├── 01-sismo-casa-prefabricada/
│   │   ├── README.md                    # modelo, cargas, resultados, figuras, referencias
│   │   ├── ansys/                       # proyecto Workbench (.wbpj + _files)
│   │   ├── datos/                       # acelerograma CSV
│   │   ├── scripts/                     # generador del acelerograma
│   │   └── figuras/                     # capturas para el informe
│   ├── 02-viga-canal-c/
│   ├── 03-cuy-horno/
│   │   ├── ansys/                       # proyecto Workbench + cuy.IGS
│   │   ├── cad/fuente/                  # modelo CAD original
│   │   └── figuras/
│   ├── 04-estator-magnetostatico/
│   │   ├── ansys/                       # proyecto Workbench + stator.IGS + macro APDL
│   │   ├── cad/                         # pieza SolidWorks, macros, scripts, referencias
│   │   ├── maxwell/                     # script PyAEDT alternativo (requiere Maxwell)
│   │   ├── preview/                     # vista previa analítica en HTML
│   │   └── figuras/
│   ├── 05-helicoptero-apache-cfd/
│   ├── 06-boquilla-fertilizante-multifase/
│   ├── 07-choque-nascar/
│   ├── 08-rcs-f22-vs-exocet/
│   ├── 09-aerogenerador-hawt-cfd/
│   └── 10-ciclon-solidworks/
└── informe/                             # informe final LaTeX (IEEEtran)
    ├── README.md                        # estructura prevista y estado de figuras
    └── figuras/                         # sólo figuras comunes
```

Cada `ejercicios/NN-*/README.md` sigue la misma plantilla: enunciado y herramienta,
estructura de la carpeta, modelo, materiales, condiciones de frontera, malla,
resultados, **tabla de figuras para el informe** (con estado ✅ / ⬜), limitaciones y
referencias.

## Informe LaTeX

El informe final se escribe en [`informe/`](informe/README.md) con la clase
`IEEEtran`. Las figuras no se copian: cada sección del informe las incluye desde
`ejercicios/NN-*/figuras/`, de modo que una captura nueva queda disponible en el
informe sin pasos extra. El estado de las figuras por ejercicio se lleva en
[`informe/README.md`](informe/README.md#estado-de-las-secciones).

## Cómo abrir los proyectos

1. Abrir ANSYS Workbench 16.0 y usar **File → Open** sobre el `.wbpj` de la carpeta
   `ansys/` del ejercicio. El `.wbpj` y su carpeta `_files` deben moverse siempre
   juntos.
2. Los resultados del solver no se versionan (ver `.gitignore`): tras abrir el
   proyecto, ejecutar **Solve** en Mechanical para regenerarlos.
3. Si Workbench no encuentra la geometría de origen (rutas absolutas guardadas en el
   proyecto), reasignarla con **Geometry → Replace Geometry → Browse** apuntando al
   `.IGS` de la misma carpeta `ansys/`.

## Convenciones

- **Unidades SI** en todo el repositorio.
- Todo valor numérico sin fuente confirmada se marca `[TYPICAL]` (valor de referencia
  a reemplazar) o `[VERIFY]` (a confirmar contra la documentación o la literatura).
- Figuras en `figuras/`, nombres en minúsculas con guion bajo; etiqueta LaTeX
  `fig:ejN-<nombre>`.
- Los archivos de resultados del solver (`*.rst`, `*.rth`, `*.rmg`, carpetas
  `*_files/dp0/SYS/MECH`) superan los 100 MB y están excluidos por `.gitignore`.
