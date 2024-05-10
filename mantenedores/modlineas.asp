<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<!-- #INCLUDE file="functions.inc" -->
<%	
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'ejecutor, Auditor y Administrativo%>
	   {"state": 403, "message": "Perfil no autorizado","data": null}<%
		response.End() 			   
	end if		
	
	LIN_Id      = Request("LIN_Id")
	LIN_Nombre  = LimpiarUrl(Request("LIN_Nombre"))
	LIN_Estado  = Request("LIN_Estado")
	LFO_Id      = Request("LFO_Id")
	Electivos	= Request("LIN_AgregaTematica")
	Hombres		= Request("LIN_Hombres")
	Mujeres		= Request("LIN_Mujer")
	Mixta 		= Request("LIN_Mixta")

	LIN_DiasCierreInformeParcial = Request("LIN_DiasCierreInformeParcial")
	LIN_DiasCierreInformeFinal	 = Request("LIN_DiasCierreInformeFinal")
	LIN_DiasCierreInformeParcial50Ejecucion = Request("LIN_DiasCierreInformeParcial50Ejecucion")
	LIN_DiasCierreInformeFinal100Ejecucion 	= Request("LIN_DiasCierreInformeFinal100Ejecucion")
	LIN_PorcentajeMaxAsistenciaDesercion = Request("LIN_PorcentajeMaxAsistenciaDesercion")
	LIN_PorcentajeMaxAsistenciaReprobacion 	= Request("LIN_PorcentajeMaxAsistenciaReprobacion")
	LIN_DiasIngresoAsistencia = Request("LIN_DiasIngresoAsistencia")
	LIN_PorcentajeMaxAsistenciaInscrito = Request("LIN_PorcentajeMaxAsistenciaInscrito")

	Sindicato 	= Request("LIN_AgregaSindicato")
	Empresa 	= Request("LIN_AgregaEmpresa")
	Gobierno 	= Request("LIN_AgregaGobierno")	
	Civil 		= Request("LIN_AgregaCivil")
	SinVer 		= Request("LIN_AgregaSindicatoVerificador")
	EmpVer 		= Request("LIN_AgregaEmpresaVerificador")
	GobVer 		= Request("LIN_AgregaGobiernoVerificador")
	SocVer 		= Request("LIN_AgregaCivilVerificador")
	

	if Electivos="on" then
		LIN_AgregaTematica=1
	else
		LIN_AgregaTematica=0
	end if
	if Hombres="on" then
		LIN_Hombres=1
	else
		LIN_Hombres=0
	end if
	if Mujeres="on" then
		LIN_Mujeres=1
	else
		LIN_Mujeres=0
	end if
	if Mixta="on" then
		LIN_Mixta=1
	else
		LIN_Mixta=0
	end if

	if Sindicato="on" then
		LIN_AgregaSindicato=1
	else
		LIN_AgregaSindicato=0
	end if
	if Empresa="on" then
		LIN_AgregaEmpresa=1
	else
		LIN_AgregaEmpresa=0
	end if
	if Gobierno="on" then
		LIN_AgregaGobierno=1
	else
		LIN_AgregaGobierno=0
	end if
	if Civil="on" then
		LIN_AgregaCivil=1
	else
		LIN_AgregaCivil=0
	end if
	if SocVer="on" then
		LIN_AgregaCivilVerificador=1
	else
		LIN_AgregaCivilVerificador=0
	end if
	if GobVer="on" then
		LIN_AgregaGobiernoVerificador=1
	else
		LIN_AgregaGobiernoVerificador=0
	end if
	if EmpVer="on" then
		LIN_AgregaEmpresaVerificador=1
	else
		LIN_AgregaEmpresaVerificador=0
	end if
	if SinVer="on" then
		LIN_AgregaSindicatoVerificador=1
	else
		LIN_AgregaSindicatoVerificador=0
	end if

	
	if LIN_DiasCierreInformeParcial="" then
		LIN_DiasCierreInformeParcial="NULL"
	end if
	if LIN_DiasCierreInformeFinal="" then
		LIN_DiasCierreInformeFinal="NULL"
	end if
	if LIN_DiasCierreInformeParcial50Ejecucion="" then
		LIN_DiasCierreInformeParcial50Ejecucion="NULL"
	end if
	if LIN_DiasCierreInformeFinal100Ejecucion="" then
		LIN_DiasCierreInformeFinal100Ejecucion="NULL"
	end if

	if LIN_PorcentajeMaxAsistenciaDesercion="" then
		LIN_PorcentajeMaxAsistenciaDesercion="NULL"
	end if
	if LIN_PorcentajeMaxAsistenciaReprobacion="" then
		LIN_PorcentajeMaxAsistenciaReprobacion="NULL"
	end if
	if LIN_DiasIngresoAsistencia="" then
		LIN_DiasIngresoAsistencia="NULL"
	end if
	if LIN_PorcentajeMaxAsistenciaInscrito="" then
		LIN_PorcentajeMaxAsistenciaInscrito="NULL"
	end if		
	LIN_Estado=1

	datos =   LIN_Id & ",'" & LIN_Nombre & "', " & LFO_Id  & "," & LIN_Estado & "," & LIN_AgregaTematica & "," & LIN_Hombres & "," & LIN_Mujeres & "," & LIN_DiasCierreInformeParcial & "," & LIN_DiasCierreInformeFinal & "," & LIN_DiasCierreInformeParcial50Ejecucion & "," & LIN_DiasCierreInformeFinal100Ejecucion & "," & LIN_PorcentajeMaxAsistenciaDesercion & "," & LIN_PorcentajeMaxAsistenciaReprobacion & "," & LIN_DiasIngresoAsistencia & "," & LIN_PorcentajeMaxAsistenciaInscrito & "," & LIN_Mixta & "," & LIN_AgregaSindicato & "," & LIN_AgregaSindicatoVerificador & "," & LIN_AgregaEmpresa & "," & LIN_AgregaEmpresaVerificador & "," & LIN_AgregaCivil & "," & LIN_AgregaCivilVerificador & "," & LIN_AgregaGobierno & "," & LIN_AgregaGobiernoVerificador & "," & session("ds5_usrid") & ",'" & session("ds5_usrtoken") & "'"


	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data" : "<%=datos%>"}<%
	   response.End() 			   
	end if		
	
	sql="exec spLinea_Modificar " & datos 
	
	set rs = cnn.Execute(sql)
	on error resume next
	if cnn.Errors.Count > 0 then%>
	   {"state": 503, "message": "Error Conexión : <%=ErrMsg%>","data": "<%=sql%>"}<%
		rs.close
		cnn.close
		response.end()
	End If
	cnn.close
	set cnn = nothing%>
	{"state": 200, "message": "Ejecución exitosa","data": null}