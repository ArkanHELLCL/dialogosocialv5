<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%
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
	order  = CInt(Request("order[0][column]"))
	dir	   = Request("order[0][dir]")
	
	searchTXT = Request("search[value]")
	searchREG = Request("search[regex]")
	
	Dim column(11)
	column(0)="ALU_Rut"
	column(1)="ALU_Nombre"
	column(2)="ALU_ApellidoPaterno"
	column(3)="ALU_ApellidoMaterno"
	column(4)="SEX_Descripcion"
	column(5)="ALU_Mail"
	column(6)="TotalHorasAsistidas"
	column(7)="TES_Descripcion"
	column(8)="CDE_InfoCausaDesercion"
	column(9)="RDE_InfoRazonDesercion"
	column(10)="EST_InfoObservaciones"		
	
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
		LFO_CAlif=rs("LFO_Calif")
	end if
		
	if(searchTXT<>"") then		
		'search = column(1) & " LIKE " & searchTXT & "%"		
		search = searchTXT & "%"
	else
		search=""
	end if
		
	SQLquery="exec [spAlumnoProyecto_Listar] " & PRY_Id & ",'" & search & "'"
	set rs=createobject("ADODB.recordset")
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error [spAlumno_Listar]")
		cnn.close 		
		response.end
	End If	
	rs.CursorType = 1
	rs.CursorLocation = 3
   	rs.Open SQLquery, cnn		
	
	'rs.Sort = "au_lname ASC, au_fname ASC"
	sort = column(CInt(order)) & " " & dir
	rs.Sort = sort
	if(length=0) then
		rs.PageSize     = rs.RecordCount
		rs.AbsolutePage = 1	'mostrarpagina
	else
		rs.PageSize = length 
		rs.AbsolutePage = (start+length)\length		'mostrarpagina
	end if		
	recordsTotal    = rs.RecordCount
	recordsFiltered = rs.RecordCount
			
	cont=1	
	dataAsistencia = "{""draw"":""" & draw & """,""recordsTotal"":""" & recordsTotal & """,""recordsFiltered"":""" & recordsFiltered & """,""sort"":""" & sort & """,""data"":["	
	do While Not rs.EOF	and (contreg < length or length=0)
		TotAsis=rs("TotalHorasAsistidas")										
		'TotAsis=round(rs("TotalHorasAsistidas"),1)		
		if TotAsis>=1 then											
			xTotAsis = TotAsis & "%"
		else
			xTotAsis = "0%"
		end if						
		dataAsistencia = dataAsistencia & "[""" & rs("ALU_Rut") & "-" & rs("ALU_DV") & """,""" & rs("ALU_Nombre") & """,""" & rs("ALU_ApellidoPaterno") & """,""" & rs("ALU_ApellidoMaterno") & """,""" & rs("SEX_Descripcion") & """,""" & rs("ALU_Mail") & """,""" & xTotAsis
				
		CDE_InfoCausaDesercion=""
		RDE_InfoRazonDesercion=""
		EST_InfoObservaciones=""
		
		EstadoAcademico = rs("TES_Descripcion")		'Primer registro, utimo en ingresar
		EstadoAcademicoId = rs("EST_Estado") 
		RDE_InfoRazonDesercion = LimpiarURL(rs("RDE_InfoRazonDesercion"))
		CDE_InfoCausaDesercion = LimpiarURL(rs("CDE_InfoCausaDesercion"))
		EST_InfoObservaciones = LimpiarURL(rs("EST_InfoObservaciones"))
		RDE_InfoRazonId = rs("RDE_InfoRazonId")
		
		dataAsistencia = dataAsistencia & """,""" & EstadoAcademico & """,""" & CDE_InfoCausaDesercion & """,""" & RDE_InfoRazonDesercion & """,""" & EST_InfoObservaciones

		if LFO_Calif=1 then
			sql="exec spNota_PromedioConsultar " & rs("ALU_Rut") & "," & PRY_Id & "," & session("ds5_usrid") & ",'" & PRY_Identificador & "','" &  session("ds5_usrtoken") & "'"
			set rs3 = cnn.Execute(sql)
			on error resume next
			if cnn.Errors.Count > 0 then 
				ErrMsg = cnn.Errors(0).description
				response.write("Error spNota_PromedioConsultar")
				cnn.close 		
				response.end
			End If
			if not rs3.eof then
				iPronot = round(rs3("NOT_Promedio"),1)
			else
				iPronot=0
			end if				
			dataAsistencia = dataAsistencia & """,""" & iPronot
		end if

		if(EstadoAcademicoId<>6) then
			if(mode="mod") then
				desertar = "<i class='fas fa-user-alt-slash aludes text-danger' data-rut='" & rs("ALU_Rut") & "' data-dv='" & rs("ALU_Dv") & "' title='Desertar alumno'></i></i><span style='display:none'>-</span>"
			else
				desertar = "<i class='fas fa-user-alt-slash aludes text-white-50' data-rut='" & rs("ALU_Rut") & "' data-dv='" & rs("ALU_Dv") & "' style='cursor:not-allowed' title='Desertar alumno'></i></i><span style='display:none'>-</span>"
			end if
		else
			if(not isnull(RDE_InfoRazonId)) then
				if(mode="mod") then
					desertar = "<i class='fas fa-user-check aluhab text-success' data-rut='" & rs("ALU_Rut") & "' data-dv='" & rs("ALU_Dv") & "' title='Habilitar Alumno'></i></i><span style='display:none'>Desertado manual</span>"
				else
					desertar = "<i class='fas fa-user-check aluhab text-white-50' data-rut='" & rs("ALU_Rut") & "' data-dv='" & rs("ALU_Dv") & "' title='Habilitar Alumno'></i></i><span style='display:none'>Desertado manual</span>"
				end if
			else
				if(mode="mod") then
					desertar = "<i class='fas fa-ban text-danger' title='Desertado por sistema'></i><span style='display:none'>Desertado por sistema</span>"
				else
					desertar = "<i class='fas fa-ban text-white-50' title='Desertado por sistema'></i><span style='display:none'>Desertado por sistema</span>"
				end if
			end if
		end if						
		dataAsistencia = dataAsistencia & """,""" & desertar  & """]"			
		rs.movenext
		if not rs.eof and (contreg < length or length=0) then
			dataAsistencia = dataAsistencia & ","
		end if		
		contreg=contreg+1
		
	loop	
	dataAsistencia=dataAsistencia & "]" & ",""search"": """ & search & """" & "}"		
	response.write(replace(dataAsistencia,"],]","]]"))
%>