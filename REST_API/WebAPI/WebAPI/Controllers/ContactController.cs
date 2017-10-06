﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WebAPI.Models;

using WebAPI.Services;

namespace WebAPI.Controllers
{

    public class ContactController : ApiController
    {
        private ContactRepository contactRepository;

        public ContactController()
        {
            this.contactRepository = new ContactRepository();
        }

        public Contact[] Get()
        {
            return contactRepository.GetAllContacts();
        }
    }
<<<<<<< HEAD
 
}
=======
}
>>>>>>> dfec273df46e09b2b5426cbf300baa35e647f04a
