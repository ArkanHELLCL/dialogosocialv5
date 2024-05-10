<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Ejecutor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%		
		response.End() 			   
	end if		
	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")
	
	TIP_Id				= 5	'Observaciones al informe INICIO
	MEN_Archivo			= ""	'Sin adjuntos
	MEN_Texto			= request("MEN_TextoRechazo") & " (ESCUELA)"
	MEN_Archivo			= ""

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	sql="exec spProyectoInformeInicio_Abrir " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		rs.close
		cnn.close
		response.end()
	End If
	
	sql = "exec spMensaje_Agregar " & TIP_Id & ",'" & MEN_Texto & "','" & MEN_Archivo & "'," & PRY_Id &  ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
		rs.close
		cnn.close
		response.end()
	End If%>
	   
	{"state": 200, "message": "Informe Incio correctamente rechazado","data": null}<%
	
	cnn.close
	set cnn = nothing
%>