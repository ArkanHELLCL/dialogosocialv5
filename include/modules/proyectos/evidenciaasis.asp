<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	PRY_Id = request("PRY_Id")
	PRY_Identificador = request("PRY_Identificador")
	EVI_Hito = 95
	PLN_Sesion = request("PLN_Sesion")
	mode = request("mode")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
		
	set rs = cnn.Execute("exec spEvidenciaAsistencia_Consultar " & PRY_Id & ",'" & PRY_Identificador & "'," & EVI_Hito & "," & PLN_Sesion)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("spEvidenciaAsistencia_Consultar")
		cnn.close 		
		response.end
	End If	
	
	dataEvidencia = "{""data"":["
	if Not rs.EOF then
		colorup="text-white-50"
		disabledup="disabled"
		cursorup="not-allowed"
		tooltipup=""

		colordw="text-success"
		disableddw=""
		cursordw="pointer"
		tooltipdw="Bajar Evidencia de " & rs("TEM_Nombre")

		colordel="text-danger"
		disableddel=""
		cursordel="pointer"
		tooltipdel="Eliminar Evidencia de " & rs("TEM_Nombre")						

		
		background="transparent"
		
		if(mode="mod") then
			dataEvidencia = dataEvidencia & "[""" & "<i class='fas fa-cloud-upload-alt upload " & colorup & "' style='cursor:" & cursorup & "' title='" & tooltipup & "' id='upd_evi-" & rs("PLN_Sesion") & "' name='upd_evi-" & rs("PLN_Sesion") & "' data-modulo='" & rs("PLN_Sesion") & "' data-mode='upload' data-modulodes='" & rs("TEM_Nombre") & "' " & disabledup & "' data-sesion='" & rs("PLN_Sesion") & "'></i>"
		else
			dataEvidencia = dataEvidencia & "[""" & "<i class='fas fa-cloud-upload-alt text-white-50' style='';cursor:not-allowed' disabled></i>"
		end if
		dataEvidencia = dataEvidencia & " <i class='fas fa-cloud-download-alt download " & colordw & "' style='cursor:" & cursordw & "' title='" & tooltipdw & "' id='dwn_evi-" & rs("PLN_Sesion") & "' name='dwn_evi-" & rs("PLN_Sesion") & "' data-modulo='" & rs("PLN_Sesion") & "' data-mode='download' data-modulodes='" & rs("TEM_Nombre") & "' " & disableddw & " data-sesion='" & rs("PLN_Sesion") & "' data-arc='" & rs("EVI_Nombre") & "'></i><span style='display:none'>" & rs("EVI_Nombre") & "</span>"
		
		if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=3) and (mode="mod") then
			dataEvidencia = dataEvidencia & " <i class='fas fa-trash delete " & colordel & "' style='cursor:" & cursordel & ">' title='" & tooltipdel & "' id='del_evi-" & rs("PLN_Sesion") & "' name='del_evi-" & rs("PLN_Sesion") & "' data-modulo='" & rs("PLN_Sesion") & "' data-mode='delete' data-modulodes='" & rs("TEM_Nombre") & "' " & disableddel & " data-sesion='" & rs("PLN_Sesion") & "'></i>"
		else
			dataEvidencia = dataEvidencia & " <i class='fas fa-trash text-white-50>' style='cursor:not-allowed' disabled></i>"
		end if		
	
		dataEvidencia = dataEvidencia & """]"
	else
		colorup="text-primary"
		disabledup=""
		cursorup="pointer"
		tooltipup="Subir Evidencia"

		colordw="text-white-50"
		disableddw="disabled"
		cursordw="not-allowed"
		tooltipdw=""

		colordel="text-white-50"
		disableddel="disabled"
		cursordel="not-allowed"
		tooltipdel=""
		functiondel=""
		
		background="transparent"
		
		if(mode="mod") then
			dataEvidencia = dataEvidencia & "[""" & "<i class='fas fa-cloud-upload-alt upload " & colorup & "' style='cursor:" & cursorup & "' title='" & tooltipup & "' id='upd_evi-" & PLN_Sesion & "' name='upd_evi-" & PLN_Sesion & "' data-modulo='" & PLN_Sesion & "' data-mode='upload' data-modulodes='' " & disabledup & "' data-sesion='" & PLN_Sesion & "'></i>"
		else
			dataEvidencia = dataEvidencia & "[""" & "<i class='fas fa-cloud-upload-alt text-white-50' style='';cursor:not-allowed' disabled></i>"
		end if		
		dataEvidencia = dataEvidencia & " <i class='fas fa-cloud-download-alt text-white-50' style='';cursor:not-allowed' disabled></i>"		
		dataEvidencia = dataEvidencia & " <i class='fas fa-trash text-white-50>' style='cursor:not-allowed' disabled></i>"
			
		dataEvidencia = dataEvidencia & """]"
	end if
	dataEvidencia=dataEvidencia & "]}"
	
	response.write(dataEvidencia)
%>