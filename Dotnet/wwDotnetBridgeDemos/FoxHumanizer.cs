using System;
using System.Collections.Generic;
using System.Drawing.Design;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Humanizer;

namespace wwDotnetBridgeDemos
{

    /// <summary>
    /// Helper to create humanized words of numbers dates and other occasions
    /// 
    /// Wrapper around hte Humanizer library:
    /// https://github.com/Humanizr/Humanizer
    /// </summary>
    public class FoxHumanizer
    {

        /// <summary>
        /// Humanizes a date as yesterday, two days ago, a year ago, next month etc.
        /// </summary>
        /// <param name="date"></param>
        /// <returns></returns>
        public string HumanizeDate(DateTime date)
        {            
            return date.Humanize(utcDate: false);
        }

        /// <summary>
        /// Turns integer numbers to words
        /// </summary>
        /// <param name="number"></param>
        /// <returns></returns>
        public string NumberToWords(int number)
        {            
            return number.ToWords();
        }

        /// <summary>
        /// Returns a number like 1st, 2nd, 3rd
        /// </summary>
        /// <param name="number"></param>
        /// <returns></returns>
        public string NumberToOrdinal(int number)
        {
            return number.Ordinalize();
        }

        public string NumberToOrdinalWords(int number)
        {
            return number.ToOrdinalWords();
        }

        /// <summary>
        /// creates expression like one car or two bananas
        /// from a qty and a string that is pluralized as needed
        /// </summary>
        /// <param name="single"></param>
        /// <param name="qty"></param>
        /// <returns></returns>
        public string ToQuantity(string single, int qty)
        {
            return single.ToQuantity(qty, ShowQuantityAs.Words);
        }


        public string ToCamelCase(string input)
        {
            return input.Camelize();
        }

        /// <summary>
        /// Truncates a string and adds elipses after length is exceeded
        /// </summary>
        /// <param name="input"></param>
        /// <param name="length"></param>
        /// <returns></returns>
        public string TruncateString(string input, int length)
        {
            return input.Truncate(length);
        }

        /// <summary>
        /// Takes a singular noun and pluralizes it
        /// </summary>
        /// <param name="single"></param>
        /// <returns></returns>
        public string Pluralize(string single)
        {
            return single.Pluralize(true);
        }

        /// <summary>
        /// Takes a pluralized noun and turns it to singular
        /// </summary>
        /// <param name="pluralized"></param>
        /// <returns></returns>
        public string Singularize(string pluralized)
        {
            return pluralized.Singularize(true);
        }

        /// <summary>
        /// Returns a byte count as kilobytes
        /// </summary>
        /// <param name="byteSize"></param>
        /// <returns></returns>
        public string ToByteSize(int byteSize)
        {
            return byteSize.Bytes().Humanize("#.##"); 
        }
        
    }
}
