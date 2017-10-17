using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json.Linq;
using System.Data.SqlClient;
using System.Data;
using System.Text;

namespace WebAPI.Models
{
    public class Estadistica
    {
        string dataBase = "Data Source=EFREN-CE;Initial Catalog = Farmacias; Integrated Security = true";//Valores de conexion de la DB

        public JObject TotalMasVendidos() {
            JArray estadistica = new JArray();
            JObject resultado = new JObject();
            try
            {
                SqlConnection dbConexion = new SqlConnection(dataBase);
                dbConexion.Open();
                SqlCommand Comando = new SqlCommand("Estadistica_MasVendidostotal", dbConexion);
                var jsonResult = new StringBuilder();
                //Comando almacena el JSON que devolvio la base de datos
                //.ExecuteReader() permite obtener el contenido de la variable Comando
                SqlDataReader reader = Comando.ExecuteReader();
                if (!reader.HasRows)
                {
                    resultado.Add("descripcion", "Error");
                    resultado.Add("codigo", 201);

                }
                else
                {
                    //Se construye un string con los valores del JSON dentro de Comando 
                    //Luego el string es parseado a JSON por medio de un JObject 
                    //El JObject ya se puede manejar con normalidad
                    while (reader.Read())
                    {
                        jsonResult.Append(reader.GetValue(0).ToString());
                    }
                    estadistica = JArray.Parse(jsonResult.ToString());
                    resultado.Add("Estadistica", estadistica);
                    resultado.Add("descripcion", "Exito");
                    resultado.Add("codigo", 200);
                }
            }
            catch (Exception ex)
            {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }

            return resultado;



        }

        public JObject ProductosMasVendidosCompañia(string NombreComp)
        {
            JArray estadistica = new JArray();
            JObject resultado = new JObject();
            try
            {
                SqlConnection dbConexion = new SqlConnection(dataBase);
                dbConexion.Open();
                SqlCommand Comando = new SqlCommand("Estadistica_MasVendidosxCompañia", dbConexion);
                Comando.CommandType = CommandType.StoredProcedure;
                Comando.Parameters.Add("@NombreCompañia", SqlDbType.VarChar).Value = NombreComp;
                var jsonResult = new StringBuilder();
                //Comando almacena el JSON que devolvio la base de datos
                //.ExecuteReader() permite obtener el contenido de la variable Comando
                SqlDataReader reader = Comando.ExecuteReader();
                if (!reader.HasRows)
                {
                    resultado.Add("descripcion", "Error");
                    resultado.Add("codigo", 201);

                }
                else
                {
                    //Se construye un string con los valores del JSON dentro de Comando 
                    //Luego el string es parseado a JSON por medio de un JObject 
                    //El JObject ya se puede manejar con normalidad
                    while (reader.Read())
                    {
                        jsonResult.Append(reader.GetValue(0).ToString());
                    }
                    estadistica = JArray.Parse(jsonResult.ToString());
                    resultado.Add("Estadistica", estadistica);
                    resultado.Add("descripcion", "Exito");
                    resultado.Add("codigo", 200);
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