<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	PRY_Id=request("PRY_Id")
	mode=request("mode")
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	

	set rs=cnn.execute("spProyecto_Consultar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	if not rs.eof then
		PRY_InformeFinalAceptado=rs("PRY_InformeFinalAceptado")
		if(PRY_InformeFinalAceptado="" or IsNULL(PRY_InformeFinalAceptado)) then
			PRY_InformeFinalAceptado=false
		end if
	end if
		
	set rs=cnn.execute("spPresupuesto_Listar " & PRY_Id)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		'response.write ErrMsg & " strig= " & sq			
		cnn.close 			   
		Response.end()
	End If
	dataPresupuestos = "{""data"":["
	portot=0
	portotcan=0
	do While Not rs.EOF
		if(rs("PRE_EstadoCuota")=1) then
			portotcan=portotcan+rs("PRE_PorcentajeMonto")
		end if
		portot=portot+rs("PRE_PorcentajeMonto")
		if(rs("PRE_EstadoCuota")=1) then
			estado="Cancelada"
		else
			estado="Pendiente"
		end if
		if trim(rs("PRE_Adjunto"))<>"" then
			Bajar="<i class='fas fa-cloud-download-alt text-primary downloadFile' data-pre='" & rs("PRE_Id") & "' data-pry='" & PRY_Id & "' data-toggle='tooltip' title='Bajar adjuntos' data-num='" & rs("PRE_NumCuota") & "'></i>"
		else
			Bajar="<i class='fas fa-cloud-download-alt text-50-white' style='cursor:not-allowed'></i>"
		end if
		if(session("ds5_usrperfil")<>3 and session("ds5_usrperfil"))<>4 and not PRY_InformeFinalAceptado and (rs("PRE_EstadoCuota")<>1) then										
			dataPresupuestos = dataPresupuestos  & "[""" & rs("PRE_Id") & """,""" & rs("LFH_HitoDescripcion") & """,""" & rs("PRE_NumCuota") & """,""" & rs("PRE_PorcentajeMonto") & """,""" & rs("PRE_MontoCuota") & """,""" & estado & """,""" & rs("PRE_MontoFactura") & """,""" & rs("PRE_FechaFactura") & """,""" & rs("PRE_NumFactura") & """,""" & rs("PRE_FechaPagoCuota") & """,""" & Bajar & " <i class='fas fa-trash-alt text-danger delpre' data-pre='" & rs("PRE_Id") & "' data-pry='" & PRY_Id & "' data-toggle='tooltip' title='Eliminar cuota' data-num='" & rs("PRE_NumCuota") & "'></i>""]"
		else										
			dataPresupuestos = dataPresupuestos  & "[""" & rs("PRE_Id") & """,""" & rs("LFH_HitoDescripcion") & """,""" & rs("PRE_NumCuota") & """,""" & rs("PRE_PorcentajeMonto") & """,""" & rs("PRE_MontoCuota") & """,""" & estado & """,""" & rs("PRE_MontoFactura") & """,""" & rs("PRE_FechaFactura") & """,""" & rs("PRE_NumFactura") & """,""" & rs("PRE_FechaPagoCuota") & """,""" & Bajar & """]"
		end if												
		rs.movenext
		if not rs.eof then
			dataPresupuestos = dataPresupuestos & ","
		end if
	loop
	dataPresupuestos=dataPresupuestos & "],""PorTot"":""" & portot & """,""PorTotCan"":""" & portotcan & """}"
	rs.close
	
	response.write(dataPresupuestos)
%>