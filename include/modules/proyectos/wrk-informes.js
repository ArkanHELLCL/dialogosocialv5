self.onmessage = function(evento){    
    var myRequest = new Request(evento.data.worker);      //No debe incluir ningun include    
    self.postMessage({status:1});
    const params = {
        PRY_Id : evento.data.PRY_Id,
        PRY_Identificador : evento.data.PRY_Identificador,
        FileName: evento.data.FileName,
        ds5_usrtoken: evento.data.ds5_usrtoken,
        ds5_usrid: evento.data.ds5_usrid
    }
    const options = {
        method : 'POST',
        body: JSON.stringify( params )
    }
    fetch(myRequest,options)
        .then(res => res.json())
        .then(data => {
            data.status=0
            this.postMessage(data);
            self.close;
        })
        .catch(err => {            
            console.error("ERROR: ", err.message);
            this.postMessage(err);
        });
}