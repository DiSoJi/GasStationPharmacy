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
    public class Empleados
    {
       
        public JObject TodosEmpleados(int comp) {
            JArray empleados = new JArray();
            JObject resultado;
            string dataBase = "Data Source=EFREN-CE;Initial Catalog = Farmacias; Integrated Security = true";
            SqlConnection dbConexion = new SqlConnection(dataBase);
            dbConexion.Open();
            //var sqlResult = string.Format("Select Nombre1, Nombre2, Apellido1, Apellido2, Provincia, Canton, Distrito, Indicaciones, Telefono, FNacimiento, " +
            //"From EMPLEADO Where IDCompañia='{0}' FOR JSON AUTO", comp);//Formato de comando para realizar un SELECT*

            SqlCommand Comando = new SqlCommand("Select_TodoEmpleados", dbConexion);
            Comando.CommandType = CommandType.StoredProcedure;
            Comando.Parameters.Add("@IDCompañia", SqlDbType.Int).Value = comp;

            var jsonResult = new StringBuilder();
            //Comando almacena el JSON que devolvio la base de datos
            //.ExecuteReader() permite obtener el contenido de la variable Comando
            SqlDataReader reader = Comando.ExecuteReader();
            if (!reader.HasRows)
            {
                 resultado = new JObject(
                    new JProperty("codigo", 201),
                    new JProperty("descripcion", "Error")
                );
             
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
                empleados = JArray.Parse(jsonResult.ToString());
                //resultado = JObject.Parse(jsonResult.ToString());
                resultado = new JObject(
                    new JProperty("Empleados", empleados),
                    new JProperty("codigo", 200),
                    new JProperty("descripcion", "Exito")
                );
                
            }
            dbConexion.Close();
            reader.Close();
      
            return resultado;
          
        }



    }
}