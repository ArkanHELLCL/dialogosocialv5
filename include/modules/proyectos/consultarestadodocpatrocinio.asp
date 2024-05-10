<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PAT_Id				= request("PAT_Id")
	PAT_Tipo			= request("PAT_Tipo")
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
	if(PAT_Tipo="SIN") then
		sp="spPatrocinio_Consultar"
		PAT_EstadoRevisado="PAT_EstadoRevisado"
		PAT_EstadoAprobado="PAT_EstadoAprobado"
		PAT_EstadoRechazado="PAT_EstadoRechazado"
	else
		if(PAT_Tipo="EMP") then
			sp="spPatrocinioEmpresa_Consultar"
			PAT_EstadoRevisado="PEM_EstadoRevisado"
			PAT_EstadoAprobado="PEM_EstadoAprobado"
			PAT_EstadoRechazado="PEM_EstadoRechazado"
		else
			if(PAT_Tipo="CIV") then
				sp="spPatrocinioCiviles_Consultar"
				PAT_EstadoRevisado="PCI_EstadoRevisado"
				PAT_EstadoAprobado="PCI_EstadoAprobado"
				PAT_EstadoRechazado="PCI_EstadoRechazado"
			else
				if(PAT_Tipo="GOB") then
					sp="spPatrocinioGobierno_Consultar"
					PAT_EstadoRevisado="PGO_EstadoRevisado"
					PAT_EstadoAprobado="PGO_EstadoAprobado"
					PAT_EstadoRechazado="PGO_EstadoRechazado"
				end if
			end if
		end if
	end if
	sql="exec " & sp & " " & PRY_Id & "," & PAT_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		PAT_EstadoRevisado=rs(PAT_EstadoRevisado)		
		PAT_EstadoAprobado=rs(PAT_EstadoAprobado)			
		PAT_EstadoRechazado=rs(PAT_EstadoRechazado)	
		
		'if(VPR_EstadoSubido="" or IsNull(VPR_EstadoSubido)) then
		''	VPR_EstadoSubido="NULL"		
		'end if
		if(PAT_EstadoRevisado="" or IsNull(PAT_EstadoRevisado) or PAT_EstadoRevisado=0) then
			PAT_EstadoRevisado=0		
		end if
		if(PAT_EstadoAprobado="" or IsNull(PAT_EstadoAprobado) or PAT_EstadoAprobado=0) then
			PAT_EstadoAprobado=0		
		end if
		if(PAT_EstadoRechazado="" or IsNull(PAT_EstadoRechazado) or PAT_EstadoRechazado=0) then
			PAT_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","PAT_EstadoRevisado":<%=PAT_EstadoRevisado%>,"PAT_EstadoAprobado":<%=PAT_EstadoAprobado%>,"PAT_EstadoRechazado":<%=PAT_EstadoRechazado%>}<%	
	
	cnn.close
	set cnn = nothing
%>