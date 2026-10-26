# Macro SolidWorks — Geometría del estator (Ejercicio 4)

Genera la geometría paramétrica del estator trifásico (núcleo + ranuras + volúmenes
de bobina por fase) a partir de las condiciones iniciales fijadas en
[`README.md`](../README.md)
(secciones 1–3), y la exporta como `stator.step` para su importación en ANSYS Maxwell
3D mediante [`maxwell/setup_stator_magnetostatic.py`](../maxwell/setup_stator_magnetostatic.py).

## Archivo

- `stator_estator_macro.bas` — macro VBA de SolidWorks.

## Cómo ejecutarla

1. Abrir SolidWorks.
2. **Herramientas → Macro → Nueva** (o **Editar** si ya existe un archivo `.swp`),
   pegar el contenido de `stator_estator_macro.bas`.
3. **Herramientas → Macro → Ejecutar** (o F5), con `main` como punto de entrada.
4. El macro crea una nueva pieza, construye el anillo del núcleo, corta y patronea
   las 36 ranuras, crea los placeholders de volumen de bobina por fase, y exporta
   `stator.step` en el directorio de trabajo actual de SolidWorks.

## Firmas confirmadas (SolidWorks 2026, instalación en inglés)

Las siguientes llamadas fueron verificadas grabando macros de prueba reales con
**Tools → Macro → Record** en la instalación del usuario (SolidWorks 2026,
locale inglés) y ya NO están marcadas `[VERIFY]`:

- `FeatureExtrusion2` (no `FeatureExtrusion3`) para la extrusión del núcleo —
  23 argumentos posicionales, mismo orden que en el script.
- `FeatureCut4` (no `FeatureCut3`) para el corte de ranura — 27 argumentos
  posicionales (4 más que `FeatureCut3`, incluye `AssemblyFeatureScope`,
  `AutoSelectComponents`, `PropagateFeatureToParts`, `T0`, `StartOffset`,
  `FlipStartOffset` y un booleano adicional al final).
- Patrón circular: en esta versión **no** es `FeatureCircularPatternSG5` — el
  flujo correcto es seleccionar la feature semilla (`"BODYFEATURE"`) + el eje
  de referencia, construir una definición con
  `swFeatMgr.CreateDefinition(swFeatureNameID_e.swFmCirPattern)`, fijar sus
  propiedades (`TotalInstances`, `Spacing`, `EqualSpacing`, etc.) y crear la
  feature con `swFeatMgr.CreateFeature(swFeatData)`.
- Nombre del plano frontal: `"Front Plane"` (confirmado por el locale inglés,
  no `"Plano_Frontal"`).

## `[VERIFY]` restantes

- `swApp.GetUserPreferenceStringValue(swDefaultTemplatePart)` — no se verificó
  por grabación; revisar si tu plantilla de pieza por defecto realmente
  resuelve por esta vía o si prefieres pasar la ruta `.prtdot` directamente.
- Nombre del eje de referencia para el patrón circular (`"Axis1"` en el
  script): activa **View → Temporary Axes** para que el eje del cilindro del
  núcleo quede disponible con ese nombre; si SolidWorks lo nombra distinto en
  tu documento, ajusta la cadena en `SelectByID2`.
- `SaveAs3` para la exportación a STEP — firma típica estable entre
  versiones, pero no se verificó por grabación en esta sesión.

Si cualquiera de estas sigue fallando con error 449, repite el mismo proceso:
graba manualmente esa operación puntual con el macro recorder, exporta el
módulo como `.bas` (clic derecho en el módulo dentro del editor VBA → *Export
File...*), y usa esa firma real en lugar de la supuesta.

## Qué produce

- Núcleo anular: OD 120 mm, bore 75 mm, longitud axial 80 mm — todos `[TYPICAL]`,
  ver README §1.
- 36 ranuras trapezoidales semi-cerradas patroneadas circularmente (4 polos,
  3 ranuras/polo/fase). **Las dimensiones de la ranura (profundidad, ancho de
  diente, abertura) no están especificadas en el README fuente — son valores de
  partida razonables, `[VERIFY]` y ajustar contra el motor de referencia real
  antes de usarlos en el informe.**
- 3 volúmenes de bobina placeholder (fases A/B/C), nombrados `Bobina_Fase_A/B/C`,
  para que Maxwell pueda identificarlos al asignar la excitación de corriente.
  **Esto NO modela el bobinado distribuido real vuelta por vuelta** — es una
  simplificación deliberada (ver README §4: sin acoplamiento estructural/térmico
  en este alcance, y aquí tampoco se requiere geometría de cobre detallada para
  un análisis magnetostático de campo en el núcleo/entrehierro).

## Checklist relacionado (README §6)

- [ ] Reemplazar dimensiones `[TYPICAL]` (incluidas las de ranura, no solo las
      del README) por las del motor de referencia elegido, con fuente citada.
- [ ] Verificar que el patrón circular de ranuras no genere auto-intersección
      geométrica (errores de "self-intersecting feature" en SolidWorks) antes
      de exportar.
- [ ] Confirmar que el STEP exportado abre sin errores en ANSYS Maxwell antes
      de avanzar al script PyAEDT.

## Limitaciones

- La función `CrearVolumenBobinaUnico` es un esqueleto (`TODO` con `Debug.Print`):
  no construye la geometría real del volumen de bobina, solo documenta el
  nombre esperado. El usuario debe completarla con el sketch/extrude real de
  la bobina según el bobinado del motor elegido.
- Esta macro no modela el rotor, el eje, la carcasa, ni el entrehierro como
  volumen de aire explícito — eso se maneja en Maxwell vía *Open Region* /
  *Background* (ver README §4 y `maxwell/README.md`).
