using System;

/*
    Rename  namespace and class to fit your needs
    Below is an example of a class.
*/

namespace ChangeMe
{
    public class Person
    {
        public string Name { get; set; } =  "Jane Doe";
        public string Company { get; set; } = "Acme Inc.";
        public DateTime Entered { get; set; } = DateTime.UtcNow;
        public Address Address { get; set; } = new Address();

        public override string ToString() 
        {
            return $"{Name} ({Company})";
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
