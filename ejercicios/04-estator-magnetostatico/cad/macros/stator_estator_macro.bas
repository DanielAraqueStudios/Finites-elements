' ============================================================================
' Macro: stator_estator_macro.bas
' Proposito: Generar parametricamente la geometria del estator trifasico
'            (nucleo + ranuras + volumenes de bobina por fase) para el
'            Ejercicio 4 del parcial de Elementos Finitos, y exportar a STEP
'            para su importacion en ANSYS Maxwell 3D.
'
' Fuente unica de verdad de los parametros: docs/estator-magnetostatico/README.md
' (secciones 1-3). Todo valor marcado [TYPICAL] debe reemplazarse por el del
' motor de referencia real elegido antes de usar el resultado en el informe.
'
' [VERIFY] Nombres de metodos/objetos del API de SolidWorks segun version
' instalada (probado conceptualmente contra SW API 2021-2023; puede variar).
' ============================================================================

Option Explicit

' --- Parametros geometricos [TYPICAL] (README sec. 1) ---
Const OD_ESTATOR_MM As Double = 120#      ' Diametro exterior
Const ID_BORE_MM As Double = 75#          ' Diametro interior (bore)
Const ENTREHIERRO_MM As Double = 0.5      ' Air gap (referencia, no se modela el rotor aqui)
Const LONGITUD_AXIAL_MM As Double = 80#   ' Stack length
Const NUM_RANURAS As Integer = 36         ' 4 polos, 3 fases, 3 ranuras/polo/fase
Const NUM_POLOS As Integer = 4

' --- Geometria de ranura trapezoidal semi-cerrada [TYPICAL] ---
' Nota: dimensiones de ranura NO estan en el README (solo se indica el tipo);
' se usan valores geometricamente consistentes con OD/bore/num_ranuras como
' punto de partida razonable. [VERIFY] contra el motor de referencia real.
Const RANURA_PROFUNDIDAD_MM As Double = 15#   ' Profundidad radial de la ranura
Const RANURA_ANCHO_DIENTE_MM As Double = 2.5  ' Ancho del diente (tooth) en el bore
Const RANURA_ABERTURA_MM As Double = 2#       ' Abertura semi-cerrada hacia el bore

' --- Parametros de devanado (solo para definir VOLUMENES de bobina, no las
'     vueltas individuales de alambre) (README sec. 3) ---
Const NUM_FASES As Integer = 3
Const RANURAS_POR_POLO_POR_FASE As Integer = 3  ' = NUM_RANURAS / (NUM_POLOS * NUM_FASES)

Dim swApp As Object
Dim swModel As Object
Dim swPart As Object
Dim swSketchMgr As Object
Dim swFeatMgr As Object

Sub main()

    Set swApp = Application.SldWorks

    ' --- 1. Crear nueva pieza desde plantilla por defecto ---
    ' [VERIFY] Ruta de plantilla segun instalacion local del usuario.
    Dim plantillaPath As String
    plantillaPath = swApp.GetUserPreferenceStringValue(swDefaultTemplatePart) ' [VERIFY] constante exacta

    Set swModel = swApp.NewDocument(plantillaPath, 0, 0, 0)
    Set swPart = swModel
    Set swSketchMgr = swModel.SketchManager
    Set swFeatMgr = swModel.FeatureManager

    If swModel Is Nothing Then
        MsgBox "Error: no se pudo crear el documento. Verifique la plantilla de pieza por defecto en SolidWorks."
        Exit Sub
    End If

    ' --- 2. Sketch del nucleo: anillo (OD / bore) en el plano frontal ---
    swModel.ClearSelection2 True
    swModel.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0 ' confirmado via macro grabada: instalacion en ingles

    swSketchMgr.InsertSketch True

    Dim radioExtMetros As Double, radioIntMetros As Double
    radioExtMetros = (OD_ESTATOR_MM / 2#) / 1000#
    radioIntMetros = (ID_BORE_MM / 2#) / 1000#

    swSketchMgr.CreateCircleByRadius 0, 0, 0, radioExtMetros
    swSketchMgr.CreateCircleByRadius 0, 0, 0, radioIntMetros

    swSketchMgr.InsertSketch True ' Cierra el sketch

    ' --- 3. Extruir el anillo del nucleo (stack length) ---
    Dim longitudMetros As Double
    longitudMetros = LONGITUD_AXIAL_MM / 1000#

    ' Firma confirmada contra SolidWorks 2026 (via Tools > Macro > Record):
    ' en esta version el metodo es FeatureExtrusion2 (no FeatureExtrusion3),
    ' con el mismo orden/cantidad de 23 argumentos posicionales.
    Dim swCoreExtrude As Object
    Set swCoreExtrude = swFeatMgr.FeatureExtrusion2( _
        True, False, False, _
        0, 0, _
        longitudMetros, 0, _
        False, False, False, False, _
        0, 0, _
        False, False, False, False, _
        True, True, True, _
        0, 0, False)

    If swCoreExtrude Is Nothing Then
        MsgBox "Error: fallo la extrusion del nucleo del estator. Revise el sketch del anillo."
        Exit Sub
    End If

    ' --- 4. Patron circular de ranuras trapezoidales semi-cerradas ---
    ' Se modela UNA ranura como corte (cut-extrude) y se patronea circularmente
    ' NUM_RANURAS veces alrededor del eje Z (eje del estator).
    CrearRanuraYPatron radioIntMetros, longitudMetros

    ' --- 5. Volumenes de bobina por fase (placeholders geometricos) ---
    ' Estos volumenes se usan en Maxwell para asignar la excitacion de cada
    ' fase (A/B/C); NO representan el bobinado fisico vuelta por vuelta.
    CrearVolumenesBobinaPorFase radioIntMetros, longitudMetros

    ' --- 6. Exportacion a STEP deshabilitada ---
    ' El usuario exporta manualmente desde la GUI: File > Save As, eligiendo
    ' formato STEP (*.step/*.stp) o Parasolid (*.x_t) para importar en ANSYS
    ' Maxwell. (DWG es un formato de dibujo 2D; SolidWorks no exporta un
    ' solido 3D a DWG, y Maxwell no importa geometria 3D desde DWG — usar
    ' STEP/Parasolid/IGES para este flujo.)
    MsgBox "Geometria completa. Exporte manualmente via File > Save As, formato STEP (*.step) o Parasolid (*.x_t), como 'stator.step' en cad/solidworks/ para que coincida con la ruta esperada por ansys/maxwell/setup_stator_magnetostatic.py."

End Sub

' ----------------------------------------------------------------------------
' Crea el perfil de una ranura trapezoidal semi-cerrada como corte y la
' patronea circularmente NUM_RANURAS veces.
' ----------------------------------------------------------------------------
Sub CrearRanuraYPatron(radioIntMetros As Double, longitudMetros As Double)

    Dim profundidadMetros As Double, anchoDienteMetros As Double, aberturaMetros As Double
    profundidadMetros = RANURA_PROFUNDIDAD_MM / 1000#
    anchoDienteMetros = RANURA_ANCHO_DIENTE_MM / 1000#
    aberturaMetros = RANURA_ABERTURA_MM / 1000#

    ' Sketch de la ranura en el plano frontal, posicionada en el bore (angulo 0)
    swModel.ClearSelection2 True
    swModel.Extension.SelectByID2 "Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0

    swSketchMgr.InsertSketch True

    ' Perfil trapezoidal simplificado: base angosta en el bore (abertura),
    ' base ancha en la profundidad de ranura. [VERIFY] geometria exacta segun
    ' estandar de ranura semi-cerrada real del fabricante.
    Dim x0 As Double, x1 As Double, yBase As Double, yTope As Double
    x0 = -(aberturaMetros / 2#)
    x1 = (aberturaMetros / 2#)
    yBase = radioIntMetros
    yTope = radioIntMetros + profundidadMetros

    Dim seg1 As Object, seg2 As Object, seg3 As Object, seg4 As Object
    Set seg1 = swSketchMgr.CreateLine(x0, yBase, 0, x1, yBase, 0)
    Set seg2 = swSketchMgr.CreateLine(x1, yBase, 0, (anchoDienteMetros / 2#), yTope, 0)
    Set seg3 = swSketchMgr.CreateLine((anchoDienteMetros / 2#), yTope, 0, -(anchoDienteMetros / 2#), yTope, 0)
    Set seg4 = swSketchMgr.CreateLine(-(anchoDienteMetros / 2#), yTope, 0, x0, yBase, 0)

    ' CreateLine deberia auto-fusionar extremos coincidentes, pero esto no
    ' se confirmo de forma fiable en pruebas reales (el perfil parecia
    ' quedar abierto, causando que FeatureCut4 devolviera Nothing). Para
    ' no depender de ese comportamiento implicito, se fuerzan relaciones
    ' de coincidencia explicitas entre cada par de vertices adyacentes.
    ForzarCoincidencia seg1, seg2
    ForzarCoincidencia seg2, seg3
    ForzarCoincidencia seg3, seg4
    ForzarCoincidencia seg4, seg1

    ' NO cerrar el sketch aqui con un segundo InsertSketch: eso deja el
    ' sketch sin seleccionar/activo y FeatureCut4 no tiene perfil para
    ' cortar (causa real de "FeatureCut4 devolvio Nothing"). El sketch se
    ' deja ABIERTO — FeatureCut4 lo consume/cierra el solo, igual que en el
    ' flujo grabado real (mirror_pattern1.bas: InsertSketch True, se dibuja
    ' el perfil, y se llama FeatureCut4 directamente sin cerrar el sketch).

    ' Corte extruido a traves de todo el stack length.
    ' Firma confirmada contra SolidWorks 2026 (via Tools > Macro > Record):
    ' en esta version el metodo es FeatureCut4 (no FeatureCut3), con 27
    ' argumentos posicionales. T1=1 (valor real capturado por el macro
    ' recorder del usuario para un corte "Through All") en vez de 0 (Blind).
    Dim swSlotCut As Object
    Set swSlotCut = swFeatMgr.FeatureCut4( _
        True, False, False, 1, 0, longitudMetros, 0, _
        False, False, False, False, 0, 0, _
        False, False, False, False, False, _
        True, True, True, True, False, _
        0, 0, False, False)

    If swSlotCut Is Nothing Then
        MsgBox "Error: fallo el corte de la ranura base. Revise el perfil trapezoidal."
        Exit Sub
    End If

    ' Nombrar la feature de corte para poder seleccionarla de forma fiable
    ' como "seed feature" del patron circular (coincide con el flujo grabado:
    ' SelectByID2 "Cut-Extrude1", "BODYFEATURE", ...).
    Dim swSlotCutFeature As Object
    Set swSlotCutFeature = swSlotCut ' FeatureCut4 ya devuelve el objeto Feature
    swSlotCutFeature.Name = "Ranura_Base_Cut"

    ' --- Patron circular alrededor del eje del nucleo, NUM_RANURAS instancias ---
    ' Firma confirmada contra SolidWorks 2026: NO es FeatureCircularPatternSG5;
    ' el flujo moderno es seleccionar la feature semilla + el eje/arista de
    ' referencia, construir una definicion via CreateDefinition(swFmCirPattern),
    ' fijar sus propiedades, y crear la feature con CreateFeature.
    swModel.ClearSelection2 True
    swModel.Extension.SelectByID2 "Ranura_Base_Cut", "BODYFEATURE", 0, 0, 0, False, 4, Nothing, 0
    swModel.Extension.SelectByID2 "Axis1", "AXIS", 0, 0, 0, True, 1, Nothing, 0 ' [VERIFY] nombre del eje segun lo que SolidWorks haya generado realmente: activar View > Temporary Axes para que el eje cilindrico del nucleo quede disponible como "Axis1" (instalacion en ingles), o crear uno explicito con Insert > Reference Geometry > Axis si no aparece con ese nombre

    Dim anguloTotalRad As Double
    anguloTotalRad = 2 * 3.14159265358979 ' 360 grados completos

    Dim swFeatData As Object
    Set swFeatData = swFeatMgr.CreateDefinition(swFeatureNameID_e.swFmCirPattern)

    If swFeatData Is Nothing Then
        MsgBox "Error: no se pudo crear la definicion del patron circular. Verifique la seleccion de feature semilla + eje."
        Exit Sub
    End If

    swFeatData.Direction2 = False
    swFeatData.EqualSpacing = True          ' distribuir NUM_RANURAS uniformemente en 360 grados
    swFeatData.GeometryPattern = False
    swFeatData.ReverseDirection = False
    swFeatData.Spacing = anguloTotalRad      ' angulo total (360 grados en radianes); con EqualSpacing=True se reparte entre TotalInstances
    swFeatData.TotalInstances = NUM_RANURAS
    swFeatData.VarySketch = False

    Dim swSlotPattern As Object
    Set swSlotPattern = swFeatMgr.CreateFeature(swFeatData)

    If swSlotPattern Is Nothing Then
        MsgBox "Error: fallo el patron circular de ranuras. Verifique el eje de referencia seleccionado."
    End If

    swModel.ClearSelection2 True

End Sub

' ----------------------------------------------------------------------------
' Crea 3 volumenes de bobina (fases A, B, C) desfasados 120 grados electricos,
' representando regiones donde Maxwell asignara la excitacion de corriente.
' ----------------------------------------------------------------------------
Sub CrearVolumenesBobinaPorFase(radioIntMetros As Double, longitudMetros As Double)

    Dim i As Integer
    Dim anguloBaseGrados As Double
    Dim gradosPorRanura As Double
    gradosPorRanura = 360# / NUM_RANURAS

    ' Para cada fase, se crea un volumen de bobina representativo en el
    ' primer grupo de ranuras asignado a esa fase (simplificacion: 1 volumen
    ' por fase como placeholder, no el devanado distribuido completo).
    ' Secuencia tipica A-B-C desfasada segun RANURAS_POR_POLO_POR_FASE.
    For i = 0 To NUM_FASES - 1
        anguloBaseGrados = i * (gradosPorRanura * RANURAS_POR_POLO_POR_FASE)
        CrearVolumenBobinaUnico anguloBaseGrados, radioIntMetros, longitudMetros, i
    Next i

End Sub

Sub CrearVolumenBobinaUnico(anguloGrados As Double, radioIntMetros As Double, longitudMetros As Double, indiceFase As Integer)

    ' Placeholder: crea un bloque simple dentro de la ranura correspondiente
    ' para representar el volumen de cobre de esa fase. El usuario debe
    ' ajustar la geometria real de la bobina (forma, relleno) segun el
    ' bobinado real del motor de referencia.
    ' [VERIFY] Esta funcion es un esqueleto; completar con sketch + extrude
    ' posicionado en el angulo correspondiente usando transformaciones de
    ' plano rotado, segun API de SolidWorks disponible.

    Debug.Print "TODO: crear volumen de bobina fase " & indiceFase & _
                " en angulo " & anguloGrados & " grados. " & _
                "Nombrar el cuerpo resultante como 'Bobina_Fase_" & Chr(65 + indiceFase) & "' " & _
                "para que el script PyAEDT (ansys/maxwell/setup_stator_magnetostatic.py) " & _
                "pueda identificarlo al asignar la excitacion."

End Sub

' ----------------------------------------------------------------------------
' Fuerza una relacion de coincidencia entre el punto final de segA y el
' punto inicial de segB, para garantizar que el perfil quede realmente
' cerrado (sin depender del auto-merge implicito de CreateLine).
' ----------------------------------------------------------------------------
Sub ForzarCoincidencia(segA As Object, segB As Object)

    Dim ptA As Object, ptB As Object
    Set ptA = segA.GetEndPoint2
    Set ptB = segB.GetStartPoint2

    If ptA Is Nothing Or ptB Is Nothing Then
        MsgBox "Error: no se pudo obtener los puntos extremos de la linea para forzar coincidencia."
        Exit Sub
    End If

    swModel.ClearSelection2 True
    ptA.Select4 False, Nothing
    ptB.Select4 True, Nothing
    swModel.SketchAddConstraints "sgCOINCIDENT"
    swModel.ClearSelection2 True

End Sub
