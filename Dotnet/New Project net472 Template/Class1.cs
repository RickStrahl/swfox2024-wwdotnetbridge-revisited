using System;

/*
    Rename  namespace and class to fit your needs
    Below is an example of a class.
*/

namespace Class1
{
    public class Person
    {
        public string Name { get; set; }
        public string Company { get; set; }

        public DateTime Entered { get; set; } = DateTime.UtcNow;

        public Address Address { get; set; } = new Address();
    }

    public class Address
    {
        public string Street { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
    }

}
