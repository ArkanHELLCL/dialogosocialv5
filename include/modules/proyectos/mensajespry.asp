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
		PRY_InformeSistematizacionEstado=rs("PRY_InformeSistematizacionEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		PRY_Carpeta=rs("PRY_Carpeta")
		carpetapry = mid(PRY_Carpeta,2,len(PRY_Carpeta)-2)
		LFO_Id=rs("LFO_Id")
	end if
	if(LFO_Id=10 or LFO_Id=12) then
		PRY_InfFinal = PRY_InformeFinalEstado
	end if
	if(LFO_Id=11) then
		PRY_InfFinal = PRY_InformeSistematizacionEstado
	end if		
	set rs = cnn.Execute("exec spMensajeProyecto_Listar " & PRY_Id & ",'" & PRY_Identificador & "'," & session("ds5_usrid"))
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error spMensajeProyecto_Listar")
		cnn.close 		
		response.end
	End If	
	cont=0	
	dataMensajespry = "{""data"":["
	do While Not rs.EOF		
		vermsg=""
		acciones=""
		if cont=1 then
			dataMensajespry = dataMensajespry & ","				
		end if		
		cont=1
		if(rs("MaxCorrelativo")>0) then
			vermsg="<i class='fas fa-chevron-down text-secondary verrespry' data-toggle='tooltip' title='Ver respuestas'></i>"
		end if			
		if(PRY_InfFinal=0) then
			acciones="<i class='fas fa-reply resppry text-primary' data-id='" & rs("MEN_Id") & "' data-usr='" & rs("USR_Id") & "' data-pry='" & rs("PRY_Id") & "' data-toggle='tooltip' title='Responder mensaje'></i>"
		else
			acciones="<i class='fas fa-reply text-white-50' style='cursor:not-allowed'></i>"
		end if		
		acciones=acciones & vermsg
		dataMensajespry = dataMensajespry & "[""" & rs("MEN_Id") & """,""" & rs("USR_Nombre") & " " & rs("USR_Apellido") & """,""" & rs("TIP_Mensaje") & """,""" & rs("MEN_Texto") & """,""" & rs("MEN_Fecha") & """,""" & acciones & """]"			

		rs.movenext
	loop
	dataMensajespry=dataMensajespry & "]}"
	
	response.write(dataMensajespry)
%>