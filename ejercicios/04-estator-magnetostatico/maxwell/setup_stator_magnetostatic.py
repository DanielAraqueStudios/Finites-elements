"""
setup_stator_magnetostatic.py

Script PyAEDT para configurar la simulacion magnetostatica 3D del estator
trifasico (Ejercicio 4, parcial de Elementos Finitos) en ANSYS Maxwell 3D.

Fuente unica de verdad de los parametros: docs/estator-magnetostatico/README.md
(secciones 1-3). Este script importa stator.step (generado por
cad/solidworks/stator_estator_macro.bas), asigna el material no lineal del
nucleo, crea la excitacion trifasica, configura la region de aire y el
analisis, y deja un esqueleto de barrido de convergencia de malla + chequeo
analitico de FMM.

Requisitos de licencia/modulo: ANSYS Electronics Desktop (AEDT) con licencia
Maxwell 3D (Electromagnetics Suite). [VERIFY] disponibilidad de "Eddy
Current"/"Transient" segun tu licencia si en el futuro se requiere ver el
campo rotante (fuera de alcance aqui, ver README seccion 4).

Nada en este script se ejecuta automaticamente en el entorno de generacion:
requiere una instalacion local de AEDT + pyaedt para correr.

[VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION] en todas las llamadas marcadas:
nombres exactos de metodos pyaedt pueden variar entre versiones de AEDT/pyaedt.
"""

import os

from pyaedt import Maxwell3d  # [VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION]

# ---------------------------------------------------------------------------
# 1. Parametros — copiados literalmente de docs/estator-magnetostatico/README.md
#    (secciones 1-3). NO se re-derivan aqui; este script es un consumidor,
#    no la fuente de verdad.
# ---------------------------------------------------------------------------

# Geometria (README sec. 1) — [TYPICAL], ya materializada en stator.step
OD_ESTATOR_MM = 120.0
ID_BORE_MM = 75.0
ENTREHIERRO_MM = 0.5
LONGITUD_AXIAL_MM = 80.0
NUM_RANURAS = 36
NUM_POLOS = 4

# Material del nucleo (README sec. 2) — [TYPICAL]
# Curva B-H real DEBE reemplazar estos puntos antes de usar resultados en el informe.
# Puntos (H [A/m], B [T]) ilustrativos de literatura estandar para acero M19/M270 29ga,
# NO un datasheet real. [VERIFY] contra el fabricante del acero elegido.
BH_CURVE_TYPICAL = [
    (0.0, 0.0),
    (50.0, 0.5),
    (100.0, 1.0),
    (200.0, 1.3),
    (500.0, 1.5),
    (1000.0, 1.6),
    (5000.0, 1.7),
    (20000.0, 1.8),  # region de saturacion [TYPICAL]
]
STACKING_FACTOR = 0.95

# Devanado trifasico / excitacion (README sec. 3) — [TYPICAL]
NUM_FASES = 3
VUELTAS_POR_BOBINA_N = 50
CORRIENTE_PICO_A = 5.0
FRECUENCIA_HZ = 60.0
CONEXION = "Y"  # estrella
FASES_NOMBRES = ["A", "B", "C"]
DESFASE_ELECTRICO_GRADOS = [0.0, -120.0, 120.0]  # I_A, I_B, I_C respectivamente

# FMM por bobina, calculado (README sec. 3) — no es un valor independiente,
# se deriva de N e I; se recalcula aqui para el chequeo analitico, no se
# "inventa" un numero distinto.
FMM_POR_BOBINA_A_TURN = VUELTAS_POR_BOBINA_N * CORRIENTE_PICO_A

# Instante de tiempo para el snapshot Magnetostatic (t=0 por defecto: fase A
# en su pico). Ajustar si se desea otro instante del ciclo.
INSTANTE_SNAPSHOT_S = 0.0

STEP_FILE_PATH = os.path.join(os.path.dirname(__file__), "..", "..", "cad", "solidworks", "stator.step")


def corriente_instantanea(i_pico, frecuencia_hz, t_s, desfase_grados):
    """I(t) = I_pk * cos(w*t - desfase), segun formulas de README sec. 3."""
    import math

    omega = 2 * math.pi * frecuencia_hz
    desfase_rad = math.radians(desfase_grados)
    return i_pico * math.cos(omega * t_s - desfase_rad)


def main():
    # -----------------------------------------------------------------
    # 2. Lanzar AEDT y crear/abrir el proyecto Maxwell 3D
    # -----------------------------------------------------------------
    # [VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION]: firma de Maxwell3d() y
    # parametros de version/non_graphical segun tu instalacion de AEDT.
    m3d = Maxwell3d(
        projectname="stator_magnetostatico",
        designname="Estator_Magnetostatic",
        solution_type="Magnetostatic",
        specified_version=None,  # usa la version por defecto detectada; [VERIFY] fijar version explicita si hay varias instaladas
        non_graphical=False,
        new_desktop_session=True,
    )

    # Justificacion del tipo de solver (README sec. 4):
    # Se usa Magnetostatic (snapshot a t fijo) porque el alcance del
    # ejercicio es el mapa de campo |B| y FMM por fase en un instante dado,
    # sin perdidas por corrientes inducidas ni rotacion del rotor. Si se
    # requiriera ver el campo rotante o perdidas por eddy currents, el
    # solver correcto seria Transient/Eddy Current — [VERIFY] disponibilidad
    # segun licencia AEDT/Maxwell antes de cambiar el tipo de solucion.

    # -----------------------------------------------------------------
    # 3. Importar geometria desde STEP (generado por la macro SolidWorks)
    # -----------------------------------------------------------------
    if not os.path.exists(STEP_FILE_PATH):
        raise FileNotFoundError(
            f"No se encontro {STEP_FILE_PATH}. Ejecute primero "
            "cad/solidworks/stator_estator_macro.bas en SolidWorks."
        )

    m3d.modeler.import_3d_cad(STEP_FILE_PATH)  # [VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION]

    # -----------------------------------------------------------------
    # 4. Material del nucleo: curva B-H no lineal (NO aproximacion lineal)
    # -----------------------------------------------------------------
    # README sec. 2: la no linealidad de saturacion es relevante para el
    # calculo de |B| cerca de dientes/entrehierro; una permeabilidad lineal
    # subestimaria/sobreestimaria el campo en la region de saturacion.
    core_material = m3d.materials.add_material("acero_silicio_laminado_typical")
    core_material.permeability = "nonlinear"  # [VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION] propiedad exacta en pyaedt
    core_material.set_bh_curve(BH_CURVE_TYPICAL)  # [VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION] metodo exacto (Edit Material -> BH Curve en GUI)
    core_material.stacking_factor = STACKING_FACTOR  # [VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION]

    nucleo_obj_name = "Nucleo_Estator"  # debe coincidir con el nombre del solido importado desde STEP; [VERIFY] nombre real tras importar
    m3d.assign_material(nucleo_obj_name, core_material.name)

    # -----------------------------------------------------------------
    # 5. Excitacion trifasica (README sec. 3)
    # -----------------------------------------------------------------
    for fase_idx, fase_nombre in enumerate(FASES_NOMBRES):
        objeto_bobina = f"Bobina_Fase_{fase_nombre}"  # debe coincidir con el nombre asignado en la macro SolidWorks
        corriente_snapshot_a = corriente_instantanea(
            CORRIENTE_PICO_A, FRECUENCIA_HZ, INSTANTE_SNAPSHOT_S, DESFASE_ELECTRICO_GRADOS[fase_idx]
        )

        # Coil Terminal / Winding excitation. [VERIFY AGAINST ANSYS DOCS FOR YOUR
        # VERSION]: metodo exacto en pyaedt (assign_coil, assign_winding, etc.)
        # y si se requiere definir primero un "Winding" grupo (conexion Y)
        # antes de asignar las corrientes de fase individuales.
        m3d.assign_current(
            objeto_bobina,
            amplitude=corriente_snapshot_a,
            name=f"Corriente_Fase_{fase_nombre}",
        )

    # Conexion estrella (Y): registrar como comentario de diseno; la
    # implementacion real de la conexion Y (nodo comun, retorno de corriente)
    # depende de como pyaedt exponga "Winding" en Maxwell3d — [VERIFY
    # AGAINST ANSYS DOCS FOR YOUR VERSION].

    # -----------------------------------------------------------------
    # 6. Region de aire / background (README sec. 4)
    # -----------------------------------------------------------------
    m3d.modeler.create_region(pad_percent=100)  # Open Region, balloon ~100% alrededor del modelo [VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION]
    m3d.assign_material("Region", "vacuum")  # [VERIFY] nombre exacto del objeto Region generado

    # -----------------------------------------------------------------
    # 7. Malla: refinamiento en entrehierro y dientes + barrido de
    #    convergencia (2-3 niveles), per README sec. 6 checklist.
    # -----------------------------------------------------------------
    niveles_malla = ["grueso", "medio", "fino"]
    longitudes_elemento_mm = [5.0, 2.0, 0.8]  # decreciente -> refina hacia el entrehierro; [VERIFY] valores iniciales razonables, ajustar segun resultados

    resultados_convergencia = []

    for nivel, longitud_mm in zip(niveles_malla, longitudes_elemento_mm):
        # Refinamiento local en region de entrehierro/dientes (gradiente alto de B)
        m3d.mesh.assign_length_mesh(
            ["Region_Entrehierro"],  # [VERIFY] nombre real del objeto de entrehierro si se modela explicitamente
            maxlength=longitud_mm,
            name=f"malla_entrehierro_{nivel}",
        )  # [VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION]

        setup = m3d.create_setup(f"Setup_Magnetostatic_{nivel}")  # [VERIFY AGAINST ANSYS DOCS FOR YOUR VERSION]
        setup.props["MaximumPasses"] = 10  # [VERIFY] nombre de propiedad exacto
        setup.update()

        # m3d.analyze_setup(setup.name)  # Descomentar para correr realmente; no se ejecuta aqui.

        # Placeholder: tras correr, extraer |B| maximo en el entrehierro via
        # post-procesamiento (m3d.post...) y anexar a resultados_convergencia
        # para armar la tabla de convergencia. [TODO] completar con la
        # extraccion real de resultados una vez corrido el analisis.
        resultados_convergencia.append(
            {"nivel": nivel, "longitud_elemento_mm": longitud_mm, "B_max_entrehierro_T": None}
        )

    print("Tabla de convergencia de malla (placeholder, completar tras correr el analisis):")
    for fila in resultados_convergencia:
        print(fila)
    print(
        "Criterio de convergencia sugerido: diferencia de B_max entre niveles "
        "consecutivos < 2-5%. Si no converge, refinar mas la malla del entrehierro "
        "antes de reportar resultados."
    )

    # -----------------------------------------------------------------
    # 8. Chequeo analitico de sanidad (README sec. 6): FMM = N*I
    # -----------------------------------------------------------------
    print(f"\nChequeo analitico — FMM por bobina (N*I) = {FMM_POR_BOBINA_A_TURN} A*turn")
    print(
        "TODO: completar estimacion de orden de magnitud de B via circuito "
        "magnetico equivalente (B ~ mu0*mu_r*FMM / entrehierro_equivalente), "
        "usando las longitudes/areas del camino magnetico real del motor de "
        "referencia elegido (no disponibles en este script generico). "
        "Comparar ese valor estimado contra el B_max obtenido de Maxwell antes "
        "de confiar en el resultado de la simulacion."
    )

    print("\nConfiguracion completa. Revise el proyecto en AEDT antes de analizar.")
    print(
        "Recuerde: no se ejecuta el analisis automaticamente (analyze_setup esta "
        "comentado) — descomentelo solo despues de verificar geometria, material "
        "y excitaciones en la GUI de AEDT."
    )

    m3d.save_project()


if __name__ == "__main__":
    main()
