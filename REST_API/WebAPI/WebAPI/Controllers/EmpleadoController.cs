using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using WebAPI.Models;

namespace WebAPI.Controllers
{ 
    /**
    * Client Controller
    * */
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class EmpleadoController : ApiController
    {
        Empleados empleado = new Empleados();// Objeto de tipo empleado para controlar la tabla empleado de la Base de datos
        public JObject Post(JObject x, string codigo) {
            dynamic data = x;
            if (codigo == "E00") {//E00 = seleciona todos los empleados de una compañia
                data = empleado.TodosEmpleados((int)data.comp);

            }
            return data;

        }




    }
}
