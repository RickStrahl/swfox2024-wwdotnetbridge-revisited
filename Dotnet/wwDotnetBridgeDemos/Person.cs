using System;
using System.Collections.Generic;
using System.Linq;

namespace wwDotnetBridgeDemos
{
    public class Person
    {        
        public string Name {get; set; } = "Rick";

        public string Company {get; set; } = "West Wind";

        public string DisplayName =>  (Name ?? string.Empty) +  
            (!string.IsNullOrEmpty(Company) ?  $" ({Company})" : string.Empty);

        public DateTime Entered {get; set; } = DateTime.Now;

        public Address[] Addresses {get; set; } = new Address[1]  { new Address() };

        //public List<Address> Addresses {get; set;}  = new List<Address>();


        public Address AddAddress(string street, string city, string state, string zip)
        {
            if (Addresses == null)
            {
                Addresses = new Address[] {};
            }

            var address = new Address()            
            {
                Street = street,
                City = city,
                State = state,
                Zip = zip
            };

            var list = new List<Address>(Addresses);
            list.Add(address);
            Addresses = list.ToArray();

            return address;
        }

        public override string ToString()
        {
            return DisplayName + "\r\n" + 
                   Addresses.FirstOrDefault()?.ToString();
        }
    }

    public class Address
    {
        public string Street {get; set; }  = "123 Nowhere Lane";
        public string City {get; set; }  = "AnyTown";
        public string State {get; set; } = "CA";
        public string Zip  {get; set; }

        public override string ToString()
        {
            return Street + "\r\n" + City + "\r\n" + State + " " + Zip;
        }

    }
}
