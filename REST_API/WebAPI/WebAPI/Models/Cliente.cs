using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

namespace WebAPI.Models
{
    public class Cliente
    {
        public Cliente() {}
        /**
         * Inserta un nuevo cliente en la base de datos en la tabla CLIENTE
         * Entrdas: JObjecta temp_data (JSOn con toda la informacion necesaria para una insercion correcta)
         * Salida: JObject resultado (JSON con los resultados de la insercion, exito o error)
         * **/
        public JObject Insert(JObject temp_data) {
            dynamic data = temp_data;
            JObject resultado = new JObject();
            string dataBase = "Data Source=EFREN-CE;Initial Catalog = L3M; Integrated Security = true";
            SqlConnection dbConexion = new SqlConnection(dataBase);
            dbConexion.Open();
            SqlCommand Comando = new SqlCommand(string.Format(
                "Insert Into CLIENTE (Cedula, FNacimiento, Contraseña, Nombre1, Nombre2, Apellido, Apellido2, Provincia, Canton," +
                "Distrito, Indicaciones, Telefono, Padecimientos, Activo) values ('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}')", 
                (int)data.cedula, (string)data.fNacimiento, (string)data.contraseña, (string)data.nombre1, (string)data.nombre2, (string)data.apellido1, (string)data.apellido2,
                (string)data.provincia, (string)data.canton, (string)data.distrito, (string)data.indicaciones, (int)data.telefono, (string)data.padecimiento, 1), dbConexion);
            int temp = Comando.ExecuteNonQuery();
            dbConexion.Close();
            if (temp > 0)
            {
                resultado.Add("descripcion", "Inserción Exitosa");
                resultado.Add("codigo", 200);
            }
            else {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }
            return resultado;
        }

        public JObject SelectCliente(int user, string pass) {
            JObject resultado = new JObject();
            string dataBase = "Data Source=EFREN-CE;Initial Catalog = L3M; Integrated Security = true";
            SqlConnection dbConexion = new SqlConnection(dataBase);
            dbConexion.Open();
            //FOR JSON AUTO hace que SQL devuelva un JSON con la informacion del select
            var sqlResult = string.Format("Select * From CLIENTE Where Cedula='{0}' and Contraseña='{1}' FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER",user,pass);
            SqlCommand Comando = new SqlCommand(sqlResult, dbConexion);
            var jsonResult = new StringBuilder();
            SqlDataReader reader = Comando.ExecuteReader();
            if (!reader.HasRows)
            {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }
            else {
                while (reader.Read())
                {
                    jsonResult.Append(reader.GetValue(0).ToString());
                }
                resultado = JObject.Parse(jsonResult.ToString());
                resultado.Add("descripcion", "Exito");
                resultado.Add("codigo", 200);
            }    
            dbConexion.Close();
            reader.Close();
            return resultado;
        }
        //**//
        public Object ChangeStateCliente(int user)
        {
            JObject resultado = new JObject();
            string dataBase = "Data Source=EFREN-CE;Initial Catalog = L3M; Integrated Security = true";
            SqlConnection dbConexion = new SqlConnection(dataBase);
            dbConexion.Open();
            SqlCommand Comando = new SqlCommand("UpdateCLIENTE_Activo", dbConexion);//LLama un Stored Procedur
            Comando.CommandType = CommandType.StoredProcedure;
            Comando.Parameters.Add("@Cedula", SqlDbType.Int).Value = user;
            int temp = Comando.ExecuteNonQuery();
            if (temp > 0)
            {
                resultado.Add("descripcion", "Exito");
                resultado.Add("codigo", 200);
            }
            else
            {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }
            return resultado;
        }

    }
}