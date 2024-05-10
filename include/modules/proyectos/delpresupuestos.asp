<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="freeASPUpload.asp" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil"))=4 then	'ejecutor, Auditor%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	PRY_Id = request("PRY_Id")	
	PRY_Identificador = request("PRY_Identificador")
	PRE_Id = request("PRE_Id")
	PRE_Numcuota = request("PRE_NumCuota")
 
	datos =  PRE_Id & "," & PRY_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"


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
		path="D:\DocumentosSistema\dialogosocial\" & carpeta & "\presupuestos\" & trim(PRE_NumCuota)
	else%>
	   {"state": 1, "message": "Error Carpeta : No fue posible obtener la carpeta del proyecto","data": null}<%  
		cnn.close 		
		response.End()
	end if
		
	'Creando la carpeta en el servidor si esta no existe
	dim fs,f	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	
	If fs.FolderExists(path) then
		fs.DeleteFolder path, True                   'True indicates forceful deletion
	End If

	set f=nothing
	set fs=nothing
	'Creando la carpeta en el servidor si esta no existe
	'response.end()		
	
	sql="exec spPresupuesto_Eliminar " & datos 
	
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