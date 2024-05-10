<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%	
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

	
	Dim column(39)
	column(0)="ALU_Rut"
	column(1)="ALU_Rut"
	column(2)="ALU_Nombre"
	column(3)="ALU_ApellidoPaterno"
	column(4)="ALU_ApellidoMaterno"
	column(5)="NAC_Nombre"
	column(6)="SEX_Descripcion"
	column(7)="ALU_Mail"	
	column(8)="ALU_NombreEmpresa"
	column(9)="ALU_UsuarioEdit"
	column(10)="ALU_Estado"
	column(11)="ALU_Proyectos"
	column(12)="ALU_FechaNacimiento"
	column(13)="ALU_Edad"
	column(14)="ALU_CargoDirectivoEnOrganizacion"
	column(15)="ALU_Discapacidad"
	column(16)="TDI_Nombre"
	column(17)="ALU_ReconocePuebloOriginario"
	column(18)="ALU_PuebloOriginario"
	column(19)="TTR_Nombre"
	column(20)="ALU_DirigenteSindical"
	column(21)="ALU_TiempoDirigenteSindical"
	column(22)="ALU_AccesoInternet"
	column(23)="ALU_DispositivoElectronico"
	column(24)="REG_Nombre"
	column(25)="COM_Nombre"
	column(26)="ALU_Direccion"
	column(27)="ALU_Telefono"
	column(28)="RUB_Nombre"
	column(29)="EDU_Nombre"
	column(30)="ALU_PerteneceSindicato"
	column(31)="ALU_NombreOrganizacion"
	column(32)="ALU_RSU"
	column(33)="ALU_FechaIngreso"
	column(34)="ALU_PermisoCapacitacionEnOrganizacion"
	column(35)="ALU_NombreCargoDirectivo"
	column(36)="ALU_FechaInicioCargoDirectivo"
	column(37)="ALU_CursosFormacionSindicalAnteriormente"
	column(38)="ALU_AnioCursoFormacionSindical"
	column(39)="ALU_InstitucionCursoFormacionSindical"	

	LFO_Id=0
	LFO_Descripcion=""
	LIN_Id=0
	LIN_DEscripcion=""
	APR_FechaEdit=""

	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
	
	set rs = cnn.Execute("exec spProyecto_Listar 1,10," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'")		
	if cnn.Errors.Count > 0 then 
		ErrMsg = cnn.Errors(0).description
		response.write("Error [spProyecto_Listar]")
		cnn.close 		
		response.end
	End If	
	if not rs.eof then
		PRY_Id=rs("PRY_Id")
		PRY_Identificador=rs("PRY_Identificador")
	end if
		
	if(searchTXT<>"") then		
		'search = column(1) & " LIKE " & searchTXT & "%"		
		search = searchTXT & "%"
	else
		search=""
	end if
			
	SQLquery="exec [spAlumno_Listar] -1, '" & search & "'"
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
	Proyectos=0
	databneficiarios = "{""draw"":""" & draw & """,""recordsTotal"":""" & recordsTotal & """,""recordsFiltered"":""" & recordsFiltered & """,""sort"":""" & sort & """,""data"":["	
	do While Not rs.EOF	and (contreg < length or length=0)		
	
		Proyectos = CInt(rs("ALU_Proyectos"))
		if(Proyectos>0) then
			PryTXT = Proyectos & " " & "<i class='fas fa-chevron-down text-secondary verpry' data-toggle='tooltip' title='Ver proyectos'></i>"
		else
			PryTXT = Proyectos & " " & "<i class='fas fa-chevron-down text-white-50' style='cursor:not-allowed'></i>"
		end if
	
		if trim(rs("ALU_Ficha"))<>"" then			
			ALU_Ficha="<i class='fas fa-cloud-download-alt text-primary arcalm' data-arc='" & rs("ALU_Ficha") & "' data-pry='" & PRY_Id & "' data-token='" & PRY_Identificador & "' data-hito='98' data-rut='" & rs("ALU_Rut") &"'></i><span style='display:none'>" & rs("ALU_Ficha") & "</span>"
		else
			ALU_Ficha = "<i class='fas fa-ban text-danger'></i><span style='display:none'>No</span>"
			'ALU_Ficha = "-"
		end if
		THP=""
		PASIS=""
		databneficiarios = databneficiarios & "[""" & rs("ALU_Rut") & """,""" & rs("ALU_Rut") & "-" & rs("ALU_DV") & """,""" & rs("ALU_Nombre") & """,""" & rs("ALU_ApellidoPaterno") & """,""" & rs("ALU_ApellidoMaterno") & """,""" & rs("NAC_Nombre") & """,""" & rs("SEX_Descripcion") & """,""" & rs("ALU_Mail") & """,""" & rs("ALU_NombreEmpresa") & """,""" & rs("ALU_UsuarioEdit") & """,""" & rs("ALU_Estado") & """,""" & PryTXT & " " & ALU_Ficha & """,""" & rs("ALU_FechaNacimiento") & """,""" & rs("ALU_Edad") & """,""" & rs("ALU_CargoDirectivoEnOrganizacion") & """,""" & rs("ALU_Discapacidad") & """,""" & rs("TDI_Nombre") & """,""" & rs("ALU_ReconocePuebloOriginario") & """,""" & rs("ALU_PuebloOriginario") & """,""" & rs("TTR_Nombre") & """,""" & rs("ALU_DirigenteSindical") & """,""" & rs("ALU_TiempoDirigenteSindical") & """,""" & rs("ALU_AccesoInternet") & """,""" & rs("ALU_DispositivoElectronico") & """,""" & rs("REG_Nombre") & """,""" & rs("COM_Nombre") & """,""" & rs("ALU_Direccion") & """,""" & rs("ALU_Telefono") & """,""" & rs("RUB_Nombre") & """,""" & rs("EDU_Nombre") & """,""" & rs("ALU_PerteneceSindicato") & """,""" & rs("ALU_NombreOrganizacion") & """,""" & rs("ALU_RSU") & """,""" & rs("ALU_FechaIngreso") & """,""" & rs("ALU_PermisoCapacitacionEnOrganizacion") & """,""" & rs("ALU_NombreCargoDirectivo") & """,""" & rs("ALU_FechaInicioCargoDirectivo") & """,""" & rs("ALU_CursosFormacionSindicalAnteriormente") & """,""" & rs("ALU_AnioCursoFormacionSindical") & """,""" & rs("ALU_InstitucionCursoFormacionSindical") & """,""" & LIN_Id & """,""" & LIN_Descripcion & """,""" & LFO_Id & """,""" & LFO_Descripcion & """,""" & APR_FechaEdit & """,""" & THP & """,""" & PASIS & """]"	
		
		rs.movenext
		if not rs.eof and (contreg < length or length=0) then
			databneficiarios = databneficiarios & ","
		end if
		contreg=contreg+1
	loop	
	databneficiarios=databneficiarios & "]" & ",""search"": """ & search & """" & "}"
		
	response.write(replace(databneficiarios,"],]","]]"))
%>