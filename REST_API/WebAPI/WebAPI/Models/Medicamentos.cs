using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using Newtonsoft.Json.Linq;
using WebAPI.Models;
using System.Data.SqlClient;
using System.Data;

namespace WebAPI.Models
{
    public class Medicamentos
    {
        string dataBase = "Data Source=EFREN-CE;Initial Catalog = Farmacias; Integrated Security = true";//Valores de conexion de la DB

        public JObject InsertarMedicamento(JObject x) {
            dynamic data = x;
            JObject resultado = new JObject();
            try
            {
                SqlConnection dbConexion = new SqlConnection(dataBase);
                dbConexion.Open();
                SqlCommand Comando = new SqlCommand("Insert_Medicamento", dbConexion);
                Comando.CommandType = CommandType.StoredProcedure;
                Comando.Parameters.Add("@NombreMedicamento", SqlDbType.VarChar).Value = (string)data.nombreMedicamento;
                Comando.Parameters.Add("@CasaFarmaceutica", SqlDbType.VarChar).Value = (string)data.casaFarmaceutica;
                Comando.Parameters.Add("@Prescripcion", SqlDbType.Bit).Value = (int)data.prescripcion;
                int temp = Comando.ExecuteNonQuery();
                dbConexion.Close();
                if (temp >0)
                {
                    resultado.Add("descripcion", "Inserción Exitosa");
                    resultado.Add("codigo", 200);
                }
                else
                {
                    resultado.Add("descripcion", "Error");
                    resultado.Add("codigo", 201);
                }
            }
            catch (Exception ex)
            {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }

            return resultado;
        }

        public JObject InsertarMedicamentoSucursal(JObject x)
        {
            dynamic data = x;
            JObject resultado = new JObject();
            try
            {
                SqlConnection dbConexion = new SqlConnection(dataBase);
                dbConexion.Open();
                SqlCommand Comando = new SqlCommand("Insert_MedicamentoxSucursal", dbConexion);
                Comando.CommandType = CommandType.StoredProcedure;
                Comando.Parameters.Add("@NombreMedicamento", SqlDbType.VarChar).Value = (string)data.nombreMedicamento;
                Comando.Parameters.Add("@IDSucursal", SqlDbType.Int).Value = (string)data.idSucursal;
                Comando.Parameters.Add("@Cantidad", SqlDbType.Int).Value = (int)data.cantidad;
                int temp = Comando.ExecuteNonQuery();
                dbConexion.Close();
                if (temp > 0)
                {
                    resultado.Add("descripcion", "Inserción Exitosa");
                    resultado.Add("codigo", 200);
                }
                else
                {
                    resultado.Add("descripcion", "Error");
                    resultado.Add("codigo", 201);
                }
            }
            catch (Exception ex)
            {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }

            return resultado;
        }


    }
}