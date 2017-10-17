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
    public class MedicamentosController : ApiController
    {
        Medicamentos medicamentos = new Medicamentos();
        public JObject POST(JObject x, string codigo) {
            dynamic data = x;
            if (codigo == "M01")//M01 = Insertar Medicamento 
            {
                data = medicamentos.InsertarMedicamento(data);
            }
            else if (codigo == "M02") {//M02 = Insertar Medicamento por Sucursal 
                data = medicamentos.InsertarMedicamentoSucursal(data);
            }
            return data;

        }


    }
}
