using System;
using System.Collections;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

namespace Devweek.Utility.SQL
{
    /// <summary>
    /// SplitString by Adam Machanic
    /// http://sqlblog.com/blogs/adam_machanic/archive/2009/04/26/faster-more-scalable-sqlclr-string-splitting.aspx
    /// </summary>
    public class SplitString : IEnumerator
    {
        private int lastPos;
        private int nextPos;
        private string theString;
        private char delimiter;

        public SplitString(string theString, char delimiter)
        {
            this.theString = theString;
            this.delimiter = delimiter;
            this.lastPos = -1;
            this.nextPos = -1;
        }

        public object Current
        {
            get { return theString.Substring(lastPos, nextPos - lastPos).Trim(); }
        }

        public bool MoveNext()
        {
            if (nextPos >= theString.Length)
                return false;
            else
            {
                lastPos = nextPos + 1;

                if (lastPos == theString.Length)
                    return false;

                nextPos = theString.IndexOf(delimiter, lastPos);
                if (nextPos == -1)
                    nextPos = theString.Length;

                return true;
            }
        }

        public void Reset()
        {
            this.lastPos = -1;
            this.nextPos = -1;
        }

        [Microsoft.SqlServer.Server.SqlFunction(FillRowMethodName = "FillIt", TableDefinition = "output nvarchar(4000)")]
        public static IEnumerator Split(SqlChars instr, [SqlFacet(IsFixedLength = true, MaxSize = 1)]SqlString delimiter)
        {
            return ((instr.IsNull || delimiter.IsNull) ? new SplitString("", ',') : new SplitString(instr.ToSqlString().Value, Convert.ToChar(delimiter.Value)));
        }

        public static void FillIt(object obj, out SqlString output)
        {
            output = (new SqlString((string)obj));
        }
    }
}
