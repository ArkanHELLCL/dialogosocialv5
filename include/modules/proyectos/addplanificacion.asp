<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if	
	PRY_Id				= request("PRY_Id")
	PRY_Identificador	= request("PRY_Identificador")	
	
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	sqx="exec spProyecto_Consultar " & PRY_Id
	set rx = cnn.Execute(sqx)
	if not rx.eof then
		LIN_AgregaTematica  	= rx("LIN_AgregaTematica")
		PRY_InformeInicioEstado	= rx("PRY_InformeInicioEstado")
		PRY_Estado				= rx("PRY_Estado")
	end if
	
	if (PRY_InformeInicioEstado<>0 or PRY_Estado<>1) then%>
		{"state": 1, "message": "Error estado del proyecto no válido","data": "<%=PRY_Estado%>"}<%
		response.end()
	end if	

	for i=1 to Request.Form("TEM_Id").Count
		if Request.Form("MET_Id")(i)="" or trim(Request.Form("MET_Id")(i)="") then
			MET_Id="null"
		else
			MET_Id=Request.Form("MET_Id")(i)
		end if
		if Request.Form("REL_Id")(i)="" or trim(Request.Form("REL_Id")(i)="") then
			REL_Id="null"
		else
			REL_Id=Request.Form("REL_Id")(i)
		end if
		
		if(Request.Form("TEM_Id")(i)<>"" or Not IsNull(Request.Form("TEM_Id")(i))) and (trim(Request.Form("PLN_Fecha")(i))<>"") and (trim(Request.Form("PLN_HoraInicio")(i))<>"") and (trim(Request.Form("PLN_HoraFin")(i))<>"") and (REL_Id<>"null") and (MET_Id<>"null") then
		
			if(Request.Form("Type")(i)="new") then								
				datos1 =  PRY_Id & "," & Request.Form("TEM_Id")(i) & ",'" & trim(Request.Form("PLN_Fecha")(i)) & "','" & trim(Request.Form("PLN_HoraInicio")(i)) & "','" & trim(Request.Form("PLN_HoraFin")(i)) & "',''," & MET_Id & "," & REL_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"
				
				if Request.Form("Tem")(i)=0 then	
					sql="spPlanificacion_Agregar " & datos1 
				else
					sql="spPlanificacionTematicaProyecto_Agregar " & datos1 
				end if		
				set rs = cnn.Execute(sql)				
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description	   
					cnn.close%>
					{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=datos%>}"<%
					response.End() 			   
				end if
			end if
			if(Request.Form("Type")(i)="old") then		
				datos2 = Request.Form("PLN_Sesion")(i) & "," & PRY_Id & "," & Request.Form("TEM_Id")(i) & ",'" & trim(Request.Form("PLN_Fecha")(i)) & "','" & trim(Request.Form("PLN_HoraInicio")(i)) & "','" & trim(Request.Form("PLN_HoraFin")(i)) & "','',1," & MET_Id & "," & REL_Id & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
								
				if Request.Form("Tem")(i)=0 then	
					sql="spPlanificacion_Modificar " & datos2 
				else
					sql="spPlanificacionProyecto_Modificar " & datos2
				end if		
				set rs = cnn.Execute(sql)			
				if cnn.Errors.Count > 0 then 
					ErrMsg = cnn.Errors(0).description	   
					cnn.close%>
					{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=datos%>"}<%
					response.End() 			   
				end if
			end if
			datos1=""
			datos2=""
		end if
	next%>	
	{"state": 200, "message": "Grabación de planificación correcta","data": null}