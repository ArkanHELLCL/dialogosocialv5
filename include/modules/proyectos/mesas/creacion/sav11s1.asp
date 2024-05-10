<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	USR_IdRevisor			         = request("USR_IdRevisor")
	USR_IdEjecutor			         = request("USR_IdEjecutor")
	LIN_Id				             = request("LIN_Id")
	COM_Id 			                 = request("COM_Id")	
	PRY_Nombre		                 = LimpiarUrl(request("PRY_Nombre"))
	PRY_DireccionEjecucion           = LimpiarUrl(request("PRY_DireccionEjecucion"))
	PRY_MontoAdjudicado              = request("PRY_MontoAdjudicado")			
	'PRY_HorasPedagogicasMin			 = request("PRY_HorasPedagogicasMin")
	PRY_HorasPedagogicasMin			 = 0
	PRY_IdLicitacion				 = LimpiarUrl(request("PRY_IdLicitacion"))
	PRY_EmpresaEjecutora			 = LimpiarUrl(request("PRY_EmpresaEjecutora"))
	PRY_NombreLicitacion			 = LimpiarUrl(request("PRY_NombreLicitacion"))
	PRY_TipoMesa					 = request("PRY_TipoMesa")
	EME_Id							 = request("EME_Id")
	MET_Id							 = request("MET_Id")
	PRY_UrlClase					 = LimpiarUrl(request("PRY_UrlClase"))
	RUB_Id							 = request("RUB_Id")
	TEM_Descripcion					 = LimpiarUrl(request("TEM_Descripcion"))
	PRY_DimensionDialogoSocial		 = LimpiarUrl(request("PRY_DimensionDialogoSocial"))
	PRY_NivelDialogoSocial			 = LimpiarUrl(request("PRY_NivelDialogoSocial"))
	
	REG_Id							 = request("REG_Id")
	
	if(COM_Id="") then
		COM_Id=(REG_Id * 1000) + 101
	end if	
	
	datos =  USR_IdRevisor & "," & USR_IdEjecutor & "," & LIN_Id & "," & COM_Id & ",'" & PRY_Nombre & "','" & PRY_DireccionEjecucion & "'," & PRY_MontoAdjudicado & "," & PRY_HorasPedagogicasMin & "," & PRY_TipoMesa & ",'" & PRY_IdLicitacion & "','" & PRY_NombreLicitacion & "'," & RUB_Id & ",'" & TEM_Descripcion & "'," & EME_Id & "," & MET_Id & ",'" &  PRY_UrlClase & "','" & PRY_DimensionDialogoSocial & "','" & PRY_NivelDialogoSocial & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"		

	sql="exec spProyecto_PersonalizacionMesasAgregar " & datos 

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if		
	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close 			   
		response.Write("503\\Error Conexión:" & ErrMsg & "-" & sql)
	    response.End()
	End If
	
	if not rs.eof then		
		response.write("200\\" & rs("PRY_Id") & "\\" & rs("PRY_Identificador"))		
	end if
	
%>