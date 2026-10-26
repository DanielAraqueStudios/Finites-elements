# Ej. 3 — "Cuy" al horno, térmico estático (3D)

| | |
|---|---|
| **Enunciado** | Simulación térmica estática de un "cuy" (conejillo de indias) al horno, con dimensiones reales, en 3D |
| **Herramienta** | ANSYS Workbench / Mechanical 16.0 — *Steady-State Thermal* |
| **Estado** | ✅ Resuelto |
| **Sección del informe** | [`informe/`](../../informe/README.md) → Ej. 3 |

> Los valores marcados `[TYPICAL]` son de referencia de literatura de ingeniería de
> alimentos. Antes del informe final, cítalos o reemplázalos (p. ej. ASHRAE Handbook —
> Refrigeration, capítulo de propiedades térmicas de los alimentos).

## Estructura de la carpeta

```
03-cuy-horno/
├── README.md
├── ansys/
│   ├── cuy_thermal.wbpj      # proyecto Workbench 16.0 (resuelto)
│   ├── cuy_thermal_files/    # datos del proyecto (resultados del solver ignorados por git)
│   └── cuy.IGS               # geometría importada (SolidWorks 2026, mm)
├── cad/
│   └── fuente/               # modelo original GrabCAD "Скульптура / Sculpture" (SLDPRT, STEP, STL, imágenes)
└── figuras/                  # capturas para el informe
```

## 1. Geometría

| Parámetro | Valor |
|---|---|
| Geometría importada | 133.6 × 60.0 × 96.1 mm (V = 0.377 L, ~0.40 kg) |
| Escalado | ×1.3 en DesignModeler (*Body Transformation → Scale*, origen global) |
| Geometría final | **173.6 × 78.0 × 125.0 mm** |
| Volumen | 8.27 × 10⁻⁴ m³ |
| Área de piel | ≈ 0.0486 m² (19 caras) |
| Masa equivalente | ≈ 0.88 kg (ρ = 1060 kg/m³) |

El escalado lleva la masa de carne a un valor realista para un cuy beneficiado
(0.8–1.2 kg) `[TYPICAL]`.

## 2. Material — "Cuy meat"

| Propiedad | Valor | Nota |
|---|---|---|
| Conductividad térmica k | 0.48 W/m·K | `[TYPICAL]` carne magra, ASHRAE |
| Densidad ρ | 1060 kg/m³ | `[TYPICAL]`, no se requiere en estado estable |
| Calor específico c_p | ~3500 J/kg·K | `[TYPICAL]`, solo para un análisis transitorio |

## 3. Malla

Malla por defecto con *Relevance* = 100: ≈ 11 000 nodos / ≈ 6 000 tetraedros.

## 4. Condiciones de frontera

| Carga | Definición |
|---|---|
| Convección | Las 19 caras de piel, aire del horno a T∞ = 200 °C, h = 25 W/m²·K `[TYPICAL]` (horno de convección forzada) |
| Generación interna de calor | Todo el cuerpo, **q''' = −66 400 W/m³** (sumidero por evaporación de humedad) |

### Justificación del sumidero

Solo con convección, el estado estable da el cuerpo entero a 200 °C, sin gradiente.
En el horno, la evaporación del agua de la carne absorbe calor. Ese efecto se modela
como un sumidero volumétrico:

```
pérdida por cocción   = 15 % × 0.878 kg = 0.1317 kg   [TYPICAL, rango 15–35 %]
tiempo de horneado    = 1.5 h = 5400 s                [TYPICAL]
Q_evap = 0.1317 kg × 2.257e6 J/kg / 5400 s ≈ 55 W
q'''   = −55 W / 8.28e-4 m³ ≈ −6.64e4 W/m³
```

## 5. Resultados

| Resultado | Mínimo | Máximo |
|---|---|---|
| Temperatura | **87.9 °C** (núcleo) | **182.1 °C** (piel, zonas delgadas: hocico, borde del vientre) |
| Flujo de calor total | 145.9 W/m² (núcleo) | 1524.7 W/m² (extremidades delgadas) |

El núcleo supera la temperatura interna segura de cocción (71–74 °C) `[TYPICAL]`.

## 6. Figuras para el informe

| ID | Archivo | Contenido | Estado |
|---|---|---|---|
| fig:ej3-geometria | `figuras/geometria.png` | Geometría escalada (173.6 × 78.0 × 125.0 mm) | ⬜ pendiente |
| fig:ej3-malla | `figuras/malla.png` | Malla (≈ 11 000 nodos) | ⬜ pendiente |
| fig:ej3-cargas | `figuras/condiciones_frontera.png` | Convección en la piel + sumidero interno | ⬜ pendiente |
| fig:ej3-temp-sup | [`figuras/temperature_surface.png`](figuras/temperature_surface.png) | Temperatura en la superficie | ✅ |
| fig:ej3-temp-corte | [`figuras/temperature_section.png`](figuras/temperature_section.png) | Temperatura, corte longitudinal (núcleo frío) | ✅ |
| fig:ej3-flujo | [`figuras/total_heat_flux_section.png`](figuras/total_heat_flux_section.png) | Flujo de calor total, mismo corte | ✅ |

## 7. Limitaciones

- El asado real es **transitorio** (el núcleo se calienta en 1–2 h). Este modelo
  estable representa la fase cuasi-estacionaria de enfriamiento evaporativo.
- Un sumidero uniforme es una simplificación: la evaporación ocurre sobre todo cerca
  de la superficie.
- Extensión sugerida: *Transient Thermal* desde 4–20 °C para obtener la curva de
  temperatura del núcleo contra el tiempo.

## 8. Referencias

- `[VERIFY]` ASHRAE Handbook — Refrigeration, *Thermal Properties of Foods*.
- `[VERIFY]` Pérdida por cocción y temperatura interna segura (fuente pendiente).
