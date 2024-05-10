<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	PRY_Id		= request("PRY_Id")		
	PRY_Hito	= request("PRY_Hito")
	mode		= request("mode")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then
		PRY_Identificador=rs("PRY_Identificador")
		PRY_Carpeta=rs("PRY_Carpeta")
		LFO_Id=rs("LFO_Id")
		LIN_Id=rs("LIN_Id")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
	end if
	
	set rs = cnn.Execute("exec [spGruposFocalizacionxProyecto_Listar] " & PRY_Id
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spGruposFocalizacionxProyecto_Listar")
		cnn.close 		
		response.end
	End If	
	cont=1
					
	dataDocumentos = "{""data"":["
	do While Not rs.EOF				
		if x=1 then
			dataDocumentos = dataDocumentos & ","				
		end if
		
		data="data-id='" & rs("VER_Corr") & "' data-pry='" & PRY_Id & "'"			
		acciones="<i class='fas fa-cloud-download-alt " & clasedown & " " & colordown & "' style='cursor:" & disableddown & "' title='Bajar documento' " & data & "></i>"
		
		dataDocumentos = dataDocumentos & "[""" & rs("VER_Corr") & """,""" & rs("VER_Descripcion") & """,""" & subido & """,""" & rs("VPR_FechaSubido") & """,""" & rs("VPR_UsuarioSubido")	& """,""" & revisado & """,""" & rs("VPR_FechaRevisado") & """,""" & rs("VPR_UsuarioRevisado") & """,""" & aprobado & """,""" & rs("VPR_FechaAprobado") & """,""" & rs("VPR_UsuarioAprobado") & """,""" & rechazo & """,""" & rs("VPR_FechaRechazado") & """,""" & rs("VPR_UsuarioRechazado") & """,""" & eliminado & """,""" & rs("VPR_FechaEliminado") & """,""" & rs("VPR_UsuarioEliminado")	& """,""" & acciones & """]"			
	
		rs.movenext		
	loop	
	dataDocumentos=dataDocumentos & "]}"
	dataDocumentos=replace(replace(replace(dataDocumentos,",,",","),"[,[","[["),"],]","]]")
	
	response.write(dataDocumentos)
%>