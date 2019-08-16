Sub Main(masterPath As String)
    Application.DisplayAlerts = False
    Application.ScreenUpdating = False
    Application.AskToUpdateLinks = False
    
    'masterPath = "C:\A_RPA_Projects\Ramatex\P001_WorkFolder\Source\Master Production Plan.xlsx"

    Call DeleteRowsAndColumns
    Call AddColumns
    Call FillInPONumber
    Call FillInFactoryInfo(masterPath)

    Application.DisplayAlerts = True
    Application.ScreenUpdating = True
    Application.AskToUpdateLinks = True


End Sub
Function DeleteRowsAndColumns()
    Dim sh As Worksheet
    Dim colArr
    Dim rCount As Integer
    Dim colCount As Integer
    
    Set sh = Worksheets("SAPBW_DOWNLOAD")
    sh.Activate
    
    colArr = Array("PO Number", "Trading Co PO Number", "PO Item", "Customer", "Customer", _
    "Customer Country", "Material", "OGAC Date", "GAC Date", "Buy Group", "Plant", "Delivery Date", "Mode", "AFS Category", "Gndr Age", "Planning Season", "Qty")
      

    rCount = sh.UsedRange.Rows.Count
    colCount = sh.UsedRange.Columns.Count
    
    Debug.Print rCount
    Debug.Print colCount
    

    '删除1至88行无用信息，删除A,B列

    Rows("1:88").Select
    Selection.Delete Shift:=xlUp

    Columns("A:B").Select
    Selection.Delete Shift:=xlToLeft

    '删除不需要的列，只保留数组colArr中的列

    On Error Resume Next
    Dim y

    For i = colCount To 1 Step -1

        y = 0

        y = Application.WorksheetFunction.Match(Trim(Cells(1, i)), colArr, 0)

        If y = 0 Then

            Cells(1, i).EntireColumn.Delete

        End If

    Next



End Function


Function AddColumns()
    Dim sh As Worksheet
    Dim rCount As Integer
    Dim colCount As Integer
    
    Set sh = Worksheets("SAPBW_DOWNLOAD")
    sh.Activate

    rCount = sh.UsedRange.Rows.Count
    colCount = sh.UsedRange.Columns.Count
    
    Debug.Print rCount
    Debug.Print colCount

    '在数据最后一列的后一列添加列名 - Update Gac Date
    Cells(1, colCount + 1) = "Update Gac Date"
    Cells(1, colCount + 1).Select
    Selection.Interior.Color = 65535
    

    '增加A列 - FTY No.
    '增加B列 - FTY

    Columns("A:A").Select
    Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove

    Cells(1, 1) = "FTY No."
    Cells(1, 2) = "FTY"
    
    Range("A1").Select
    Selection.Interior.Color = 12611584
    Range("B1").Select
    Selection.Interior.Color = 12611584
    
End Function



Function FillInPONumber()
    Dim sh As Worksheet
    Dim rCount As Integer
    Dim colCount As Integer
    
    Set sh = Worksheets("SAPBW_DOWNLOAD")
    sh.Activate

    rCount = sh.UsedRange.Rows.Count
    colCount = sh.UsedRange.Columns.Count
    
    Debug.Print rCount
    Debug.Print colCount

    '填写所有行的PO Number

    For i = 2 To rCount
        If IsEmpty(Cells(i, 3)) Then

            Cells(i, 3) = Cells(i - 1, 3)

        ElseIf Trim(Cells(i, 3)) = "Result" Then
            Rows(i & ":" & rCount).Delete

            Exit For

        End If
    Next
    
End Function



Function FillInFactoryInfo(masterPath As String)

    Dim myApp As New Application
    Dim pprSh As Worksheet
    Dim masterWb As Workbook
    
    
    myApp.Visible = False
    
    Set masterWb = myApp.Workbooks.Open(masterPath)
    Set masterSh = masterWb.Sheets("Master")
    
    
    Set pprSh = Worksheets("SAPBW_DOWNLOAD")
    pprSh.Activate
    
    For i = 2 To pprSh.UsedRange.Rows.Count
        a = pprSh.Range("C" & i).Value
        
        With masterSh.Range("A:A")
            Set Rng = .Find(What:=a, lookat:=xlWhole)
            If Not Rng Is Nothing Then
                pprSh.Range("A" & i) = masterSh.Range("I" & Rng.Row)
                pprSh.Range("B" & i) = masterSh.Range("L" & Rng.Row)
            End If
        End With

          
    Next
    
    
    masterWb.Close
    
    
    myApp.Quit
    
    Set pprSh = Nothing
    Set masterSh = Nothing
    Set myApp = Nothing
    Set masterWb = Nothing
    

End Function





