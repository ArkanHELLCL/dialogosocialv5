<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor, administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	PRY_Id          					= Request("PRY_Id")
	PRY_Identificador		    		= Request("PRY_Identificador")
	PRY_RelevanciaTematicaEmpresa      	= LimpiarURL(Request("PRY_RelevanciaTematicaEmpresa"))
	PRY_ProblematicaAsociadaEmpresa     = LimpiarURL(Request("PRY_ProblematicaAsociadaEmpresa"))
	PRY_RelevanciaTematicaGobierno      = LimpiarURL(Request("PRY_RelevanciaTematicaGobierno"))
	PRY_ProblematicaAsociadaGobierno    = LimpiarURL(Request("PRY_ProblematicaAsociadaGobierno"))
	PRY_RelevanciaTematicaSindicato     = LimpiarURL(Request("PRY_RelevanciaTematicaSindicato"))
	PRY_ProblematicaAsociadaSindicato   = LimpiarURL(Request("PRY_ProblematicaAsociadaSindicato"))
	Step								= CInt(request("Step"))
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then	
		PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")
		PRY_Estado=rs("PRY_Estado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		LFO_CAlif=rs("LFO_Calif")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		PRY_Step = rs("PRY_Step")
	end if
	
	if PRY_Step=Step and PRY_InformeConsensosEstado=0 then
		PRY_Step = PRY_Step + 1	'Siguiente paso
	end if
	
	datos = PRY_Id & ",'" & PRY_Identificador & "','" & PRY_RelevanciaTematicaEmpresa & "','" & PRY_ProblematicaAsociadaEmpresa & "','" & PRY_RelevanciaTematicaGobierno & "','" & PRY_ProblematicaAsociadaGobierno & "','" & PRY_RelevanciaTematicaSindicato & "','" & PRY_ProblematicaAsociadaSindicato & "'," & PRY_Step & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'" 	
		
			
	
	sql="exec [spProyectoGrupoFocalMesas_Modificar] " & datos 
	set rs = cnn.Execute(sql)	
	on error resume next
	if cnn.Errors.Count > 0 then
		ErrMsg = cnn.Errors(0).description%>
	   	{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If%>	
	{"state": 200, "message": "Grabación de grupos focales correcta","data": null}	