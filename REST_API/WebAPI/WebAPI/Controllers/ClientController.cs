using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using Newtonsoft.Json.Linq;
using System.Web.Http.Results;
using System.Web.Mvc;
using WebAPI.Models;

namespace WebAPI.Controllers
{
    /**
    * Client Controller
    * */
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class ClientController : ApiController
    {
        Cliente cliente = new Cliente();
        public string Get(string x) {
            JObject response =
                new JObject(
                new JProperty("Code", 200),
                new JProperty("Description", "Succesfull")
                );
            return x;
        }

        public JObject Post(JObject x, string codigo) {
            dynamic data = 0;
            dynamic temp = x;
            if (codigo == "C01")
            { // C01 = insertar cliente 
                data = cliente.Insert(x);
            }
            else if (codigo == "C00") {//C00 buscar un cliente
                data = cliente.SelectCliente((int)temp.user, (string)temp.pass);
            }
        
            return data;
        }
        public JObject Delete(JObject x, string codigo) {
            dynamic temp = x;
            dynamic data = 0;
            if (codigo == "C03") {
                data = cliente.ChangeStateCliente((int)temp.cedula);
            }

            return data;
        }

        public JObject Put(JObject x, string codigo) {
            dynamic temp = x;
            dynamic data = 0;
            if (codigo == "C02")
            {
                data = cliente.UpdateCliente(temp);

            }
            return data;

        }
   
    }
}
