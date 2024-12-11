<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%
	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if	
	PRY_Id							 = request("PRY_Id")
	PRY_Identificador				 = request("PRY_Identificador")
	
	PRY_EncargadoProyecto			 = LimpiarUrl(request("PRY_EncargadoProyecto"))
	PRY_EncargadoProyectoMail		 = request("PRY_EncargadoProyectoMail")
	PRY_EncargadoProyectoCelular	 = request("PRY_EncargadoProyectoCelular")
	SEX_IdEncargadoProyecto			 = request("SEX_IdEncargadoProyecto")

	PRY_EncargadoActividades		 = "NULL"
	PRY_EncargadoActividadesMail	 = ""
	PRY_EncargadoActividadesCelular	 = ""
	SEX_IdEncargadoActividades		 = "NULL"
	Step							 = CInt(request("Step"))
	
	
	EDU_IdEncargadoProyecto			 = request("EDU_IdEncargadoProyecto")
	PRY_EncargadoProyectoCarrera	 = LimpiarUrl(request("PRY_EncargadoProyectoCarrera"))

	EDU_IdEncargadoActividades		 = "NULL"
	PRY_EncargadoActividadesCarrera	 = LimpiarUrl(request("PRY_EncargadoActividadesCarrera"))

	PRY_Facilitador					 = LimpiarUrl(request("PRY_Facilitador"))
	PRY_FacilitadorMail				 = request("PRY_FacilitadorMail")
	PRY_FacilitadorCelular			 = request("PRY_FacilitadorCelular")
	SEX_IdFacilitador				 = request("SEX_IdFacilitador")
	PRY_FacilitadorCarrera			 = LimpiarUrl(request("PRY_FacilitadorCarrera"))
	EDU_IdFacilitador				 = request("EDU_IdFacilitador")
	PRY_FacilitidorForEsp			 = request("PRY_FacilitidorForEsp")
	ENC_Adjunto						 = ""
	COR_Adjunto						 = ""

	PRY_EncargadoAudio				 = request("PRY_EncargadoAudio")
	PRY_EncargadoAudioMail			 = request("PRY_EncargadoAudioMail")
	PRY_EncargadoAudioCelular		 = request("PRY_EncargadoAudioCelular")
	SEX_IdEncargadoAudio			 = request("SEX_IdEncargadoAudio")
	PRY_EncargadoAudioCarrera		 = request("PRY_EncargadoAudioCarrera")
	EDU_IdEncargadoAudio			 = request("EDU_IdEncargadoAudio")
	PRY_EncargadoAudioForEsp		 = request("PRY_EncargadoAudioForEsp")
	
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
				
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
	else
		response.Write("2")
		rs.close
		cnn.close
		response.end()
	end if	
	
	if PRY_Step=Step and PRY_InformeInicioEstado=0 then
		PRY_Step = PRY_Step + 1	'Siguiente paso
	end if		 
	
	datos =  PRY_Id & ",'" & PRY_Identificador & "','" & PRY_EncargadoProyecto & "','" & PRY_EncargadoProyectoMail & "','" & PRY_EncargadoProyectoCelular & "','" & SEX_IdEncargadoProyecto & "','" & PRY_EncargadoActividades & "','" & PRY_EncargadoActividadesMail & "','" & PRY_EncargadoActividadesCelular & "'," & SEX_IdEncargadoActividades & "," & PRY_Step & ",'" & ENC_Adjunto & "','" & COR_Adjunto & "'," & EDU_IdEncargadoProyecto & ",'" & PRY_EncargadoProyectoCarrera & "'," & EDU_IdEncargadoActividades & ",'" & PRY_EncargadoActividadesCarrera & "','" & PRY_Facilitador & "','" & PRY_FacilitadorMail & "','" & PRY_FacilitadorCelular & "'," & SEX_IdFacilitador & ",'" & PRY_FacilitadorCarrera & "'," & EDU_IdFacilitador & "," & PRY_FacilitidorForEsp & ",'" & PRY_EncargadoAudio & "','" & PRY_EncargadoAudioMail & "','" & PRY_EncargadoAudioCelular & "'," & SEX_IdEncargadoAudio & ",'" & PRY_EncargadoAudioCarrera & "'," & EDU_IdEncargadoAudio & "," & PRY_EncargadoAudioForEsp & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"

	sql="exec spProyecto_EncargadoAudioRHSModificar " & datos 	
	
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