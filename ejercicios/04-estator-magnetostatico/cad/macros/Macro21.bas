Attribute VB_Name = "Macro21"
' ******************************************************************************
' C:\Users\lcdan\AppData\Local\Temp\swx31920\Macro1.swb - macro recorded on 10/25/26 by Daniel
' ******************************************************************************
Dim swApp As Object

Dim Part As Object
Dim boolstatus As Boolean
Dim longstatus As Long, longwarnings As Long

Sub main()

Set swApp = Application.SldWorks

Set Part = swApp.ActiveDoc
Dim COSMOSWORKSObj As Object
Dim CWAddinCallBackObj As Object
Dim StudyManagerObj As Object
Dim ActiveDocObj As Object
Set CWAddinCallBackObj = swApp.GetAddInObject("CosmosWorks.CosmosWorks")
Set COSMOSWORKSObj = CWAddinCallBackObj.COSMOSWORKS
Dim myModelView As Object
Set myModelView = Part.ActiveView
myModelView.FrameState = swWindowState_e.swWindowMaximized
Part.ClearSelection2 True
Dim skSegment As Object
Set skSegment = Part.SketchManager.CreateLine(0#, 0.025325, 0#, -0.02827, 0.025325, 0#)
Set skSegment = Part.SketchManager.CreateLine(-0.02827, 0.025325, 0#, -0.039917, -0.017649, 0#)
Set skSegment = Part.SketchManager.CreateLine(-0.039917, -0.017649, 0#, 0.028195, -0.017649, 0#)
Set skSegment = Part.SketchManager.CreateLine(0.028195, -0.017649, 0#, 0.010724, 0.025325, 0#)
Set skSegment = Part.SketchManager.CreateLine(0.010724, 0.025325, 0#, 0#, 0.025325, 0#)

' Named View
Part.ShowNamedView2 "*Trimetric", 8
Part.ViewZoomtofit2
Dim myFeature As Object
Set myFeature = Part.FeatureManager.FeatureExtrusion2(True, False, False, 0, 0, 0.01, 0.01, False, False, False, False, 1.74532925199433E-02, 1.74532925199433E-02, False, False, False, False, True, True, True, 0, 0, False)
Part.SelectionManager.EnableContourSelection = False
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -5.15417544729577E-03, 0
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -2.57708772364788E-03, 0
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -2.31937895128309E-02, 5.39439458098003E-03
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -7.73126317094365E-03, 5.39439458098003E-03
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -5.41188421966055E-02, 7.55215241337205E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -4.89646667493098E-02, 8.09159187147005E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -5.41188421966055E-02, 0.118676680781561
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -7.21584562621407E-02, 0.172620626591361
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -0.105660596669563, 0.210381388658221
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -9.27751580513238E-02, 0.204986994077241
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -0.067004280814845, 0.129465469943521
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -6.44271930911971E-02, 0.134859864524501
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -1.80396140655352E-02, 4.31551566478403E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -1.80396140655352E-02, 3.23663674858802E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -1.54625263418873E-02, 2.69719729049002E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -3.60792281310704E-02, 8.09159187147005E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -4.12334035783661E-02, 8.09159187147005E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -2.31937895128309E-02, 4.85495512288203E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -0.043810491302014, 9.70991024576406E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -2.31937895128309E-02, 4.31551566478403E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -2.31937895128309E-02, 3.23663674858802E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -2.06167017891831E-02, 4.31551566478403E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -2.06167017891831E-02, 3.23663674858802E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -1.80396140655352E-02, 2.69719729049002E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -1.54625263418873E-02, 2.69719729049002E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -3.09250526837746E-02, 3.77607620668602E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -7.73126317094365E-03, 1.61831837429401E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -5.15417544729577E-03, 0
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter -5.15417544729577E-03, 1.07887891619601E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.57708772364788E-03, 0
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.57708772364788E-03, 0
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, 0
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 5.15417544729577E-03, -1.07887891619601E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.57708772364788E-03, -1.61831837429401E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.06167017891831E-02, -5.93383403907804E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.54625263418873E-02, -5.39439458098003E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.80396140655352E-02, -7.01271295527404E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 3.60792281310704E-02, -0.129465469943521
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.57708772364788E-03, 0
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.57708772364788E-03, -5.39439458098003E-03
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.57708772364788E-03, -1.07887891619601E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 5.15417544729577E-03, -2.69719729049002E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.28854386182394E-02, -0.124071075362541
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.03083508945915E-02, -5.93383403907804E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -5.93383403907804E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -4.31551566478403E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -4.85495512288203E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -3.23663674858802E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -2.15775783239201E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 5.15417544729577E-03, -2.15775783239201E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.57708772364788E-03, -3.23663674858802E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.03083508945915E-02, -0.102493497038621
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.28854386182394E-02, -0.124071075362541
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.54625263418873E-02, -0.140254259105481
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -6.47327349717604E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -6.47327349717604E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -5.93383403907804E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 5.15417544729577E-03, -5.93383403907804E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.28854386182394E-02, -9.70991024576406E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -3.77607620668602E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 5.15417544729577E-03, -3.77607620668602E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 5.15417544729577E-03, -4.31551566478403E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.54625263418873E-02, -0.113282286200581
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -8.09159187147005E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.03083508945915E-02, -0.102493497038621
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.06167017891831E-02, -0.264325334468022
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 5.15417544729577E-03, -9.70991024576406E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.03083508945915E-02, -7.01271295527404E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -8.63103132956805E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.03083508945915E-02, -7.01271295527404E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -5.93383403907804E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -4.85495512288203E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 1.03083508945915E-02, -6.47327349717604E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 5.15417544729577E-03, -1.61831837429401E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 0, -5.39439458098003E-03
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.57708772364788E-03, -5.39439458098003E-02

' Roll View
Dim swModelView As Object
Set swModelView = Part.ActiveView
swModelView.RollBy 0
Set StudyManagerObj = Nothing
Set ActiveDocObj = Nothing
Set CWAddinCallBackObj = Nothing
Set COSMOSWORKSObj = Nothing
End Sub
