module Color;

import std.string;

//////////////////////COLOR/////////////////////////////

public class COLOR
{
    public class ForeGround
    {

        static string DEFAULT = "\033[39m";
        static string BLACK = "\033[30m";
        static string RED = "\033[31m";
        static string GREEN = "\033[32m";
        static string BLUE = "\033[34m";
        static string WHITE = "\033[97m";

    }

    public class BackGround
    {
        static string DEFAULT = "\033[49m";
        static string BLACK = "\033[40m";
        static string RED = "\033[41m";
        static string GREEN = "\033[42m";
        static string BLUE = "\033[44m";
        static string WHITE = "\033[107m";
    }

}