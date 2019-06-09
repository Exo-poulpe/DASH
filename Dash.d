import std.digest.md;
import std.digest.sha;
import std.digest;
import std.getopt;
import std.stdio;
import std.string;
import std.datetime.systime;
import std.datetime.stopwatch;
import std.conv;

immutable string POSITIVE = "[+]";
immutable string NEGATIVE = "[-]";
immutable string SPECIAL = "[*]";
immutable string VERSION = "0.1.0.2";
immutable string SEPARATROR = "==============================";
immutable int BENCHMARK_VALUE = 10_000_000;
immutable int KB = 1_000;
immutable int MB = 1_000_000;
immutable int GB = 1_000_000_000;
immutable long TB = 1_000_000_000_000;
immutable double K = 1_000;

string Target = null, Wordlist = null;
bool Verbose = false, Counter = false, Benchmark = false;
int Mode = -1;
uint COUNT = 0;

string HelpMode = "Mode to use for hash function\n\t0 | md5\n\t1 | sha1\n\t2 | sha256\n\t3 | sha512";

int main(string[] args)
{
    auto parser = getopt(args, "target|t", "Target value to find", &Target,
            "mode|m", HelpMode, &Mode, "benchmark", "Benchmark mode",
            &Benchmark, "count", "Print count password only", &Counter, "wordlist|w",
            "Wordlist to use for password testing", &Wordlist, "verbose|v",
            "More verbose output", &Verbose);

    if (parser.helpWanted)
    {
        writefln("\nProgram write by Exo-poulpe %s", VERSION);
        defaultGetoptPrinter("This program break hash from D language.", parser.options);
        writeln("\nExemple : dash -m 0 -t <hash> -w rockyou.txt");
    }
    else if (Benchmark)
    {
        write("Benchmark mode : ");
        Benchmarking();
        return 0;
    }
    else if (Target != null && Mode != -1 && Wordlist != null)
    {
        try
        {
            string start = format!"Start : %s"(Clock.currTime());
            Hasher();
            if (Verbose || Counter)
            {
                writefln("Password tested : %u",COUNT);
            }
            writeln(start);
            writefln("Stop : %s", Clock.currTime());
        }
        catch (Exception ex)
        {
            writeln("Error argument");
            return 2;
        }
    }
    else
    {
        writefln("\nProgram write by Exo-poulpe %s", VERSION);
        defaultGetoptPrinter("This program break hash from D language.", parser.options);
        writeln("\nExemple : dash -m 0 -t <hash> -w rockyou.txt");
    }

    return 0;

}

void HashInfo()
{
    writefln("Wordlist to use   : %s",Wordlist);
    writefln("Hash to find      : %s",Target);
     switch (Mode)
    {
        case 0:
            writeln("Mode of hash\t  : MD5");
            break;
        case 1:
            writeln("Mode of hash\t  : SHA1");
            break;
        case 2:
            writeln("Mode of hash\t  : SHA256");
            break;
        case 3:
            writeln("Mode of hash\t  : SHA512");
            break;
        default:
            writeln("Mode of hash\t  : MD5");
            break;
    }
    writefln("%s",SEPARATROR);
}

void Hasher()
{
    HashInfo();
    switch (Mode)
    {
    case 0:
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
        break;
    }
}

string HashTesting(string hash, string wordlist, Digest mode)
{
    string password = "";
    string hashResult = "";
    File f = File(wordlist, "r+");
    while (hashResult != hash || (f.readln()) != null)
    {
        password = chomp(f.readln());
        COUNT++;
        hashResult = toLower(toHexString(mode.digest(password)));
        if (Verbose)
        {
            writefln("Password test : %s :: %s", password, hashResult);
        }
        if (hashResult == hash)
        {
            return password;
        }
    }
    return null;
}

void Benchmarking()
{
    if (Mode == -1)
    {
        Mode = 0;
    }

    switch (Mode)
    {
        case 0:
            writeln("MD5");
            break;
        case 1:
            writeln("SHA1");
            break;
        case 2:
            writeln("SHA256");
            break;
        case 3:
            writeln("SHA512");
            break;
        default:
            writeln("MD5");
            break;
    }

    writeln("Password count : ",BENCHMARK_VALUE);
    writefln("%s",SEPARATROR);
    writefln("Start : %s", Clock.currTime());
    StopWatch sw = StopWatch();
    sw.start();

    for (int i = 0; i < BENCHMARK_VALUE; i++)
    {
        switch (Mode)
        {
        case 0:
            string tmp = toHexString(new MD5Digest().digest(text(i)));
            break;
        case 1:
            string tmp = toHexString(new SHA1Digest().digest(text(i)));
            break;
        case 2:
            string tmp = toHexString(new SHA256Digest().digest(text(i)));
            break;
        case 3:
            string tmp = toHexString(new SHA512Digest().digest(text(i)));
            break;
        default:
            string tmp = HashTesting(Target, Wordlist, new MD5Digest());
            break;

        }
    }
    sw.stop();
    writefln("Stop : %s", Clock.currTime());
    double tot = BENCHMARK_VALUE / ((sw.peek.total!"msecs") / K);
    writefln("Password per seconds : %s",ToNormalize(tot));
}

string ToNormalize(double tot)
{
    string result = null;
    if (tot > KB && tot < MB)
    {
        result = format!"~%.2f KH/s"(tot / KB);
    } 
    else if (tot > MB && tot < GB)
    {
        result = format!"~%.2f MH/s"(tot / MB);

    } else if (tot > GB && tot < TB)
    {
        result = format!"~%.2f GH/s"(tot / GB);
    }

    return result;
}
