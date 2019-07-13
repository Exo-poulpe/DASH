module BruteForce;

import std.digest;
import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.datetime.systime;
import std.datetime.stopwatch;

immutable char[] ALPHABET = "abcdefghijklmnopqrstuvwxyz".dup;
immutable char[] ALPHABET_UPPER = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".dup;
immutable char[] ALPHABET_UPPER_NUMBER = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".dup;

public double countPassword = 0;

public char[] Alphabet = null;

public string BruteForcing(string hash, Digest mode, char[] alpa,bool verbose = false)
{
    Alphabet = alpa;
    char[] tmp = [Alphabet[0]];
    writefln("Start : %s", Clock.currTime());

    while (true)
    {
        for (int i = 0; i < Alphabet.length; i++)
        {
            countPassword++;
            if (verbose == true)
            {
                writefln("Password tested : %s :: %s", tmp, toLower(toHexString(mode.digest(tmp))));
            }
            if (toLower(toHexString(mode.digest(tmp))) == hash)
            {
                writefln("Stop : %s", Clock.currTime());
                return format!"%s"(tmp);
            }
            tmp = CheckPassWordLetter(tmp);

        }

    }
}

public static char[] CheckPassWordLetter(char[] pass)
{
    int Turn = 1;
    for (int i = 0; i < Turn; i++)
    {
        if (pass[i] == Alphabet[Alphabet.length - 1])
        {
            if (pass.length > i + 1)
            {
                pass[i] = Alphabet[0];
                Turn++;
            }
            else
            {
                pass.insertInPlace(0, Alphabet[0]);
                pass[pass.length - 1] = Alphabet[0];
            }

        }
        else
        {
            pass[i] = NewCharFromChar(pass[i]);
        }
    }
    return pass;
}

public static char NewCharFromChar(char letter)
{
    for (int i = 0; i < Alphabet.length; i++)
    {
        if (letter == Alphabet[i])
        {
            if ((i + 1) > Alphabet.length - 1)
                return Alphabet[0];
            else
                return Alphabet[i + 1];
        }
    }
    
    return Alphabet[0];
}
