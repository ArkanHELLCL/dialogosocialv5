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
	
	length = CInt(Request("length"))
	draw   = CInt(Request("draw"))
	search = Request("search")
	order  = CInt(Request("order[1][column]"))
	dir	   = Request("order[1][dir]")
	
	searchTXT = Request("search[value]")
	searchREG = Request("search[regex]")
	
	Dim column(5)	
	column(1)="ALU_Nombre"
	column(2)="ALU_Rut"
	column(3)="TES_Descripcion"
	column(4)="TotalHorasAsistidas"
	
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

	sql="exec [spAsistenciaRutPlanificacionPIVOT_Listar] " & PRY_Id & ",'" & PRY_Identificador & "','" & search & "'"
	set rs3=createobject("ADODB.recordset")
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error [spAsistenciaRutPlanificacionPIVOT_Listar]")
		cnn.close 		
		response.end
	End If	
	rs3.CursorType = 1
	rs3.CursorLocation = 3
   	rs3.Open sql, cnn		
	
	'rs.Sort = "au_lname ASC, au_fname ASC"
	sort = column(CInt(order)) & " " & dir
	rs3.Sort = sort
	if(length=0) then
		rs3.PageSize     = rs3.RecordCount
		rs3.AbsolutePage = 1	'mostrarpagina
	else
		rs3.PageSize = length 
		rs3.AbsolutePage = (start+length)\length		'mostrarpagina
	end if		
	recordsTotal    = rs3.RecordCount
	recordsFiltered = rs3.RecordCount
	totFields		= rs3.fields.Count							
	
	dataAsistencia = "{""draw"":""" & draw & """,""recordsTotal"":""" & recordsTotal & """,""recordsFiltered"":""" & recordsFiltered & """,""sort"":""" & sort & """,""totfields"":""" & totFields & """,""data"":["
	
	contreg=1
	cont = 0
	Dim hab(100)
	ReDim hab(totFields)
	
	set rx = cnn.Execute("exec [spFechasSesionesHabilitadasPlanificacionPIVOT_Listar] " & PRY_Id & ",'" & PRY_Identificador & "'")
	on error resume next
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		cnn.close
	   	response.Write("503//Error Conexión 1:" & ErrMsg)
	   	response.End() 
	End If	
	totFieldsx		= rx.fields.Count
	
	if not rx.eof and (totFields-6=totFieldsx) then
		for i = 0 to totFields - 1 
			hab(i)=rx.fields(i).value			
		next
	else
		'response.Write("503//Error totfields : " & totFields & " " & totFieldsx)
		response.write(dataAsistencia & "]}")
	   	response.End() 
	end if 
	vacio = true
	do While Not rs3.eof and (contreg + 1 < (length + 2) or length=0)		
		vacio = false
		if cont=1 then
			dataAsistencia = dataAsistencia & "],"
		end if
		cont=1						

		dataAsistencia = dataAsistencia & "[""" & " " & """,""" & rs3("ALU_Nombre") & " " & rs3("ALU_ApellidoPAterno") & """,""" & rs3("ALU_Rut") & """,""" & rs3("TES_Descripcion") & """,""" & rs3("TotalHorasAsistidas") & "%" & """"

		for i = 6 to totFields - 1 
			if(hab(i-6)=1 and rs3("EST_Estado")<>6) and (session("ds5_usrperfil")<>2 and session("ds5_usrperfil")<>4 and session("ds5_usrperfil")<>5 and PRY_InformeFinalEstado<>1) then	'Habilitado'
				if(rs3.fields(i).value=1) then	'Asistio'
					dataAsistencia = dataAsistencia & ",""<div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-green'><input id='S-" & rs3.fields(i).name & "R-" & rs3("ALU_Rut") & "' name='S-" & rs3.fields(i).name & "R-" & rs3("ALU_Rut") & "' type='checkbox' checked data-rut='" & rs3("ALU_Rut") & "' data-sesion='" & rs3.fields(i).name & "'> <span class='checkbox'></span></label></div>"""												
				else	
					if(rs3.fields(i).value=2) then	'Justifico
						dataAsistencia = dataAsistencia & ",""<div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-indigo'><input id='S-" & rs3.fields(i).name & "R-" & rs3("ALU_Rut") & "' name='S-" & rs3.fields(i).name & "R-" & rs3("ALU_Rut") & "' type='checkbox' checked disabled='disabled' data-rut='" & rs3("ALU_Rut") & "' data-sesion='" & rs3.fields(i).name & "'> <span class='checkbox'></span></label></div>"""
					else
						dataAsistencia = dataAsistencia & ",""<div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-green'><input id='S-" & rs3.fields(i).name & "R-" & rs3("ALU_Rut") & "' name='S-" & rs3.fields(i).name & "R-" & rs3("ALU_Rut") & "' type='checkbox' data-rut='" & rs3("ALU_Rut") & "' data-sesion='" & rs3.fields(i).name & "'> <span class='checkbox'></span></label></div>"""
					end if
				end if
			else	'No habilitado
				if(rs3.fields(i).value<>0) then	'Asistio o Justifico
					if(rs3.fields(i).value=2) then	'Justifico
						chkcolor="indigo"
					else
						chkcolor="amber"
					end if
					dataAsistencia = dataAsistencia & ",""<div class='rkmd-checkbox checkbox-rotate checkbox-ripple'><label class='input-checkbox checkbox-" & chkcolor & "'><input id='S-" & rs3.fields(i).name & "R-" & rs3("ALU_Rut") & "' name='S-" & rs3.fields(i).name & "R-" & rs3("ALU_Rut") & "' type='checkbox' checked disabled='disabled' data-rut='" & rs3("ALU_Rut") & "' data-sesion='" & rs3.fields(i).name & "'> <span class='checkbox'></span></label></div>"""
				else
					dataAsistencia = dataAsistencia & ",""-"""
				end if
			end if

		next
		
		rs3.movenext				
		contreg=contreg+1
	loop
	rs3.close
	if(vacio) then
		dataAsistencia=dataAsistencia & "]}"
	else
		dataAsistencia=dataAsistencia & "]]}"
	end if
	
	response.write(dataAsistencia)%>		