<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if	
	PRY_Id							 = request("PRY_Id")
	PRY_Identificador				 = request("PRY_Identificador")
	
	USR_IdRevisor			         = request("USR_IdRevisor")
	USR_IdEjecutor			         = request("USR_IdEjecutor")
	LIN_Id				             = request("LIN_Id")
	COM_Id 			                 = request("COM_Id")	
	PRY_Nombre		                 = LimpiarUrl(request("PRY_Nombre"))
	PRY_DireccionEjecucion           = LimpiarUrl(request("PRY_DireccionEjecucion"))
	PRY_MontoAdjudicado              = LimpiarUrl(request("PRY_MontoAdjudicado"))
	'PRY_HorasPedagogicasMin			 = request("PRY_HorasPedagogicasMin")
	PRY_HorasPedagogicasMin			 = 0
	PRY_IdLicitacion				 = LimpiarUrl(request("PRY_IdLicitacion"))
	PRY_EmpresaEjecutora			 = LimpiarUrl(request("PRY_EmpresaEjecutora"))
	Step							 = CInt(request("Step"))
	PRY_NombreLicitacion			 = LimpiarUrl(request("PRY_NombreLicitacion"))
	PRY_TipoMesa					 = request("PRY_TipoMesa")
	if(PRY_TipoMesa="" or IsNULL(PRY_TipoMesa)) then
		PRY_TipoMesa="NULL"
	end if
	EME_Id							 = request("EME_Id")
	MET_Id							 = request("MET_Id")
	PRY_UrlClase					 = request("PRY_UrlClase")
	TEM_Descripcion					 = LimpiarUrl(request("TEM_Descripcion"))
	RUB_Id							 = request("RUB_Id")
	if(RUB_Id="") then
		RUB_Id="NULL"
	end if
	PRY_DimensionDialogoSocial		 = LimpiarUrl(request("PRY_DimensionDialogoSocial"))
	PRY_NivelDialogoSocial			 = LimpiarUrl(request("PRY_NivelDialogoSocial"))
	
	REG_Id							 = request("REG_Id")
	
	if(COM_Id="") then
		COM_Id=(REG_Id * 1000) + 101
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
	
	datos =  PRY_Id & ",'" & PRY_Identificador & "'," & USR_IdRevisor & "," & USR_IdEjecutor & "," & LIN_Id & "," & COM_Id & ",'" & PRY_Nombre & "','" & PRY_DireccionEjecucion & "'," & PRY_MontoAdjudicado & "," & PRY_HorasPedagogicasMin & "," & PRY_TipoMesa & ",'" & PRY_IdLicitacion & "'," & PRY_Step & ",'" & PRY_NombreLicitacion & "'," & EME_Id & "," & MET_Id & ",'" & PRY_UrlClase & "'," & RUB_Id & ",'" & TEM_Descripcion & "','" & PRY_DimensionDialogoSocial & "','" & PRY_NivelDialogoSocial & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	sql="exec spProyecto_PersonalizacionMesasModificar " & datos 	
	
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