using System;
using System.Collections.Generic;
using System.Linq;

namespace wwDotnetBridgeDemos
{
    public class Person
    {        
        public string Name {get; set; } = "Rick";

        public string Company {get; set; } = "West Wind";

        public string DisplayName =>   Name +  
            (!string.IsNullOrEmpty(Company) ?  $" ({Company})" : string.Empty);

        public DateTime Entered {get; set; } = DateTime.Now;

        public Address[] Addresses {get; set; } = new Address[1]  { new Address() };

        public Address PrimaryAddress 
        {
            get { 
                var address = Addresses.FirstOrDefault();
                if (address != null)
                    return address;
                address = new Address();
                var addresses = new List<Address>(Addresses);
                addresses.Add(address);
                Addresses = addresses.ToArray();
                return address;
            }
        }

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
                   PrimaryAddress?.ToString();
        }
    }

    public class Address
    {
        public string Street {get; set; }  = "123 Nowhere Lane";
        public string City {get; set; }  = "AnyTown";
        public string State {get; set; } = "CA";
        public string Zip  {get; set; } = "11111"
    
        public override string ToString()
        {
            return Street + "\r\n" + City + "\r\n" + State + " " + Zip;
        }

    }
}
