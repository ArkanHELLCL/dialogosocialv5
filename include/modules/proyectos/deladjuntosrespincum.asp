<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")	
	IPR_Id				= request("IPR_Id")	
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	'Rescatando carpeta del proyecto
	sql="exec spProyectoCarpeta_Consultar " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs = cnn.Execute(sql)
	on error resume next	
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		if len(IPR_Id)>1 then
			yIPR_Id=""
			for i=0 to len(IPR_Id)
				if(isnumeric(mid(IPR_Id,i,1))) then
					yIPR_Id=yIPR_Id & mid(IPR_Id,i,1)
				end if
			next
		else
			yIPR_Id=cint(IPR_Id)
		end if
		path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\incumplimientos\res-" & yIPR_Id & "\"
		
	else%>
	   {"state": 1, "message": "Error Carpeta : No fue posible obtener la carpeta del proyecto","data": null}<%  
		cnn.close 		
		response.End()
	end if			
	
	set FSO = server.createObject("Scripting.FileSystemObject") 	
	Set carpeta = FSO.GetFolder(path) 	
	Set archivos = carpeta.Files
	for each nombre_archivo in archivos
		sFichero = path & nombre_archivo.name	
	  	fso.DeleteFile sFichero,true		
	next%>	
	{"state": 200, "message": "Eliminacion de archivo correcta","data": null}	