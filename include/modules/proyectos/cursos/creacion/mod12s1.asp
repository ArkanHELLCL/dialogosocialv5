<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if	
	PRY_Id							= request("PRY_Id")
	PRY_Identificador				= request("PRY_Identificador")
	
	USR_IdRevisor			        = request("USR_IdRevisor")
	USR_IdEjecutor			        = request("USR_IdEjecutor")
	LIN_Id				            = request("LIN_Id")
	COM_Id 			                = request("COM_Id")	
	PRY_Nombre		                = LimpiarUrl(request("PRY_Nombre"))
	PRY_DireccionEjecucion          = LimpiarUrl(request("PRY_DireccionEjecucion"))
	PRY_MontoAdjudicado             = LimpiarUrl(request("PRY_MontoAdjudicado"))
	PRY_HorasPedagogicasMin			= request("PRY_HorasPedagogicasMin")
	PRY_IdLicitacion				= LimpiarUrl(request("PRY_IdLicitacion"))
	PRY_EmpresaEjecutora			= LimpiarUrl(request("PRY_EmpresaEjecutora"))
	Step							= CInt(request("Step"))
	PRY_NombreLicitacion			= LimpiarUrl(request("PRY_NombreLicitacion"))
	PRY_CodigoAsociado				= request("PRY_CodigoAsociado")
	MET_Id							= request("MET_Id")
	EME_Id							= request("EME_Id")
	PRY_UrlClase					= request("PRY_UrlClase")
	PRY_NumAnoExperiencia			= request("PRY_NumAnoExperiencia")
	PRY_ObjetivoGeneral				= LimpiarUrl(request("PRY_ObjetivoGeneral"))
	PRY_PorcentajeMinOnline			= request("PRY_PorcentajeMinOnline")
	PRY_PorcentajeMinPresencial		= request("PRY_PorcentajeMinPresencial")
	
	REG_Id							= request("REG_Id")
	
	if(COM_Id="") then
		COM_Id=(REG_Id * 1000) + 101
	end if
	if(PRY_CodigoAsociado)="" then
		PRY_CodigoAsociado="NULL"
	end if
	if PRY_PorcentajeMinOnline="" then
		PRY_PorcentajeMinOnline = "NULL"
	end if
	if PRY_PorcentajeMinPresencial="" then
		PRY_PorcentajeMinPresencial = "NULL"
	end if
	if PRY_NumAnoExperiencia="" then
		PRY_NumAnoExperiencia = "NULL"
	end if

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if		
	
	xsql = "exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(xsql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		response.Write("503\\Error Conexión 2:" & ErrMsg & "-" & xsql)
		rs.close
		cnn.close
		response.end()
	End If
	if not rs.eof then
		PRY_Step=rs("PRY_Step")
		LFO_Id = rs("LFO_Id")
				
		PRY_CreacionProyectoEstado=rs("PRY_CreacionProyectoEstado")
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if	
	
	if PRY_Step=Step and PRY_CreacionProyectoEstado=0 then
		PRY_Step = PRY_Step + 1	'Siguiente paso
	end if	
	
	datos =  PRY_Id & ",'" & PRY_Identificador & "'," & USR_IdRevisor & "," & USR_IdEjecutor & "," & LIN_Id & "," & COM_Id & ",'" & PRY_Nombre & "','" & PRY_DireccionEjecucion & "'," & PRY_MontoAdjudicado & "," & PRY_HorasPedagogicasMin & ",'" & PRY_IdLicitacion & "'," & PRY_Step & ",'" & PRY_NombreLicitacion & "'," & PRY_CodigoAsociado & "," & EME_Id & "," & MET_Id & ",'" & PRY_UrlClase & "'," & PRY_NumAnoExperiencia & ",'" & PRY_ObjetivoGeneral & "'," & PRY_PorcentajeMinOnline & "," & PRY_PorcentajeMinPresencial & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	sql="exec spProyecto_PersonalizacionModificar " & datos 	
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión 3:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	
	if not rs.eof then		
		response.write("200\\")		
	end if
	
%>