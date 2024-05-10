<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	splitruta=split(ruta,"/")
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	if(xm="modificar") then
		modo=2
		mode="mod"
	end if
	if(xm="visualizar") then
		modo=4
		mode="vis"
	end if		
	
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
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")		
	end if
		
	set rs = cnn.Execute("exec [spIncumplimientosProyectoResumen_Listar] " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spIncumplimientosProyecto_Listar")
		cnn.close 		
		response.end
	End If	
	
	cont=0
	dataIncumplimientos = "{""data"":["
	do While Not rs.EOF		
		if cont>=1 then
			dataIncumplimientos = dataIncumplimientos & ","				
		end if
		cont = cont + 1		
		Acciones = "<i class='fas fa-chevron-down text-secondary verinc' data-toggle='tooltip' title='Ver modificaciones'></i><span style='display:none'>" & "</span>"				

		dataIncumplimientos = dataIncumplimientos & "[""" & rs("INC_Id") & """,""" & rs("INC_Incumplimiento") & """,""" & rs("GRA_Descripcion") & """,""" & rs("INC_Monto") & """,""" & rs("MON_Descripcion") & """,""" & rs("Veces") & """,""" & rs("Total") & """,""" & rs("TotalAplicado") & """,""" & rs("UME_Descripcion") & """,""" & Acciones & """]"

		rs.movenext
	loop
	dataIncumplimientos=dataIncumplimientos & "]}"
	
	response.write(dataIncumplimientos)
%>