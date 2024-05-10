<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<% Response.Buffer = False 
   Server.ScriptTimeout = 36000 %>
<%
	if(session("ds5_usrperfil")=5) then	'Adminsitrativo
	   response.Write("403\\Error Perfil no autorizado")
	   response.End() 
	end if
	splitruta=split(ruta,"/")
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	if(xm="modificar") then
		modo=2
		mode="mod"
	end if
	if(xm="visualizar") or session("ds5_usrperfil")=2 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5 then
		modo=4
		mode="vis"
	end if		
	
	if(Request("start")<>"" and not IsNULL(Request("start")) and Request("start")<>"NaN") then
		start  = CInt(Request("start"))
	else
		start  = 0
	end if
	
	'length = CInt(Request("length"))
	'draw   = CInt(Request("draw"))
	'search = Request("search")
	'order  = CInt(Request("order[0][column]"))
	'dir	   = Request("order[0][dir]")
	
	'searchTXT = Request("search[value]")
	'searchREG = Request("search[regex]")
	
	if(searchTXT<>"") then		
		'search = column(1) & " LIKE " & searchTXT & "%"		
		search = searchTXT & "%"
	else
		search=""
	end if
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503//Error Conexión 1:" & ErrMsg)
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then
		PRY_InformeInicioEstado=rs("PRY_InformeInicioEstado")
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_InformeInicioEstado		= rs("PRY_InformeInicioEstado")		
		PRY_InformeFinalEstado		= rs("PRY_InformeFinalEstado")
		PRY_Identificador			= rs("PRY_Identificador")
		PRY_Estado					= rs("PRY_Estado")
		LFO_Id						= rs("LFO_Id")
		LIN_DiasIngresoAsistencia	= rs("LIN_DiasIngresoAsistencia")
	end if
	if(PRY_InformeFinalEstado="" or IsNULL(PRY_InformeFinalEstado)) then
		PRY_InformeFinalEstado=0
	end if
	if(LIN_DiasIngresoAsistencia="" or IsNULL(LIN_DiasIngresoAsistencia)) then
		LIN_DiasIngresoAsistencia=365
	end if		

	sql="exec [spAsistenciaRutPlanificacion_Listar] " & PRY_Id & ",'" & PRY_Identificador & "'"
	set rs3 = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		cnn.close
	   	response.Write("503//Error Conexión 1:" & ErrMsg)
	   	response.End() 
	End If	

	sql="exec spFecha_Obtener"
	set rs4 = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		cnn.close
	   	response.Write("503//Error Conexión 1:" & ErrMsg)
	   	response.End() 
	End If	
	dia=trim(rs4("dia"))
	if len(dia)=1 then
		dia="0" & dia
	end if
	mes=trim(rs4("mes"))
	if len(mes)=1 then
		mes="0" & mes
	end if		
	ano=trim(rs4("año"))
	FechaHoySQL = ano & "-" & mes & "-" & dia	
	DiasMaximos = LIN_DiasIngresoAsistencia
	
	rs4.close
		
	'set rs=createobject("ADODB.recordset")
	'rs.CursorType = 1
	'rs.CursorLocation = 3
	'rs.Open SQLquery, cnn		

	'sort = column(CInt(order)) & " " & dir
	'rs.Sort = sort
	'if(length=0) then
	''	rs.PageSize     = rs.RecordCount
	''	rs.AbsolutePage = 1	'mostrarpagina
	'else
	''	rs.PageSize = length 
	''	rs.AbsolutePage = (start+length)\length		'mostrarpagina
	'end if		
	'recordsTotal    = rs.RecordCount
	'recordsFiltered = rs.RecordCount	
	
	cont=0	
	ALU_Rut=0	
	vacio = false
	dataAsistencia = "{""data"":["
	if rs3.eof then
		vacio = true
	end if
	do while not rs3.eof					
		if(rs3("ALU_Rut")<>ALU_Rut) then		
			if(cont=1) then
				dataAsistencia = dataAsistencia & "],"
			end if
			cont=1			
			TotAsis=round(rs3("TotalHorasAsistidas"),1)

			if TotAsis>=1 then											
				aluasis = TotAsis & "%"
			else
				aluasis = "0%"
			end if
			if(rs3("EST_Estado")=6) then
				colorx="rgba(217, 83, 79, .3)"
				colory="red"
			else
				colorx="transparent"
				colory=""
			end if
			
			dataAsistencia = dataAsistencia & "[""" & " " & """,""" & rs3("ALU_ApellidoPaterno") & " " & rs3("ALU_Nombre") & """,""" & rs3("ALU_Rut") & "-" & rs3("ALU_Dv") & """,""" & rs3("TES_Descripcion") & """,""" & aluasis & """"
			p=0
			TotAsis=0
		else

		end if
		Dias = rs3("DiasHabiles")
		dataAsistencia = dataAsistencia & ","
		if not isnull(rs3("ASI_Asistio")) then								
			if (Dias<=DiasMaximos and Dias>=0 and rs3("EST_Estado")<>6) and (session("ds5_usrperfil")<>2 and session("ds5_usrperfil")<>4 and session("ds5_usrperfil")<>5) then
				if rs3("ASI_Asistio")=1 or rs3("ASI_Justifica") then
					TotAsis=TotAsis+1
					if rs3("ASI_Justifica") then														
						dataAsistencia = dataAsistencia & """<div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-indigo'><input id='S-" & rs3("PLN_Sesion") & "R-" & rs3("ALU_Rut") & "' name='S-" & rs3("PLN_Sesion") & "R-" & rs3("ALU_Rut") & "' type='checkbox' checked disabled='disabled' data-rut='" & rs3("ALU_Rut") & "' data-sesion='" & rs3("PLN_Sesion") & "'> <span class='checkbox'></span></label></div>"""
					else
						dataAsistencia = dataAsistencia & """<div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-green'><input id='S-" & rs3("PLN_Sesion") & "R-" & rs3("ALU_Rut") & "' name='S-" & rs3("PLN_Sesion") & "R-" & rs3("ALU_Rut") & "' type='checkbox' checked data-rut='" & rs3("ALU_Rut") & "' data-sesion='" & rs3("PLN_Sesion") & "'> <span class='checkbox'></span></label></div>"""
					end if
				else
					dataAsistencia = dataAsistencia & """<div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-green'><input id='S-" & rs3("PLN_Sesion") & "R-" & rs3("ALU_Rut") & "' name='S-" & rs3("PLN_Sesion") & "R-" & rs3("ALU_Rut") & "' type='checkbox' data-rut='" & rs3("ALU_Rut") & "' data-sesion='" & rs3("PLN_Sesion") & "'> <span class='checkbox'></span></label></div>"""
				end if
			else													
				if CInt(rs3("ASI_Asistio"))=1 or rs3("ASI_Justifica") then
					TotAsis=TotAsis+1
					if rs3("ASI_Justifica") then
						chkcolor="indigo"
					else
						chkcolor="amber"
					end if												
					dataAsistencia = dataAsistencia & """<div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-" & chkcolor & "'><input id='S-" & rs3("PLN_Sesion") & "R-" & rs3("ALU_Rut") & "' name='S-" & rs3("PLN_Sesion") & "R-" & rs3("ALU_Rut") & "' type='checkbox' checked disabled='disabled' data-rut='" & rs3("ALU_Rut") & "' data-sesion='" & rs3("PLN_Sesion") & "'> <span class='checkbox'></span></label></div>"""
				else
					dataAsistencia = dataAsistencia & """-"""
				end if
			end if				
		else
			if (Dias<=DiasMaximos and Dias>=0 and rs3("EST_Estado")<>6) then
				dataAsistencia = dataAsistencia & """<div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-green'><input id='S-" & rs3("PLN_Sesion") & "R-" & rs3("ALU_Rut") & "' name='S-" & rs3("PLN_Sesion") & "R-" & rs3("ALU_Rut") & "' type='checkbox' data-rut='" & rs3("ALU_Rut") & "' data-sesion='" & rs3("PLN_Sesion") & "'> <span class='checkbox'></span></label></div>"""
			else
				dataAsistencia = dataAsistencia & """-"""
			end if
		end if
		ALU_Rut=rs3("ALU_Rut")
		rs3.movenext		
	loop
	'leer el ultimo registro solo si no es vacia la lectura
	if(not vacio) then
		dataAsistencia=dataAsistencia & "]"
	end if
	rs3.close
	dataAsistencia=dataAsistencia & "]}"
	response.write(dataAsistencia)%>		