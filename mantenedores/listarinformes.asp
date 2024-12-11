<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	LFO_Id 				= request("LFO_Id")
	VER_NumeroInforme 	= request("VER_NumeroInforme")
	
	Dim Informe(5,5)
	Informe(1,0) = ""
	Informe(1,1) = ""
	Informe(1,2) = ""
	Informe(1,3) = ""
	
	'LFO_Id=10'
	Informe(1,0) = "Todos"
	Informe(1,1) = "Inicio"
	'Informe(1,2) = "Parcial"
	Informe(1,2) = "Desarrollo"
	Informe(1,3) = "Final"
	
	'LFO_Id=11'
	Informe(2,0) = "Todos"
	Informe(2,1) = "Inicial"
	Informe(2,2) = "Avances"
	Informe(2,3) = "Final"		'Sistematización
	
	'LFO_Id=12'
	Informe(3,0) = "Todos"
	Informe(3,1) = "Inicio"	
	Informe(3,2) = "Final"
	Informe(3,3) = ""

	'LFO_Id=13'
	Informe(4,0) = "Todos"
	Informe(4,1) = "Inicio"	
	Informe(4,2) = "Desarrollo"
	Informe(4,3) = "Final"

	'LFO_Id=14'
	Informe(5,0) = "Todos"
	Informe(5,1) = "Inicio"	
	Informe(5,2) = "Avances"	
	Informe(5,3) = "Desarrollo"
	Informe(5,4) = "Final"
	
	strInforme = "No Definido"
	if(VER_NumeroInforme="" or IsNull(VER_NumeroInforme<>"")) then
		VER_NumeroInforme=99
	end if
	
	if(LFO_Id="" or IsNull(LFO_Id)) then
		LFO_Id=0
	else 	
		if(LFO_Id=10) then
			LFO=1
		else
			if(LFO_Id=11) then
				LFO=2
			else
				if(LFO_Id=12) then
					LFO=3
				else
					if(LFO_Id=13) then
						LFO=4
					else
						if(LFO_Id=14) then
							LFO=5
						else
							'strInforme="Linea no definida"
							response.write("1//Linea Formativa no definida")
							response.end()
						end if
					end if
				end if
			end if
		end if
	end if
	
	response.write("200//")%>
	<select name="VER_NumeroInforme" id="VER_NumeroInforme" class="validate select-text form-control" required><%
		if(VER_NumeroInforme=99) then%>
			<option value="" disabled selected></option><%
		end if
		for j=0 to 4
			if(Informe(LFO,j)<>"") then
				if(CInt(VER_NumeroInforme)=j) then%>
					<option value="<%=j%>" selected><%=Informe(LFO,j)%></option><%
				else%>
					<option value="<%=j%>"><%=Informe(LFO,j)%></option><%
				end if
			end if		
		next
		if(LFO_Id=11) then
			if(CInt(VER_NumeroInforme)=j) then%>
				<option value="999" selected><%=Informe(LFO,4)%></option><%
			else%>
				<option value="999"><%=Informe(LFO,4)%></option><%
			end if
		end if%>
	</select>
	<i class="fas fa-print input-prefix"></i>											
	<span class="select-highlight"></span>
	<span class="select-bar"></span>
	<label class="select-label <%=lblSelect%>">Informe</label>