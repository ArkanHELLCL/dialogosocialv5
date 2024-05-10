<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PRY_Id					= request("PRY_Id")
	TIM_Id					= request("TIM_Id")
	'TED_Relator				= LimpiarUrl(request("TED_Relator"))
	TED_Nombre				= LimpiarUrl(request("TED_Nombre"))
	TED_Contenidos			= LimpiarUrl(request("TED_Contenidos"))
	TED_Direccion			= LimpiarUrl(request("TED_Direccion"))
	COM_Id					= request("COM_Id")
	TED_Fecha				= request("TED_Fecha")
	TED_HoraInicio			= request("TED_HoraInicio")
	TED_ActoresConvocados	= LimpiarUrl(request("TED_ActoresConvocados"))
	TED_HoraTermino			= request("TED_HoraTermino")
	REL_Id					= request("REL_Id")
	if(RE_Id="" or IsNULL(REL_Id)) then
		REL_Id="NULL"
	end if
	
	
	datos = PRY_Id & "," & TIM_Id & "," & REL_Id & ",'" & TED_Nombre & "','" & TED_Contenidos & "','" & TED_Direccion & "'," & COM_Id & ",'" & TED_Fecha & "','" & TED_HoraInicio & "','" & TED_HoraTermino & "','" & TED_ActoresConvocados & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 	
		
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if			
	
	sql="exec spTematicaDialogo_Agregar " & datos 
	set rs = cnn.Execute(sql)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If%>	
	{"state": 200, "message": "Grabación de plan de trabajo correcta","data": null}	