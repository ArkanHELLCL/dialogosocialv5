<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor, Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PRY_Id				= request("PRY_Id")	
	ALU_Rut				= request("ALU_Rut")
	RDE_InfoRazonId		= request("RDE_InfoRazonId")	
	EST_InfoObservaciones = request("EST_InfoObservaciones")
	
	EST_Estado				= 6		'Desercion
	EST_InfoEstadoAcademico	= ""
	EST_SitAcademicaFinal	= ""
			
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	
	sqx="exec [spEstados_Agregar] " & ALU_Rut & "," & PRY_Id & "," & EST_Estado & ",'" & EST_InfoEstadoAcademico & "'," & RDE_InfoRazonId & ",'" & EST_InfoObservaciones & "','" & EST_SitAcademicaFinal & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
	
	set rx = cnn.Execute(sqx)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sqx%>"}<%
		rs.close
		cnn.close
		response.end()
	End If%>	
	{"state": 200, "message": "Grabación de deserción correcta","data": null}