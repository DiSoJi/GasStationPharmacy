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
        string dataBase = "Data Source=EFREN-CE;Initial Catalog = Farmacias; Integrated Security = true";

        public JObject TodosEmpleados(int comp) {
            JArray empleados = new JArray();
            JObject resultado;
            SqlConnection dbConexion = new SqlConnection(dataBase);
            dbConexion.Open();
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

        public JObject InsertEmpleado(JObject x) {
            JObject resultado = new JObject();
            dynamic data = x;
            try
            {
                SqlConnection dbConexion = new SqlConnection(dataBase);
                dbConexion.Open();
                SqlCommand Comando = new SqlCommand("InsertEmpleado", dbConexion);
                Comando.CommandType = CommandType.StoredProcedure;
                Comando.Parameters.Add("@Cedula", SqlDbType.Int).Value = (int)data.cedula;
                Comando.Parameters.Add("@FNacimiento", SqlDbType.Date).Value = (string)data.fNacimiento;
                Comando.Parameters.Add("@Contraseña", SqlDbType.VarChar).Value = (string)data.contraseña;
                Comando.Parameters.Add("@Nombre1", SqlDbType.VarChar).Value = (string)data.nombre1;
                Comando.Parameters.Add("@Nombre2", SqlDbType.VarChar).Value = (string)data.nombre2;
                Comando.Parameters.Add("@Apellido1", SqlDbType.VarChar).Value = (string)data.apellido1;
                Comando.Parameters.Add("@Apellido2", SqlDbType.VarChar).Value = (string)data.apellido2;
                Comando.Parameters.Add("@Provincia", SqlDbType.VarChar).Value = (string)data.provincia;
                Comando.Parameters.Add("@Canton", SqlDbType.VarChar).Value = (string)data.canton;
                Comando.Parameters.Add("@Distrito", SqlDbType.VarChar).Value = (string)data.distrito;
                Comando.Parameters.Add("@Indicaciones", SqlDbType.VarChar).Value = (string)data.indicaciones;
                Comando.Parameters.Add("@Telefono", SqlDbType.Int).Value = (int)data.telefono;
                Comando.Parameters.Add("@Compañia", SqlDbType.VarChar).Value = (string)data.compañia;
                Comando.Parameters.Add("@Sucursal", SqlDbType.VarChar).Value = (string)data.sucursal;
                Comando.Parameters.Add("@Rol", SqlDbType.VarChar).Value = (string)data.rol;
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
            catch (Exception ex) {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }
            return resultado;
        }

        /**
        * Cambia el atributo Activo del Empleado indicado por medio de su numero de cedula
        * Se utiliza un Stored Procedure a nivel de DB que niega el estado actual, ejemplo si el Empleado esta activo lo desactiva,
        * pero si se encuentra desactivado lo vuelve a activar
        * La funcion es generar una Pseudo eliminacion solo desactivando el cliente pero manteniendo el registro
        * **/
        public Object ChangeStateEmpleado(int user)
        {
            JObject resultado = new JObject();
            try {
                SqlConnection dbConexion = new SqlConnection(dataBase);
                dbConexion.Open();
                SqlCommand Comando = new SqlCommand("UpdateEmpleado_Activo", dbConexion);//LLama un Stored Procedur
                Comando.CommandType = CommandType.StoredProcedure;
                Comando.Parameters.Add("@Cedula", SqlDbType.Int).Value = user;
                int temp = Comando.ExecuteNonQuery();
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
            catch (Exception ex) {
                resultado.Add("descripcion", "Error");
                resultado.Add("codigo", 201);
            }
            
            return resultado;
        }

        public JObject UpdateEmpleado(JObject x) {
            JObject resultado = new JObject();
            dynamic data = x;
            try
            {
                SqlConnection dbConexion = new SqlConnection(dataBase);
                dbConexion.Open();
                SqlCommand Comando = new SqlCommand("UpdateInfoEmpleado", dbConexion);
                Comando.CommandType = CommandType.StoredProcedure;
                Comando.Parameters.Add("@Cedula", SqlDbType.Int).Value = (int)data.cedula;
                Comando.Parameters.Add("@FNacimiento", SqlDbType.Date).Value = (string)data.fNacimiento;
                Comando.Parameters.Add("@Contraseña", SqlDbType.VarChar).Value = (string)data.contraseña;
                Comando.Parameters.Add("@Nombre1", SqlDbType.VarChar).Value = (string)data.nombre1;
                Comando.Parameters.Add("@Nombre2", SqlDbType.VarChar).Value = (string)data.nombre2;
                Comando.Parameters.Add("@Apellido1", SqlDbType.VarChar).Value = (string)data.apellido1;
                Comando.Parameters.Add("@Apellido2", SqlDbType.VarChar).Value = (string)data.apellido2;
                Comando.Parameters.Add("@Provincia", SqlDbType.VarChar).Value = (string)data.provincia;
                Comando.Parameters.Add("@Canton", SqlDbType.VarChar).Value = (string)data.canton;
                Comando.Parameters.Add("@Distrito", SqlDbType.VarChar).Value = (string)data.distrito;
                Comando.Parameters.Add("@Indicaciones", SqlDbType.VarChar).Value = (string)data.indicaciones;
                Comando.Parameters.Add("@Telefono", SqlDbType.Int).Value = (int)data.telefono;
                Comando.Parameters.Add("@Compañia", SqlDbType.VarChar).Value = (string)data.compañia;
                Comando.Parameters.Add("@Sucursal", SqlDbType.VarChar).Value = (string)data.sucursal;
                Comando.Parameters.Add("@Rol", SqlDbType.VarChar).Value = (string)data.rol;
                int temp = Comando.ExecuteNonQuery();
                dbConexion.Close();
                if (temp == -1)
                {
                    resultado.Add("descripcion", "Actualizacion Exitosa");
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

        /**
        * Selecciona la informacion de un emppleado de la basde de datos, se utiliza para validar el login
        * 
        * **/
        public JObject SelectEmpleado(int user, string pass)
        {
            JObject resultado = new JObject();
            SqlConnection dbConexion = new SqlConnection(dataBase);
            dbConexion.Open();
            SqlCommand Comando = new SqlCommand("SelectInfoEmpleado", dbConexion);
            Comando.CommandType = CommandType.StoredProcedure;
            Comando.Parameters.Add("@IDEmpleado", SqlDbType.Int).Value = user;
            Comando.Parameters.Add("@Pass", SqlDbType.VarChar).Value = pass;
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
                resultado = JObject.Parse(jsonResult.ToString());
                resultado.Add("descripcion", "Exito");
                resultado.Add("codigo", 200);
            }
            dbConexion.Close();
            reader.Close();
            return resultado;
        }
    }
}