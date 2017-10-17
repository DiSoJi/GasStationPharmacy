using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Newtonsoft.Json.Linq;
using WebAPI.Models;

namespace WebAPI.Controllers
{
    public class EstadisticaController : ApiController
    {
        Estadistica estadistica = new Estadistica();

        public JObject GET(string NombreComp, string codigo) {
            dynamic data = 0;

            if (codigo == "ES02") {//Cantidad de ventas por compañia

            }
            else if (codigo == "ES03"){ //Productos mas vendidos por compañia 

                data = estadistica.ProductosMasVendidosCompañia(NombreComp);

            }

            return data;

        }
        public JObject GET(string codigo)
        {
            dynamic data = 0;
            if (codigo == "ES01")
            {//Total productos mas vendido
                data = estadistica.TotalMasVendidos();
            }
        
            return data;

        }


    }
}
