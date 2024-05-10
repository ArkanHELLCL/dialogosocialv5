<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	GRP_Id				= request("GRP_Id")
	GRP_Tipo			= request("GRP_Tipo")
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
	if(GRP_Tipo="SIN") then
		sp="spPrioridadSindicato_Consultar"
		GRP_EstadoRevisado="PRS_EstadoRevisado"
		GRP_EstadoAprobado="PRS_EstadoAprobado"
		GRP_EstadoRechazado="PRS_EstadoRechazado"
	else
		if(GRP_Tipo="EMP") then
			sp="spPrioridadEmpresa_Consultar"
			GRP_EstadoRevisado="PRE_EstadoRevisado"
			GRP_EstadoAprobado="PRE_EstadoAprobado"
			GRP_EstadoRechazado="PRE_EstadoRechazado"
		else			
            if(GRP_Tipo="GOB") then
                sp="spPrioridadGobierno_Consultar"
                GRP_EstadoRevisado="PRG_EstadoRevisado"
                GRP_EstadoAprobado="PRG_EstadoAprobado"
                GRP_EstadoRechazado="PRG_EstadoRechazado"
            end if			
		end if
	end if
	sql="exec " & sp & " " & GRP_Id
			
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
		rs.close
		cnn.close
		response.end()
	End If
		
	if not rs.eof then
		GRP_EstadoRevisado=rs(GRP_EstadoRevisado)		
		GRP_EstadoAprobado=rs(GRP_EstadoAprobado)			
		GRP_EstadoRechazado=rs(GRP_EstadoRechazado)	
		
		'if(VPR_EstadoSubido="" or IsNull(VPR_EstadoSubido)) then
		''	VPR_EstadoSubido="NULL"		
		'end if
		if(GRP_EstadoRevisado="" or IsNull(GRP_EstadoRevisado) or GRP_EstadoRevisado=0) then
			GRP_EstadoRevisado=0		
		end if
		if(GRP_EstadoAprobado="" or IsNull(GRP_EstadoAprobado) or GRP_EstadoAprobado=0) then
			GRP_EstadoAprobado=0		
		end if
		if(GRP_EstadoRechazado="" or IsNull(GRP_EstadoRechazado) or GRP_EstadoRechazado=0) then
			GRP_EstadoRechazado=0		
		end if
	end if%>	
	{"state": 200, "message": "Ejecución exitosa","GRP_EstadoRevisado":<%=GRP_EstadoRevisado%>,"GRP_EstadoAprobado":<%=GRP_EstadoAprobado%>,"GRP_EstadoRechazado":<%=GRP_EstadoRechazado%>}<%	
	
	cnn.close
	set cnn = nothing
%>