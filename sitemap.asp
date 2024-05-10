<%
    Option Explicit
    On Error Resume Next
    
    Response.Clear
    Response.Buffer = True
    Response.AddHeader "Connection", "Keep-Alive"
    Response.CacheControl = "public"
    
    Dim strFolderArray, lngFolderArray
    Dim strUrlRoot, strPhysicalRoot, strFormat
    Dim strUrlRelative, strExt

    Dim objFSO, objFolder, objFile

    strPhysicalRoot = Server.MapPath("/")
    Set objFSO = Server.CreateObject("Scripting.Filesystemobject")
    
    strUrlRoot = "http://" & Request.ServerVariables("HTTP_HOST")
    
    ' Check for XML or TXT format.
    If UCase(Trim(Request("format")))="XML" Then
        strFormat = "XML"
        Response.ContentType = "text/xml"
    Else
        strFormat = "TXT"
        Response.ContentType = "text/plain"
    End If

    ' Add the UTF-8 Byte Order Mark.
    Response.Write Chr(CByte("&hEF"))
    Response.Write Chr(CByte("&hBB"))
    Response.Write Chr(CByte("&hBF"))
    
    If strFormat = "XML" Then
        Response.Write "<?xml version=""1.0"" encoding=""UTF-8""?>" & vbCrLf
        Response.Write "<urlset xmlns=""https://www.sitemaps.org/schemas/sitemap/0.9"">" & vbCrLf
    End if
    
    ' Always output the root of the website.
    Call WriteUrl(strUrlRoot,Now,"weekly",strFormat)

    ' --------------------------------------------------
    ' This following section contains the logic to parse
    ' the directory tree and return URLs based on the
    ' static *.html files that it locates. This is where
    ' you would change the code for dynamic content.
    ' -------------------------------------------------- 
    strFolderArray = GetFolderTree(strPhysicalRoot)

    For lngFolderArray = 1 to UBound(strFolderArray)
        strUrlRelative = Replace(Mid(strFolderArray(lngFolderArray),Len(strPhysicalRoot)+1),"\","/")
        Set objFolder = objFSO.GetFolder(Server.MapPath("." & strUrlRelative))
        For Each objFile in objFolder.Files
            strExt = objFSO.GetExtensionName(objFile.Name)
            If StrComp(strExt,"html",vbTextCompare)=0 Then
                If StrComp(Left(objFile.Name,6),"google",vbTextCompare)<>0 Then
                    Call WriteUrl(strUrlRoot & strUrlRelative & "/" & objFile.Name, objFile.DateLastModified, "weekly", strFormat)
                End If
            End If
        Next
    Next

    ' --------------------------------------------------
    ' End of file system loop.
    ' --------------------------------------------------     
    If strFormat = "XML" Then
        Response.Write "</urlset>"
    End If
    
    Response.End

    ' ======================================================================
    '
    ' Outputs a sitemap URL to the client in XML or TXT format.
    ' 
    ' tmpStrFreq = always|hourly|daily|weekly|monthly|yearly|never 
    ' tmpStrFormat = TXT|XML
    '
    ' ======================================================================

    Sub WriteUrl(tmpStrUrl,tmpLastModified,tmpStrFreq,tmpStrFormat)
        On Error Resume Next
        Dim tmpDate : tmpDate = CDate(tmpLastModified)
        ' Check if the request is for XML or TXT and return the appropriate syntax.
        If tmpStrFormat = "XML" Then
            Response.Write " <url>" & vbCrLf
            Response.Write " <loc>" & Server.HtmlEncode(tmpStrUrl) & "</loc>" & vbCrLf
            Response.Write " <lastmod>" & Year(tmpLastModified) & "-" & Right("0" & Month(tmpLastModified),2) & "-" & Right("0" & Day(tmpLastModified),2) & "</lastmod>" & vbCrLf
            Response.Write " <changefreq>" & tmpStrFreq & "</changefreq>" & vbCrLf
            Response.Write " </url>" & vbCrLf
        Else
            Response.Write tmpStrUrl & vbCrLf
        End If
    End Sub

    ' ======================================================================
    '
    ' Returns a string array of folders under a root path
    '
    ' ======================================================================

    Function GetFolderTree(strBaseFolder)
        Dim tmpFolderCount,tmpBaseCount
        Dim tmpFolders()
        Dim tmpFSO,tmpFolder,tmpSubFolder
        ' Define the initial values for the folder counters.
        tmpFolderCount = 1
        tmpBaseCount = 0
        ' Dimension an array to hold the folder names.
        ReDim tmpFolders(1)
        ' Store the root folder in the array.
        tmpFolders(tmpFolderCount) = strBaseFolder
        ' Create file system object.
        Set tmpFSO = Server.CreateObject("Scripting.Filesystemobject")
        ' Loop while we still have folders to process.
        While tmpFolderCount <> tmpBaseCount
            ' Set up a folder object to a base folder.
            Set tmpFolder = tmpFSO.GetFolder(tmpFolders(tmpBaseCount+1))
              ' Loop through the collection of subfolders for the base folder.
            For Each tmpSubFolder In tmpFolder.SubFolders
                ' Increment the folder count.
                tmpFolderCount = tmpFolderCount + 1
                ' Increase the array size
                ReDim Preserve tmpFolders(tmpFolderCount)
                ' Store the folder name in the array.
                tmpFolders(tmpFolderCount) = tmpSubFolder.Path
            Next
            ' Increment the base folder counter.
            tmpBaseCount = tmpBaseCount + 1
        Wend
        GetFolderTree = tmpFolders
    End Function
%>