self.onmessage = function(evento){    
    var myRequest = new Request(evento.data);      //No debe incluir ningun include    
    self.postMessage({status:1});
    const params = {
        search:''
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
}