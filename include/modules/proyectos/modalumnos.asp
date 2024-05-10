<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	Dim ruta
	Dim streamFile, fileItem, filePath, up
	Dim sFileName

	Set up = New FreeASPUpload
	up.Upload()

	Response.Flush	
	
	PRY_Id = up.form("PRY_Id")
	PRY_Identificador = up.form("PRY_Identificador")
	PRE_Id = up.form("PRE_Id")
	PRE_NumCuota = up.form("PRE_NumCuota")
	PRE_MontoCuota = up.form("PRE_MontoCuota")
	PRE_EstadoCuota = up.form("PRE_EstadoCuota")
	PRE_MontoFactura = up.form("PRE_MontoFactura")
	PRE_FechaFactura = up.form("PRE_FechaFactura")
	
	PRE_NumFactura = up.form("PRE_NumFactura")	
	PRE_GlosaFactura = up.form("PRE_GlosaFactura")
	PRE_Adjunto = ""
	PRE_PorcentajeMonto = up.form("PRE_PorcentajeMonto")
	PRE_FechaVenCuota = up.form("PRE_FechaVenCuota")
	PRE_FechaPagoCuota = up.form("PRE_FechaPagoCuota")
	
	if(IsNull(PRE_NumFactura) or PRE_NumFactura="") then
		PRE_NumFactura="NULL"
	end if
	if(IsNull(PRE_MontoFactura) or PRE_MontoFactura="") then
		PRE_MontoFactura="NULL"
	end if	
	 
	datos =  PRE_Id & "," & PRE_NumCuota & "," & PRE_MontoCuota & "," & PRE_EstadoCuota & "," & PRE_MontoFactura & ",'" & PRE_FechaFactura & "'," & PRE_NumFactura & ",'" & PRE_GlosaFactura & "','" & PRE_FechaPagoCuota & "','" & PRE_Adjunto & "'," & PRE_PorcentajeMonto & ",'" & PRE_FechaVenCuota & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"


	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data" : "<%=datos%>"}<%
	   response.End() 			   
	end if		
	
	'Rescatando carpeta del proyecto
	sql="exec spProyectoCarpeta_Consultar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	on error resume next	
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqx%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Carpeta=rs("PRY_Carpeta")
		carpeta = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		path="D:\DocumentosSistema\dialogosocial\" & carpeta & "\presupuestos\" & trim(PRE_NumCuota) & "\"
	else%>
	   {"state": 1, "message": "Error Carpeta : No fue posible obtener la carpeta del proyecto","data": null}<%  
		cnn.close 		
		response.End()
	end if
		
	'Creando la carpeta en el servidor si esta no existe
	dim fs,f

	folders = Split(path, "\")
	currentFolder = ""
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	For i = 0 To UBound(folders)
		currentFolder = currentFolder & folders(i)
		'response.write("</br>" & currentFolder & "</br>")
		If fs.FolderExists(currentFolder) <> true Then
			Set f=fs.CreateFolder(currentFolder)
			Set f=nothing       
		End If      
		currentFolder = currentFolder & "\"
	Next

	set f=nothing
	set fs=nothing
	'Creando la carpeta en el servidor si esta no existe
	'response.end()		
	
	ruta=path		
	up.Save(ruta)	'Subiendo archivo	
	
	sql="exec spPresupuesto_Modificar " & datos 
	
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	
	cnn.close
	set cnn = nothing%>
	{"state": 200, "message": "Ejecución exitosa","data": null}