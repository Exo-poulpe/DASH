import std.digest.md;
import std.digest.sha;
import std.digest;
import std.getopt;
import std.stdio;
import std.string;
import std.datetime;

string Target = null, Wordlist = null;
bool Verbose = false;
int Mode = -1;

string HelpMode = "Mode to use for hash function\n\t0 | md5\n\t1 | sha1";

int main(string[] args)
{
    auto parser = getopt(args, "target|t", "Target value to find", &Target, "mode|m", HelpMode, &Mode, "wordlist|w",
            "Wordlist to use for password testing", &Wordlist, "verbose|v",
            "More verbose output", &Verbose);

    if (parser.helpWanted)
    {
        defaultGetoptPrinter("This program break hash from D language.", parser.options);
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
                    writefln("Password found \n%s:%s", Target, tmp);
                }
                else
                {
                    writeln("Password not found");
                }
                break;

            case 1:
                writeln("Mode : SHA1");
                string tmp = HashTesting(Target, Wordlist, new SHA1Digest());
                if (tmp != "")
                {
                    writefln("Password found \n%s:%s", Target, tmp);
                }
                else
                {
                    writeln("Password not found");
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
            if (Verbose)
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
