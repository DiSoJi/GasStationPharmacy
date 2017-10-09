using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using Newtonsoft.Json.Linq;
using System.Web.Http.Results;
using System.Web.Mvc;

namespace WebAPI.Controllers
{
    /**
    * Client Controller
    * */
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class ClientController : ApiController
    {
        public string Get(string x) {
            JObject response =
                new JObject(
                new JProperty("Code", 200),
                new JProperty("Description", "Succesfull")
                );
            return x;
        }

        public JObject Post(JObject x) {
            dynamic temp = x;
            int temp2 = (int)temp.id;
            JObject response =
               new JObject(
               new JProperty("Code", 100),
               new JProperty("Description", "Succesfull"),
               new JProperty("Id",temp2)
               );
            return response;
        }
    }
}
