using System.Runtime.InteropServices;

/*
 * You need to register DotnetCoreFoxInterop.ComHost.dll with reg32.exe 
*/

namespace DotnetCoreFoxInterop
{
    
    public interface IInteropSamples
    {
        string HelloWorld(string name);
    }

    public class InteropSamples : IInteropSamples
    {
        public string HelloWorld(string name)
        {
            return "Hello " + name + " from .NET Core! Time is: " + DateTime.Now.ToString("MMM dd, yyyy hh:mm");
        }
    }
}
