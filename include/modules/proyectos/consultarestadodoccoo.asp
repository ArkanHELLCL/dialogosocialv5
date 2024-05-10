<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	COO_Id				= request("COO_Id")
	COO_Tipo			= request("COO_Tipo")
	PRY_Id				= request("PRY_Id")

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if
	if(COO_Tipo="TRA") then
		sp="spCoordinacionTrabajadores_Consultar"
		COO_EstadoRevisado="CTR_EstadoRevisado"
		COO_EstadoAprobado="CTR_EstadoAprobado"
		COO_EstadoRechazado="CTR_EstadoRechazado"
	else
		if(COO_Tipo="EMP") then
			sp="spCoordinacionEmpleadores_Consultar"
			COO_EstadoRevisado="CEM_EstadoRevisado"
			COO_EstadoAprobado="CEM_EstadoAprobado"
			COO_EstadoRechazado="CEM_EstadoRechazado"
		else			
            if(COO_Tipo="GOB") then
                sp="spCoordinacionGobierno_Consultar"
                COO_EstadoRevisado="CGO_EstadoRevisado"
                COO_EstadoAprobado="CGO_EstadoAprobado"
                COO_EstadoRechazado="CGO_EstadoRechazado"
            end if			
		end if
	end if
	sql="exec " & sp & " " & COO_Id & "," & PRY_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		COO_EstadoRevisado=rs(COO_EstadoRevisado)		
		COO_EstadoAprobado=rs(COO_EstadoAprobado)			
		COO_EstadoRechazado=rs(COO_EstadoRechazado)	
		
		'if(VPR_EstadoSubido="" or IsNull(VPR_EstadoSubido)) then
		''	VPR_EstadoSubido="NULL"		
		'end if
		if(COO_EstadoRevisado="" or IsNull(COO_EstadoRevisado) or COO_EstadoRevisado=0) then
			COO_EstadoRevisado=0		
		end if
		if(COO_EstadoAprobado="" or IsNull(COO_EstadoAprobado) or COO_EstadoAprobado=0) then
			COO_EstadoAprobado=0		
		end if
		if(COO_EstadoRechazado="" or IsNull(COO_EstadoRechazado) or COO_EstadoRechazado=0) then
			COO_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","COO_EstadoRevisado":<%=COO_EstadoRevisado%>,"COO_EstadoAprobado":<%=COO_EstadoAprobado%>,"COO_EstadoRechazado":<%=COO_EstadoRechazado%>}<%	
	
	cnn.close
	set cnn = nothing
%>