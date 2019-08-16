Function GetPLInfo(infoName As String)
    Application.DisplayAlerts = False
    Application.ScreenUpdating = False
    Application.AskToUpdateLinks = False

    Dim rng As Range
    Dim rowIdx As Integer
    Dim res As Double
    Dim sh As Worksheet
    Set sh = Worksheets(1)
    sh.Activate
    
    With sh.UsedRange
        Set rng = .Find(What:="SUBTOTAL", lookat:=xlPart)
        If Not rng Is Nothing Then
            rowIdx = rng.Row
        Else
            rowIdx = -1
        End If
    End With
    
    If infoName = "qty" Then res = sh.Range("F" & rowIdx).Value   'QTY
    If infoName = "ctns" Then res = sh.Range("E" & rowIdx).Value   'ctns
    If infoName = "nwgt" Then res = sh.Range("R" & rowIdx).Value   'nwgt
    If infoName = "gwgt" Then res = sh.Range("T" & rowIdx).Value   'gwgt
    If infoName = "cmb" Then res = sh.Range("W" & rowIdx).Value   'cmb
     
    GetPLInfo = res

    Application.DisplayAlerts = True
    Application.ScreenUpdating = True
    Application.AskToUpdateLinks = True
    
End Function
