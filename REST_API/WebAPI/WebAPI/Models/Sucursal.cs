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

    public class Sucursal
    {
        string dataBase = "Data Source=EFREN-CE;Initial Catalog = Farmacias; Integrated Security = true";//Valores de conexion de la DB

        public JObject TodasCompañias(string NombreCompañia) {
            JArray sucursales = new JArray();
            JObject resultado = new JObject();
            SqlConnection dbConexion = new SqlConnection(dataBase);
            dbConexion.Open();
            SqlCommand Comando = new SqlCommand("Select_TodoSucursales", dbConexion);
            Comando.CommandType = CommandType.StoredProcedure;
            Comando.Parameters.Add("@NombreCompañia", SqlDbType.VarChar).Value = NombreCompañia;
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
                sucursales = JArray.Parse(jsonResult.ToString());
                resultado.Add("Sucursales", sucursales);
                resultado.Add("descripcion", "Exito");
                resultado.Add("codigo", 200);
            }

            return resultado;
        }

        public JObject InsertSucursal(JObject x) {
            JObject resultado = new JObject();
            dynamic data = x;
            try
            {
                SqlConnection dbConexion = new SqlConnection(dataBase);
                dbConexion.Open();
                SqlCommand Comando = new SqlCommand("InsertSucursal", dbConexion);
                Comando.CommandType = CommandType.StoredProcedure;
                Comando.Parameters.Add("@CedAdmin", SqlDbType.Int).Value = (int)data.cedula;
                Comando.Parameters.Add("@Nombre", SqlDbType.VarChar).Value = (string)data.nombre;
                Comando.Parameters.Add("@Provincia", SqlDbType.VarChar).Value = (string)data.provincia;
                Comando.Parameters.Add("@Canton", SqlDbType.VarChar).Value = (string)data.canton;
                Comando.Parameters.Add("@Distrito", SqlDbType.VarChar).Value = (string)data.distrito;
                Comando.Parameters.Add("@Indicaciones", SqlDbType.VarChar).Value = (string)data.indicaciones;
                Comando.Parameters.Add("@NombreComp", SqlDbType.VarChar).Value = (string)data.compañia;
                Comando.Parameters.Add("@Descripcion", SqlDbType.VarChar).Value = (string)data.descripcion; 
                int temp = Comando.ExecuteNonQuery();
                dbConexion.Close();
                if (temp == -1)
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

        public JObject DeleteSucursal(int IDSucursal) {
            JObject resultado = new JObject();
            try
            {
                SqlConnection dbConexion = new SqlConnection(dataBase);
                dbConexion.Open();
                SqlCommand Comando = new SqlCommand("UpdateSucursal_Activo", dbConexion);
                Comando.CommandType = CommandType.StoredProcedure;
                Comando.Parameters.Add("@IDSucursal", SqlDbType.Int).Value = IDSucursal;
                int temp = Comando.ExecuteNonQuery();
                dbConexion.Close();
                if (temp == -1)
                {
                    resultado.Add("descripcion", "Exito");
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