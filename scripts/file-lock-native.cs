using System;
using System.Text;
using System.Diagnostics;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public static class FileLockNative {
 [DllImport("ntdll.dll")] static extern int NtQuerySystemInformation(int c,IntPtr b,int n,out int needed);
 [DllImport("kernel32.dll",SetLastError=true)] static extern IntPtr OpenProcess(uint a,bool i,int p);
 [DllImport("kernel32.dll")] static extern bool CloseHandle(IntPtr h);
 [DllImport("kernel32.dll")] static extern IntPtr GetCurrentProcess();
 [DllImport("kernel32.dll")] static extern bool DuplicateHandle(IntPtr s,IntPtr h,IntPtr t,out IntPtr d,uint a,bool i,uint o);
 [DllImport("kernel32.dll")] static extern uint GetFileType(IntPtr h);
 [DllImport("kernel32.dll",CharSet=CharSet.Unicode)] static extern uint GetFinalPathNameByHandle(IntPtr h,StringBuilder b,uint n,uint f);
 [DllImport("kernel32.dll")] static extern bool ReadProcessMemory(IntPtr p,IntPtr a,byte[] b,int n,out IntPtr r);
 [DllImport("ntdll.dll")] static extern int NtQueryInformationProcess(IntPtr p,int c,IntPtr b,int n,out int r);
 [DllImport("kernel32.dll")] static extern bool IsWow64Process(IntPtr p,out bool wow);
 [DllImport("kernel32.dll")] static extern bool IsProcessCritical(IntPtr p,out bool critical);
 [DllImport("kernel32.dll",CharSet=CharSet.Unicode,SetLastError=true)] static extern IntPtr CreateFile(string name,uint access,uint share,IntPtr security,uint mode,uint flags,IntPtr template);
 public class Match { public int Pid; public string Path; public string Evidence; }
 public class Report { public List<Match> Matches=new List<Match>(); public int Denied; public bool Partial; }
 public static string Resolve(string path) {
  IntPtr h=CreateFile(path,0,7,IntPtr.Zero,3,0x02000000,IntPtr.Zero);
  if(h==new IntPtr(-1))return path;
  try{var b=new StringBuilder(32768);uint n=GetFinalPathNameByHandle(h,b,(uint)b.Capacity,0);return n>0&&n<b.Capacity?b.ToString():path;}finally{CloseHandle(h);}
 }
 static string Clean(string p) { if(p.StartsWith(@"\\?\UNC\"))p=@"\\"+p.Substring(8); else if(p.StartsWith(@"\\?\"))p=p.Substring(4); return p.TrimEnd('\\'); }
 static bool Within(string p,string target,bool folder) { return String.Equals(p,target,StringComparison.OrdinalIgnoreCase)||(folder&&p.StartsWith(target+"\\",StringComparison.OrdinalIgnoreCase)); }
 static byte[] Read(IntPtr p,long at,int count){byte[] b=new byte[count];IntPtr r;if(!ReadProcessMemory(p,new IntPtr(at),b,count,out r)||r.ToInt64()!=count)throw new Exception();return b;}
 static string Cwd(IntPtr p) {
  bool wow;if(!IsWow64Process(p,out wow)||wow||IntPtr.Size!=8)return null;
  IntPtr b=Marshal.AllocHGlobal(48);
  try{int n;if(NtQueryInformationProcess(p,0,b,48,out n)!=0)return null;
   long peb=Marshal.ReadIntPtr(b,8).ToInt64();long pp=BitConverter.ToInt64(Read(p,peb+32,8),0);
   byte[] s=Read(p,pp+56,16);int len=BitConverter.ToUInt16(s,0);if(len==0||len>32766)return null;
   return Encoding.Unicode.GetString(Read(p,BitConverter.ToInt64(s,8),len));
  }catch{return null;}finally{Marshal.FreeHGlobal(b);}
 }
 public static bool Critical(int id) {
  IntPtr p=OpenProcess(0x1000,false,id);if(p==IntPtr.Zero)throw new Exception("No se pudo verificar el proceso.");
  try{bool c;if(!IsProcessCritical(p,out c))throw new Exception("No se pudo verificar si el proceso es crítico.");return c;}finally{CloseHandle(p);}
 }
 public static Report Scan(string target,bool folder) {
  if(IntPtr.Size!=8)throw new Exception("Ejecutar con PowerShell de 64 bits.");
  target=Clean(Resolve(target));var result=new Report();var handles=new Dictionary<int,IntPtr>();var seen=new HashSet<string>();
  IntPtr buffer=IntPtr.Zero;int size=1024*1024,needed;var timer=Stopwatch.StartNew();
  try{
   int status;while(true){buffer=Marshal.AllocHGlobal(size);status=NtQuerySystemInformation(64,buffer,size,out needed);if(status==0)break;Marshal.FreeHGlobal(buffer);buffer=IntPtr.Zero;if(status!=unchecked((int)0xC0000004)||size>256*1024*1024)throw new Exception("No se pudo consultar los identificadores de Windows.");size=Math.Max(size*2,needed+65536);}
   long count=Marshal.ReadIntPtr(buffer).ToInt64();
   for(long i=0;i<count;i++){
    if(timer.ElapsedMilliseconds>15000){result.Partial=true;break;}
    IntPtr e=new IntPtr(buffer.ToInt64()+16+i*40);int pid=checked((int)Marshal.ReadIntPtr(e,8).ToInt64());
    if(pid<=4||pid==Process.GetCurrentProcess().Id)continue;
    IntPtr p;if(!handles.TryGetValue(pid,out p)){p=OpenProcess(0x450,false,pid);handles[pid]=p;if(p==IntPtr.Zero){result.Denied++;continue;}
     if(folder){string cwd=Cwd(p);if(cwd!=null&&Within(Clean(cwd),target,true))result.Matches.Add(new Match{Pid=pid,Path=cwd,Evidence="Directorio de trabajo"});}
    }
    if(p==IntPtr.Zero)continue;IntPtr dup;
    if(!DuplicateHandle(p,Marshal.ReadIntPtr(e,16),GetCurrentProcess(),out dup,0,false,2))continue;
    try{if(GetFileType(dup)!=1)continue;var name=new StringBuilder(32768);uint n=GetFinalPathNameByHandle(dup,name,(uint)name.Capacity,0);
     if(n==0||n>=name.Capacity)continue;string path=Clean(name.ToString());string key=pid+"|"+path;
     if(Within(path,target,folder)&&seen.Add(key))result.Matches.Add(new Match{Pid=pid,Path=path,Evidence="Archivo o carpeta abierto"});
    }finally{CloseHandle(dup);}
   }
   return result;
  }finally{if(buffer!=IntPtr.Zero)Marshal.FreeHGlobal(buffer);foreach(var p in handles.Values)if(p!=IntPtr.Zero)CloseHandle(p);}
 }
}
