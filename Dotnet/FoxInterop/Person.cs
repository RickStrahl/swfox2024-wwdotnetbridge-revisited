using System;
using System.Collections.Generic;

/*
    Rename  namespace and class to fit your needs
    Below is an example of a class.
*/

namespace FoxInterop
{
    
    public class Person
    {
        public string Name { get; set; } =  "Jane Doe";
        public string Company { get; set; } = "Acme Inc.";
        public DateTime Entered { get; set; } = DateTime.UtcNow;
        public Address Address { get; set; } = new Address();

        public List<Address> AlternateAddresses { get; set; } = new List<Address>();


        public override string ToString() 
        {
            var output =  $"{Name} ({Company})\n${Address}";

            if (AlternateAddresses.Count > 0)
            {
                foreach (var addr in AlternateAddresses)
                {
                    output += $"\n${addr}";
                }
            }
            return output;
        }
        public List<Address> AlternateAddresses { get; set; } = new List<Address>();        
                
    }

    public class Address
    {
        public string Street { get; set; }  =  "123 Main St.";
        public string City { get; set; }    =  "Anytown";
        public string State { get; set; }   =  "CA";
        public string PostalCode { get; set; }  =  "12345";

        public override string ToString() 
        {
            return $"{Street}, {City}, {State} {PostalCode}";
        }
    }

}
