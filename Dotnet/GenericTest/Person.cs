using System;
using System.Collections.Generic;

namespace GenericTest
{
    public class Person
    {
        public string Name {get; set; }

        public List<Address> Addresses {get; set;} 

        public override string ToString()
        {
            return Name ?? string.Empty;
        }
    }

    public class Address
    {
        public string Street {get; set; }
        public string City {get; set; }
        public string State {get; set; }
        public string Zip  {get; set; }

        public override string ToString()
        {
            return Street + "\r\n" + City + "\r\n" + State + " " + Zip;
        }

    }
}
