using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using Newtonsoft.Json.Linq;
using WebAPI.Models;

namespace WebAPI.Controllers
{
    /**
    * Client Controller
    * */
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class SucursalController : ApiController
    {
        Sucursal sucursal = new Sucursal();

        public JObject Get(string NombreCompañia, string codigo) {
            dynamic data = 0;
            if (codigo == "S00")//S00 = Obtener todas las sucursales 
            {
                data = sucursal.TodasCompañias(NombreCompañia);
            }
            return data;
        }

        public JObject POST(JObject x, string codigo) {
            dynamic data = x;
            if (codigo == "S01")//S01 = Insertar Sucursal 
            {
                data = sucursal.InsertSucursal(data);
            }
            return data;

        }

        public JObject Delete(int IDSucursal, string codigo) {
            dynamic data = 0;
            if (codigo == "S03") {//S03 = Eliminar Sucursal 
                data = sucursal.DeleteSucursal(IDSucursal);
            }
            return data;

        }

        public JObject PUT(JObject x, string codigo) {
            dynamic data = x;
            if (codigo == "S02") {//S02 = Actualizar Sucursal 
                data = sucursal.UpdateInfoSucursal(data);
            }
            return data;
        }


    }
}
