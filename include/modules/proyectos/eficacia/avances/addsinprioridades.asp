<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PRY_Id          			= Request("PRY_Id")
	PRS_Prioridad		    	= Request("PRS_Prioridad")
	PRS_Problematica      		= LimpiarURL(Request("PRS_Problematica"))
	PRS_ExpectativaSolucion     = LimpiarURL(Request("PRS_ExpectativaSolucion"))
	PRS_Compromiso				= LimpiarURL(Request("PRS_Compromiso"))
	PRS_Verificador				= ""

	datos = PRY_Id & "," & PRS_Prioridad & ",'" & PRS_Problematica & "','" & PRS_ExpectativaSolucion & "','" & PRS_Compromiso & "','" & PRS_Verificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 	
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	sql="exec spPrioridadSindicato_Agregar " & datos 
	set rs = cnn.Execute(sql)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If%>	
	{"state": 200, "message": "Grabación de prioridad correcta","data": null}	