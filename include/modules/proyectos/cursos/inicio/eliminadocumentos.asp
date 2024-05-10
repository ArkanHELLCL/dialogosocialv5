<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	if(session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4) then
		response.Write("403\\Perfil no autorizado")
		response.End() 			   
	end if		
	
	PRY_Id=request("PRY_Id")	
	VPR_Corr=request("VPR_Corr")		
	VER_Corr=request("VER_Corr")
	PRY_Hito=request("PRY_Hito")

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": null}<%
	   response.End() 			   
	end if		
	
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
	   response.End() 			   
	end if
	if not rs.eof then	
		PRY_Identificador=rs("PRY_Identificador")
		LIN_Id=rs("LIN_Id")
		PRY_ObjetivoGeneral=rs("PRY_ObjetivoGeneral")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		LFO_Id=rs("LFO_Id")
	else%>
		{"state": 503, "message": "Error : no se encontraron datos del proyecto,"data": null}<%
		response.End() 
	end if
	
	sql = "exec [spVerificadorProyecto_Eliminar] " & VPR_Corr & "," & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"	
	set rs = cnn.Execute(sql)
	'response.write(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description			
		cnn.close%>
		{"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": <%=sql%>}<%
	    response.End()
	End If
	
	if len(VER_Corr)>1 then
		yVER_Corr=""
		for i=0 to len(VER_Corr)
			if(isnumeric(mid(VER_Corr,i,1))) then
				yVER_Corr=yVER_Corr & mid(VER_Corr,i,1)
			end if
		next
	else
		yVER_Corr=cint(VER_Corr)
	end if	
	carpeta_informe="no_definido"
	if LFO_Id=10 then
		if PRY_Hito=0 then
			carpeta_informe="informecreacion"
		else
			if PRY_Hito=1 then
				carpeta_informe="informeinicio"
			else
				if PRY_Hito=2 then
					carpeta_informe="informeparcial"
				else
					'if PRY_Hito=3 then
					'	carpeta_informe="informedesarrollo"
					'else
						'if PRY_Hito=4 then
						if PRY_Hito=3 then
							carpeta_informe="informefinal"
						else
							carpeta_informe="no_definido"
						end if
					'end if
				end if
			end if
		end if
	else
		if LFO_Id=11 then
			if PRY_Hito=0 then
				carpeta_informe="informecreacionmesa"
			else
				if PRY_Hito=1 then
					carpeta_informe="informeinicialmesa"
				else
					if PRY_Hito=2 then
						carpeta_informe="informeavancesmesa"
					else
						if PRY_Hito=3 then
							carpeta_informe="informesistematizacionmesa"
						else
							carpeta_informe="no_definido"
						end if
					end if
				end if
			end if
		else
			if LFO_Id=12 then
				if PRY_Hito=0 then
					carpeta_informe="informecreacion"
				else
					if PRY_Hito=1 then
						carpeta_informe="informeinicio"
					else			
						if PRY_Hito=2 then
							carpeta_informe="informefinal"
						else						
							carpeta_informe="no_definido"
						end if 
					end if
				end if
			end if
		end if
	end if	
	path="D:\DocumentosSistema\dialogosocial\" & carpetapry & "\" & carpeta_informe & "\documentos\tpo-" & yVER_Corr
		
	dim fs,f
	
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	fs.DeleteFolder path

	set f=nothing
	set fs=nothing					
						
	rs.close%>								
	{"state": 200, "message": "Eliminación de carpeta correcta","data": null}