<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	tipo=request("type")
	subtipo=request("subtype")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if			
	response.write("200/@/")
	'response.write(tipo & "-" & subtipo)	
	call menu(tipo, subtipo)	
	
	function menu(tipo, subtipo)				
		reportesUrl=array("/estados-de-alumnos","/resumen-redes-de-apoyo")
		reportesNom=array("Estado de Alumnos","Resumen de redes de apoyo")
		
		'reportesLar=4
		reportesLar = UBound(reportesUrl)
		
		mantenedoresUrl=array("/sindicatos","/linea-formativa","/lineas","/usuarios","/afiliacion-central","/rubros","/cursos","/perspectivas","/modulos","/educacion","/nacionalidades","/organizacion","/empresas","/ministerios","/servicios","/nivel-de-dialogo-social","/hitos","/documentos","/departamentos","/organizaciones-civiles","/tipos-de-discapacidad","/tipos-de-trabajador","/ejecutores","/bases","/linea-formativa-licitacion","/numeral-multas","/incumplimiento","/gravedad-incumplimiento","/moneda","/documentos-de-gobierno","/bases-linea-formativa","/beneficiarios","/fondos","/estados-del-beneficiario","/tipos-de-mensajes","/tipos-de-mesas","/tipos-de-adecuaciones","/tipos-de-ejecutor","/unidad-de-medida","/tipos-de-metodologias","/relatores","/festivos","/tramo-etareo")
		mantenedoresNom=array("Sindicatos","Línea Formativa","Líneas","Usuarios","Afiliación Central","Rubros","Cursos","Perspectivas","Módulos","Educacional","Nacionalidades","Organización","Empresas","Ministerios","Servicios","Nivel de Diálogo Social","Hitos","Documentos","Departamentos","Organizaciones Civiles","Tipos de Discapacidad","Tipo de Trabajador","Ejecutores","Bases","Línea Formativa/Licitación","Numeral Multas","Incumplimientos","Gravedad incumplimiento","Monedas","Documentos de Gobierno","Bases/Línea Formativa","Beneficiarios","Fondos","Estados del Beneficiario","Tipos de Mensajes","Tipos de Mesas","Tipos de Adecuaciones","Tipos de Ejecutor","Unidad de Medida","Tipos de Metodologías","Relatores", "Festivos", "Tramos Etarios")
		mantenedoresPer = array("1,2","1","1","1","1,2","1,2","1","1","1","1,2","1,2","1,2","1,2","1,2","1,2","1,2","1","1","1","1,2","1,2","1,2","1,2","1","1","1","1","1","1,2","1,2","1","1,2","1","1","1","1","1","1,2","1","1","1,2","1,2","1,2")
		'mantenedoresLar=22
		mantenedoresLar = UBound(mantenedoresUrl)
		
		item=0
		if(subtipo<>"") then
			subtipo="/" & subtipo
			if tipo="man" then
				for i=0 to mantenedoresLar
					if(mantenedoresUrl(i)=subtipo) then
						item=i
					end if
				next
			end if
			if tipo="rep" then
				for i=0 to reportesLar
					if(reportesUrl(i)=subtipo) then
						item=i
					end if
				next
			end if
		else
			item=0
		end if
		
		param=""
		salida=""
		
		'salida = salida + "<ul class='nav nav-stacked nav-tree' role='tab-list'>"
		'Mantenedores y reportes
		if (session("ds5_usrperfil")<>3) then	'Todos tienen accesos menos el ejecutor, solo el admin tendrá acceso a modificar los mantenerores
			'salida = salida + "<li class='hitos' style='padding-top:15px;opacity:0;visiblity:hidden'></li>"
			salida = salida + "<ul class='nav nav-stacked nav-tree' role='tab-list'>"
			salida = salida + "<li role='presentation' class='category text-primary reportes' style='margin-top: 0;margin-bottom:5px;'><i class='fas fa-angle-up ml-1 repmenu'></i><i class='fas fa-file-invoice' style='padding-right:7px;'></i> Reportes </li>"
			for i=0 to reportesLar
				if(i=item) then
					clase="active"
					clase2="done act"
				else
					clase=""
					clase2="done"
				end if
				salida = salida + "<li role='presentation' class='" & clase & " mnustep reportes' data-url='" & reportesURL(i) & "'><a role='tab' href='#'" & param &"><i class='globo " & clase2 & "'>" & ucase(mid(reportesNom(i),1,1)) & "</i>" & reportesNom(i) & " </a></li>"
			next
			salida = salida + "</ul>"
			
			salida = salida + "<ul class='nav nav-stacked nav-tree' role='tab-list'>"
			'salida = salida + "<li class='reportes' style='padding-top:0px;opacity:0;visiblity:hidden;height:0;'></li>"
			salida = salida + "<li role='presentation' class='category text-primary mantenedores' style='margin-top: 0;'><i class='fas fa-angle-up ml-1 manmenu'></i><i class='fas fa-server' style='padding-right:7px;'></i> Mantenedores </li>"
			
			for i=0 to mantenedoresLar
				perfiles=Split(mantenedoresPer(i),",")							
				allowed=false
				for j=0 to UBound(perfiles)								
					if(CInt(perfiles(j))=session("ds5_usrperfil")) then
						allowed=true
						exit for
					end if
				next

				if(allowed) then
					if(i=item) then
						clase="active"
						clase2="done act"
					else
						clase=""
						clase2="done"
					end if
					salida = salida + "<li role='presentation' class='" & clase & " mnustep mantenedores' style='height:0;padding-top:0;visibility:hidden;opacity:0' data-url='" & mantenedoresURL(i) & "'><a role='tab' href='#'" & param &"><i class='globo " & clase2 & "'>" & ucase(mid(mantenedoresNom(i),1,1)) & "</i>" & mantenedoresNom(i) & " </a></li>"
				end if
			next
			salida = salida + "</ul>"
		end if
				
		'salida = salida + "</ul>"				
				
		response.write(salida)
		'response.write(tipo & "-" & subtipo & "-" & item)	
	end function		
%><%
response.write("/@/" & pryarc)%>