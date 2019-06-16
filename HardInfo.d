
module HardInfo;

import std.stdio;
import std.string;
import std.system;
import std.conv;
import core.cpuid;

//////////////////////HARDWARE/////////////////////////////

public class HardWareInfo {
    
    public static string ProcessorInfo()
    {
        string vendor = vendor();
        string proc = processor();
        string cores = to!string(coresPerCPU());
        string thread = to!string(threadsPerCPU());
        string bit = (isX86_64() == true) ? "x86_x64" : "x86";
        string hyper = (hyperThreading() == true) ? "yes" : "no";
        string result = format!"Vendor \t : %s\nType \t : %s\nPhysical cores \t : %s\nLogical cores \t : %s\nProcessor bits \t : %s\nProcessor support HyperThreading \t : %s"(vendor, proc, cores, thread, bit, hyper);
        return result;
    }

    public static string OSInfo()
    {
        return format!"%s"(os);
    }

}