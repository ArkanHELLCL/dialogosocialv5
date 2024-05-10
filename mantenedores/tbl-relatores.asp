<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
		
	set rs = cnn.Execute("exec spRelator_Listar -1")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spRelator_Listar")
		cnn.close 		
		response.end
	End If	
	
	dataRelatores = "{""data"":["
	do While Not rs.EOF
		if rs("REL_Estado")=1 then
			estado = "Activado"
		else
			estado = "Desactivado"
		end if		
				
		set rx = cnn.Execute("exec spRelatorProyecto_Listar " & rs("REL_Id")) 
		on error resume next
		
		Proyectos=0
		do while not rx.eof
			Proyectos=Proyectos+1
			rx.movenext
		loop
		if(Proyectos>0) then
			PryTXT = Proyectos & " " & "<i class='fas fa-chevron-down text-secondary verpry' data-toggle='tooltip' title='Ver proyectos' style='cursor:pointer'></i>"
			Eliminar = " <i class='fas fa-trash text-white-50' style='cursor:not-allowed'></i>"
		else
			PryTXT = Proyectos & " " & "<i class='fas fa-chevron-down text-white-50' style='cursor:not-allowed'></i>"
			Eliminar = " <i class='fas fa-trash text-danger delrel' data-id='" & rs("REL_Id") & "' data-rut='" & rs("REL_Rut") & "'></i>"
		end if
		Ficha=""
		if trim(rs("REL_Adjunto"))<>"" then			
			Ficha=" <i class='fas fa-cloud-download-alt text-primary arcrel' data-arc='" & rs("REL_Adjunto") & "' data-hito='111' data-rut='" & rs("REL_Rut") &"'></i><span style='display:none'>" & rs("REL_Adjunto") & "</span>"
		else
			Ficha = " <i class='fas fa-ban text-danger'></i><span style='display:none'>No</span>"			
		end if
		
		
		acciones = PryTXT & Ficha & Eliminar
	
		dataRelatores = dataRelatores & "[""" & rs("REL_Id") & """,""" & rs("REL_Paterno") & """,""" & rs("REL_Materno") & """,""" & rs("REL_Nombres") & """,""" & rs("REL_Rut") & """,""" & rs("SEX_descripcion") & """,""" & rs("EDU_Nombre") & """,""" & rs("REL_NombreCarrera") & """,""" & estado & """,""" & acciones & """]"
		
		rs.movenext
		if not rs.eof then
			dataRelatores = dataRelatores & ","
		end if
	loop
	dataRelatores=dataRelatores & "]}"
	
	response.write(dataRelatores)
%>