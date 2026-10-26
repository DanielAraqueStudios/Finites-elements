Attribute VB_Name = "mirror_pattern1"
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
boolstatus = Part.Extension.SetUserPreferenceToggle(swUserPreferenceToggle_e.swSketchAddConstToRectEntity, swUserPreferenceOption_e.swDetailingNoOptionSpecified, True)
boolstatus = Part.Extension.SetUserPreferenceToggle(swUserPreferenceToggle_e.swSketchAddConstLineDiagonalType, swUserPreferenceOption_e.swDetailingNoOptionSpecified, True)
Dim vSkLines As Variant
vSkLines = Part.SketchManager.CreateCenterRectangle(0, 0, 0, -0.059677194436649, 5.04078832055871E-02, 0)

' Named View
Part.ShowNamedView2 "*Trimetric", 8
Part.ViewZoomtofit2
Dim myFeature As Object
Set myFeature = Part.FeatureManager.FeatureExtrusion2(True, False, False, 0, 0, 0.05, 0.01, False, False, False, False, 1.74532925199433E-02, 1.74532925199433E-02, False, False, False, False, True, True, True, 0, 0, False)
Part.SelectionManager.EnableContourSelection = False
boolstatus = Part.Extension.SelectByRay(-6.46650846078956E-05, 1.45667898215152E-02, 5.00000000000114E-02, -0.400036026779312, -0.515038074910024, -0.758094294050284, 7.02288323469094E-04, 2, False, 0, 0)
Part.SketchManager.InsertSketch True
Part.ClearSelection2 True
Dim skSegment As Object
Set skSegment = Part.SketchManager.CreateCircle(0#, 0#, 0#, -0.007589, 0.016074, 0#)

' Previous View
Part.ViewOrientationUndo
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 0, -5.39439458098003E-03

' Roll View
Dim swModelView As Object
Set swModelView = Part.ActiveView
swModelView.RollBy 0
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 0, -5.39439458098003E-03
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 5.15417544729577E-03, -5.39439458098003E-03
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -1.07887891619601E-02

' Roll View
Set swModelView = Part.ActiveView
swModelView.RollBy 0
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 2.06167017891831E-02, -5.39439458098003E-02
Set myModelView = Part.ActiveView
myModelView.RotateAboutCenter 7.73126317094365E-03, -2.69719729049002E-02

' Roll View
Set swModelView = Part.ActiveView
swModelView.RollBy 0

' Roll View
Set swModelView = Part.ActiveView
swModelView.RollBy 0

' Zoom In/Out (MouseWheel)
Set swModelView = Part.ActiveView
swModelView.Scale2 = 0.712210559786004
Dim swTranslation() As Double
ReDim swTranslation(0 To 2) As Double
swTranslation(0) = 2.44655139221191E-02
swTranslation(1) = -2.52948428588761E-03
swTranslation(2) = 3.76713291861752E-03
Dim swTranslationVar As Variant
swTranslationVar = swTranslation
Dim swMathUtils As Object
Set swMathUtils = swApp.GetMathUtility()
Dim swTranslationVector As MathVector
Set swTranslationVector = swMathUtils.CreateVector((swTranslationVar))
swModelView.Translation3 = swTranslationVector

' Zoom In/Out (MouseWheel)
Set swModelView = Part.ActiveView
swModelView.Scale2 = 0.59350879982167
ReDim swTranslation(0 To 2) As Double
swTranslation(0) = 0.023712635273066
swTranslation(1) = -0.002107903571573
swTranslation(2) = 3.13927743218126E-03
swTranslationVar = swTranslation
Set swMathUtils = swApp.GetMathUtility()
Set swTranslationVector = swMathUtils.CreateVector((swTranslationVar))
swModelView.Translation3 = swTranslationVector

' Zoom In/Out (MouseWheel)
Set swModelView = Part.ActiveView
swModelView.Scale2 = 0.494590666518058
ReDim swTranslation(0 To 2) As Double
swTranslation(0) = 2.30852363988551E-02
swTranslation(1) = -1.75658630964418E-03
swTranslation(2) = 2.61606452681772E-03
swTranslationVar = swTranslation
Set swMathUtils = swApp.GetMathUtility()
Set swTranslationVector = swMathUtils.CreateVector((swTranslationVar))
swModelView.Translation3 = swTranslationVector

' Zoom In/Out (MouseWheel)
Set swModelView = Part.ActiveView
swModelView.Scale2 = 0.595892369298866
ReDim swTranslation(0 To 2) As Double
swTranslation(0) = 2.26481363384525E-02
swTranslation(1) = 1.32491007526935E-03
swTranslation(2) = 3.15188497206954E-03
swTranslationVar = swTranslation
Set swMathUtils = swApp.GetMathUtility()
Set swTranslationVector = swMathUtils.CreateVector((swTranslationVar))
swModelView.Translation3 = swTranslationVector

' Zoom In/Out (MouseWheel)
Set swModelView = Part.ActiveView
swModelView.Scale2 = 0.717942613613091
ReDim swTranslation(0 To 2) As Double
swTranslation(0) = 2.21664938004782E-02
swTranslation(1) = 5.03755632215314E-03
swTranslation(2) = 3.79745177357776E-03
swTranslationVar = swTranslation
Set swMathUtils = swApp.GetMathUtility()
Set swTranslationVector = swMathUtils.CreateVector((swTranslationVar))
swModelView.Translation3 = swTranslationVector

' Zoom In/Out (MouseWheel)
Set swModelView = Part.ActiveView
swModelView.Scale2 = 0.864991100738664
ReDim swTranslation(0 To 2) As Double
swTranslation(0) = 2.15862015860514E-02
swTranslation(1) = 0.009510624089483
swTranslation(2) = 4.5752431006961E-03
swTranslationVar = swTranslation
Set swMathUtils = swApp.GetMathUtility()
Set swTranslationVector = swMathUtils.CreateVector((swTranslationVar))
swModelView.Translation3 = swTranslationVector
Set myFeature = Part.FeatureManager.FeatureCut4(True, False, False, 1, 0, 0.05, 0.05, False, False, False, False, 1.74532925199433E-02, 1.74532925199433E-02, False, False, False, False, False, True, True, True, True, False, 0, 0, False, False)
Part.SelectionManager.EnableContourSelection = False
Part.ActivateSelectedFeature
boolstatus = Part.Extension.SelectByRay(-1.94191052224255E-02, 5.04078832054802E-02, 3.17001228067397E-02, -0.482670467344432, -0.546894001162572, -0.684058602347709, 6.93894528480539E-04, 2, True, 1, 0)
boolstatus = Part.DeSelectByID("", "FACE", -1.94191052224255E-02, 5.04078832054802E-02, 3.17001228067397E-02)
boolstatus = Part.Extension.SelectByID2("Front Plane", "PLANE", 4.99839741326014E-03, 6.80394487941953E-02, 9.99410834216405E-02, True, 1, Nothing, 0)
boolstatus = Part.DeSelectByID("Front Plane", "PLANE", 4.99839741326014E-03, 6.80394487941953E-02, 9.99410834216405E-02)
boolstatus = Part.Extension.SelectByRay(-0.038259110761885, 5.04078832055939E-02, 3.46104821703648E-02, -0.482670467344432, -0.546894001162572, -0.684058602347709, 6.93894528480539E-04, 2, True, 1, 0)
boolstatus = Part.DeSelectByID("", "FACE", -0.038259110761885, 5.04078832055939E-02, 3.46104821703648E-02)
boolstatus = Part.Extension.SelectByRay(5.96771944365742E-02, 1.98824404039897E-02, 3.19782564432103E-02, -0.482670467344432, -0.546894001162572, -0.684058602347709, 6.93894528480539E-04, 2, True, 1, 0)
Part.ClearSelection2 True
boolstatus = Part.Extension.SelectByID2("Cut-Extrude1", "BODYFEATURE", 0, 0, 0, False, 4, Nothing, 0)
boolstatus = Part.Extension.SelectByRay(5.96771944365742E-02, 1.98824404039897E-02, 3.19782564432103E-02, -0.482670467344432, -0.546894001162572, -0.684058602347709, 6.93894528480539E-04, 2, True, 1, 0)
Dim swFeat As Object
Dim swFeatMgr As Object

Set swFeatMgr = Part.FeatureManager
Dim swFeatData As Object
Set swFeatData = swFeatMgr.CreateDefinition(swFeatureNameID_e.swFmCirPattern)
swFeatData.Direction2 = False
swFeatData.EqualSpacing = False
swFeatData.GeometryPattern = False
swFeatData.ReverseDirection = False
swFeatData.Spacing = 0.26179938779915
swFeatData.TotalInstances = 2
swFeatData.VarySketch = False
Set swFeat = swFeatMgr.CreateFeature(swFeatData)
Part.ClearSelection2 True
Set StudyManagerObj = Nothing
Set ActiveDocObj = Nothing
Set CWAddinCallBackObj = Nothing
Set COSMOSWORKSObj = Nothing
End Sub
