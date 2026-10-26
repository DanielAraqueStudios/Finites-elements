# Script PyAEDT — Simulación magnetostática del estator (Ejercicio 4)

Configura ANSYS Maxwell 3D para el análisis magnetostático del estator trifásico,
usando la geometría exportada por
[`cad/macros/stator_estator_macro.bas`](../cad/macros/stator_estator_macro.bas)
(`stator.step`) y las condiciones iniciales de
[`README.md`](../README.md)
(secciones 1–4 y 6).

## Archivo

- `setup_stator_magnetostatic.py` — script PyAEDT.

## Prerrequisitos

- ANSYS Electronics Desktop (AEDT) instalado localmente, con licencia **Maxwell 3D**
  (Electromagnetics Suite). `[VERIFY]` disponibilidad de licencia antes de correr.
- Python con `pyaedt` instalado (`pip install pyaedt`).
- `stator.step` ya generado por la macro SolidWorks (ver
  `cad/README.md`), ubicado en `cad/stator.step`.

## Cómo ejecutarlo

```bash
cd ejercicios/04-estator-magnetostatico/maxwell
python setup_stator_magnetostatic.py
```

El script:

1. Lanza AEDT y crea un proyecto Maxwell 3D, tipo de solución **Magnetostatic**.
2. Importa `stator.step`.
3. Asigna al núcleo el material de acero al silicio laminado con **curva B-H no
   lineal** (puntos `[TYPICAL]` en el script — reemplazar por datasheet real).
4. Crea las 3 excitaciones de fase (A/B/C) como corrientes instantáneas (snapshot
   en t=0) según las fórmulas de README §3.
5. Define la región de aire (*Open Region*, balloon ~100%).
6. Monta un barrido de malla de 3 niveles (grueso/medio/fino) con refinamiento
   hacia el entrehierro, dejando una tabla de convergencia placeholder.
7. Imprime el chequeo analítico de FMM = N·I y un recordatorio para completar la
   estimación de orden de magnitud de B vía circuito magnético equivalente.

**El análisis NO se ejecuta automáticamente** (`m3d.analyze_setup(...)` está
comentado) — descoméntelo solo después de verificar en la GUI de AEDT que la
geometría, el material y las excitaciones se importaron/asignaron correctamente.

## Salidas esperadas (tras ejecutar el análisis real)

- Mapa de densidad de flujo `|B|` en el núcleo y entrehierro.
- FMM por fase (ya impreso analíticamente, debe coincidir con el valor leído/
  derivado de la simulación).
- Tabla de convergencia de malla (3 niveles) — diferencia de `B_max` entre
  niveles consecutivos debería ser < 2–5% antes de confiar en el resultado.

## `[VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION]`

Prácticamente todas las llamadas a la API de `pyaedt` en este script
(`import_3d_cad`, `set_bh_curve`, `assign_current`, `create_region`,
`assign_length_mesh`, `create_setup`, nombres de propiedades como
`MaximumPasses`) están marcadas explícitamente porque su firma exacta puede
variar entre versiones de AEDT/pyaedt. Revisar contra la documentación de pyaedt
y AEDT de tu instalación antes de confiar en que el script corre sin ajustes.

## Limitaciones

- Sin acoplamiento térmico ni estructural (excluido por el enunciado, ver
  README §4 del documento fuente).
- Solver Magnetostatic: no captura pérdidas por corrientes inducidas (eddy
  currents) ni el campo rotante real del motor en operación — para eso se
  requeriría Transient/Eddy Current, `[VERIFY]` disponibilidad de licencia.
- Los puntos de la curva B-H y las dimensiones de ranura son `[TYPICAL]`:
  deben reemplazarse por los del motor de referencia real elegido, con fuente
  citada (datasheet o paper de máquinas eléctricas), antes de usar cualquier
  resultado en el informe final.
- El chequeo analítico de circuito magnético equivalente queda como `TODO`:
  requiere las longitudes/áreas del camino magnético real, no genéricas.
- La conexión en estrella (Y) se asigna como comentario de diseño; la
  implementación real de un grupo "Winding" conectado en Y depende de cómo
  pyaedt expone esa función en tu versión — revisar antes de ejecutar.
