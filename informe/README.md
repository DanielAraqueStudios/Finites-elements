# Informe — LaTeX, formato IEEE

Informe final del parcial: resultados detallados de las 10 simulaciones, con figuras
claras y descritas, en **formato IEEE** (clase `IEEEtran`, modo `conference`), impreso.

> **Estado:** ⬜ estructura definida; el código LaTeX todavía no está escrito.

## Estructura prevista

```
informe/
├── README.md                 # este documento
├── main.tex                  # documento principal IEEEtran (por crear)
├── referencias.bib           # bibliografía BibTeX (por crear)
├── secciones/                # un archivo .tex por sección (por crear)
│   ├── 00-resumen.tex        #   Abstract + Index Terms
│   ├── 01-introduccion.tex   #   Objetivo, método de elementos finitos, herramientas
│   ├── ej01-sismo.tex        #   Ej. 1 — Casa prefabricada ante sismo
│   ├── ej02-viga-c.tex       #   Ej. 2 — Viga canal C
│   ├── ej03-cuy.tex          #   Ej. 3 — Cuy al horno
│   ├── ej04-estator.tex      #   Ej. 4 — Estator magnetostático
│   ├── ej05-apache.tex       #   Ej. 5 — Helicóptero Apache CFD
│   ├── ej06-boquilla.tex     #   Ej. 6 — Boquilla multifase
│   ├── ej07-nascar.tex       #   Ej. 7 — Choque NASCAR
│   ├── ej08-rcs.tex          #   Ej. 8 — RCS F-22 vs. Exocet
│   ├── ej09-hawt.tex         #   Ej. 9 — Aerogenerador HAWT
│   ├── ej10-ciclon.tex       #   Ej. 10 — Ciclón
│   └── 99-conclusiones.tex   #   Conclusiones generales
└── figuras/                  # sólo figuras comunes (logos, esquemas generales)
```

## Figuras

Las figuras de cada ejercicio **no se duplican** aquí: viven en
`ejercicios/<NN-nombre>/figuras/` y el informe las incluye por ruta relativa
(`\graphicspath` apuntando a `../ejercicios/*/figuras/`). Cada README de ejercicio
tiene una tabla **"Figuras para el informe"** con el ID de etiqueta LaTeX
(`fig:ejN-...`), el archivo esperado y su estado.

Convenciones para capturas:

- Formato PNG (JPG aceptable para capturas existentes), ventana completa de ANSYS a
  2560 × 1392 o recorte de la zona gráfica; leyenda de colores y unidades visibles.
- Nombre en minúsculas con guion bajo: `geometria.png`, `malla.png`,
  `condiciones_frontera.png`, y un nombre descriptivo para cada resultado.
- Toda figura del informe lleva título descriptivo y se cita en el texto.

## Contenido por ejercicio (plantilla de sección)

Cada sección `ejNN-*.tex` sigue el mismo orden que el README del ejercicio:

1. Planteamiento y objetivo
2. Modelo (geometría, dimensiones reales, supuestos)
3. Materiales y propiedades, **con referencias científicas**
4. Condiciones de frontera y cargas
5. Malla y configuración del análisis
6. Resultados (tabla de valores máximos/mínimos + figuras)
7. Discusión y limitaciones

## Estado de las secciones

| Sección | Fuente de datos | Figuras listas | Texto LaTeX |
|---|---|---|---|
| Ej. 1 — Sismo | [`ejercicios/01-sismo-casa-prefabricada`](../ejercicios/01-sismo-casa-prefabricada/README.md) | 3 / 7 | ⬜ |
| Ej. 2 — Viga C | [`ejercicios/02-viga-canal-c`](../ejercicios/02-viga-canal-c/README.md) | 0 / 5 | ⬜ |
| Ej. 3 — Cuy | [`ejercicios/03-cuy-horno`](../ejercicios/03-cuy-horno/README.md) | 3 / 6 | ⬜ |
| Ej. 4 — Estator | [`ejercicios/04-estator-magnetostatico`](../ejercicios/04-estator-magnetostatico/README.md) | 3 / 6 | ⬜ |
| Ej. 5 — Apache | [`ejercicios/05-helicoptero-apache-cfd`](../ejercicios/05-helicoptero-apache-cfd/README.md) | 0 / 6 | ⬜ |
| Ej. 6 — Boquilla | [`ejercicios/06-boquilla-fertilizante-multifase`](../ejercicios/06-boquilla-fertilizante-multifase/README.md) | 0 / 6 | ⬜ |
| Ej. 7 — NASCAR | [`ejercicios/07-choque-nascar`](../ejercicios/07-choque-nascar/README.md) | 0 / 6 | ⬜ |
| Ej. 8 — RCS | [`ejercicios/08-rcs-f22-vs-exocet`](../ejercicios/08-rcs-f22-vs-exocet/README.md) | 0 / 5 | ⬜ |
| Ej. 9 — HAWT | [`ejercicios/09-aerogenerador-hawt-cfd`](../ejercicios/09-aerogenerador-hawt-cfd/README.md) | 0 / 6 | ⬜ |
| Ej. 10 — Ciclón | [`ejercicios/10-ciclon-solidworks`](../ejercicios/10-ciclon-solidworks/README.md) | 0 / 6 | ⬜ |

## Compilación (cuando exista `main.tex`)

```bash
cd informe && latexmk -pdf main.tex
```

Requiere una distribución LaTeX (TeX Live o MiKTeX) con `IEEEtran`, `graphicx`,
`siunitx`, `booktabs` y `biblatex`/`bibtex`.
