import std.digest.md;
import std.digest.sha;
import std.digest;
import std.getopt;
import std.stdio;
import std.string;
import std.datetime;

immutable string POSITIVE = "[+]";
immutable string NEGATIVE = "[-]";
immutable string SPECIAL = "[*]";
immutable string VERSION = "0.1.0.1";

string Target = null, Wordlist = null;
bool Verbose = false, Counter;
int Mode = -1;

string HelpMode = "Mode to use for hash function\n\t0 | md5\n\t1 | sha1\n\t2 | sha256\n\t3 | sha512";

int main(string[] args)
{
    auto parser = getopt(args, "target|t", "Target value to find", &Target,
            "mode|m", HelpMode, &Mode, "count", "Print count password only",
            &Counter, "wordlist|w", "Wordlist to use for password testing",
            &Wordlist, "verbose|v", "More verbose output", &Verbose);

    if (parser.helpWanted)
    {
        defaultGetoptPrinter("This program break hash from D language.", parser.options);
        writefln("\nProgram write by Exo-poulpe %s",VERSION);
    }
    else if (Target != null && Mode != -1 && Wordlist != null)
    {
        try
        {
            switch (Mode)
            {
            case 0:
                writeln("Mode : MD5");
                string tmp = HashTesting(Target, Wordlist, new MD5Digest());
                if (tmp != "")
                {
                    writefln("%sPassword found \n%s:%s", POSITIVE, Target, tmp);
                }
                else
                {
                    writefln("%sPassword not found", NEGATIVE);
                }
                break;

            case 1:
                writeln("Mode : SHA1");
                string tmp = HashTesting(Target, Wordlist, new SHA1Digest());
                if (tmp != "")
                {
                    writefln("%sPassword found \n%s:%s", POSITIVE, Target, tmp);
                }
                else
                {
                    writefln("%sPassword not found", NEGATIVE);
                }
                break;
            case 2:
                writeln("Mode : SHA256");
                string tmp = HashTesting(Target, Wordlist, new SHA256Digest());
                if (tmp != "")
                {
                    writefln("%sPassword found \n%s:%s", POSITIVE, Target, tmp);
                }
                else
                {
                    writefln("%sPassword not found", NEGATIVE);
                }
                break;
            case 3:
                writeln("Mode : SHA512");
                string tmp = HashTesting(Target, Wordlist, new SHA512Digest());
                if (tmp != "")
                {
                    writefln("%sPassword found \n%s:%s", POSITIVE, Target, tmp);
                }
                else
                {
                    writefln("%sPassword not found", NEGATIVE);
                }
                break;

            default:
                writeln("Mode unknow");
                return 1;
            }
        }
        catch (Exception ex)
        {
            writeln("Error argument");
            return 2;
        }
    }
    else
    {
        defaultGetoptPrinter("This program break hash from D language.", parser.options);
        writefln("\nProgram write by Exo-poulpe %s",VERSION);
    }

    return 0;

}

string HashTesting(string hash, string wordlist, Digest mode)
{
    uint count = 0;
    string password = "";
    string hashResult = "";
    File f = File(wordlist, "r+");
    while (hashResult != hash || (f.readln()) != null)
    {
        password = chomp(f.readln());
        count++;
        hashResult = toLower(toHexString(mode.digest(password)));
        if (Verbose)
        {
            writefln("Password test : %s :: %s", password, hashResult);
        }
        if (hashResult == hash)
        {
            if (Verbose || Counter)
            {
                writefln("Password count : %u", count);
            }
            return password;
        }
    }
    return null;
}

string Md5Hash(string text)
{
    ubyte[] hash = new MD5Digest().digest(text);
    return toLower(toHexString(hash));
}
