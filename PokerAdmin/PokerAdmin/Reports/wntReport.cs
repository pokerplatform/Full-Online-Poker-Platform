using System.Text ;
using System;
using System.Data; 
using Common.Db;
using System.IO;

namespace Admin.Reports
{
	public class wntReport :  IClosePeriodReport
	{
        private const string cnstGetReport="wntGetReportClosePeriod";

		DataTable rpTable=null;
		private DateTime m_DtBegin;
		private DateTime m_DtEnd;
		private cpReportType m_TypeReport;
		private string m_ReportFile;
		public bool m_SendSecondary=false;

		public DateTime DtBegin
		{
			get {return m_DtBegin;}
			set  {m_DtBegin=value;}
		}
		public DateTime DtEnd
		{
			get {return m_DtEnd;}
			set  {m_DtEnd=value;}
		}
		public cpReportType TypeReport
		{
			get {return m_TypeReport;}
			set  {m_TypeReport=value;}
		}
		public string ReportFile
		{
			get {return m_ReportFile;}
			set  {m_ReportFile=value;}
		}
		public bool SendSecondary
		{
			get {return m_SendSecondary;}
			set  {m_SendSecondary=value;}
		}

		public wntReport()	{}
 
		public wntReport(DateTime dB,DateTime dE, cpReportType rptType, bool bySecondary)
		{
			  DtBegin=dB;
			  DtEnd=dE; 
			  TypeReport=rptType;
			   SendSecondary=bySecondary;
		}

		public bool CreateReport()
		{
			StreamWriter sr=null;
			try
			{
				string pt=Config.GetConfigValue("ReportOutput"); 
				ReportFile="PayPeriod"+DtEnd.ToString("yyyyMMddHHmmss")+".rep";
				pt+=("\\"+ ReportFile);
				if (File.Exists(pt))
					File.Delete(pt); 
				Common.Db.Base  db = new  Common.Db.Base();
				int cto=Common.Utils.GetInt (Config.GetConfigValue("SQLCommandTimeout")); 
				if (cto>=0) db.CommandTimeOut =cto;
				rpTable=db.GetDataTable(cnstGetReport, new object[] {"@bPeriod",DtBegin,
																		"@ePeriod",DtEnd,
																		"@PlayPeriod", TypeReport==cpReportType.Weekly?0:-1} );
				if (rpTable == null) return false;
				sr = File.CreateText(pt);
				sr.WriteLine(GetHeaderForReport());   
				foreach (DataRow dr in rpTable.Rows)
				{
					string sdr=GetRowForReport(dr);
					sr.WriteLine(sdr); 
				}
				sr.WriteLine(GetFooterForReport(rpTable.Rows.Count));   
			}
			catch{}
			finally
			{
				if (sr!=null) sr.Close(); 
			}
			return true;
		}

		protected string GetHeaderForReport()
		{
			string ret="$$ADD ID=ARKRJR01 BID='ARKADIUM'\r\n";
            ret+="XXHDR "+DateTime.Now.ToString("yyyyMMdd")+" "+DateTime.Now.ToString("yyyyMMdd");
			ret+="  "+DateTime.Now.ToString("hhmm")+"  ARK000000"+ (TypeReport==cpReportType.PlayPeriod ? "3PA" : "3PB");
			ret+=DateTime.Now.ToString("MMddyy")+"CD000"+(SendSecondary?"R":" ")+" "; 
			return ret;
		}

		protected string GetFooterForReport(int Rows)
		{
			return "XXEOF "+DateTime.Now.ToString("yyyyMMdd")+" "+JS(true,Rows.ToString(),9);
		}

		protected string GetRowForReport(DataRow rw)
		{
			  string dt=DateTime.Now.ToString("yyyyMMdd");
			  string bf=JS(true,rw["PID"].ToString(),9)+MS(false,114)+MS(true,16)+dt+" "+MS(true,4)+"30ARKADIUM";
				          bf+=    MS(false,17)+ (TypeReport==cpReportType.PlayPeriod ? "3PA" : "3PB")+dt+dt+MS(true,23)+MS(false,50);
				          bf+=      "010"+"001"+"001"+"7210"+JS(true,rw["PlayPeriod"].ToString(),2);
				          bf+=      MS(false,13)+"7211"+JS(true,CMax((int)rw["Rank"]).ToString(),5);
				          bf+=      MS(false,10)+"7212"+GetPointRange((int)rw["TotalActualPoint"]);       
						  bf+=		MS(false,13)+"7213"+ JS(true,rw["TotalActualPoint"].ToString(),15) ;   
			              bf+=      "7214"+ JS(true,CMax((int)rw["HandsPlayed"]).ToString(),5);
				          bf+=      MS(false,10)+"7215"+ JS(true,CMax((int)rw["HandsWon"]).ToString(),5) ; 
						  bf+=		MS(false,10)+"7216"+ JS(true,CMax((int)rw["MinutesPerDay"]).ToString(),5) ; 
						  bf+=		MS(false,10)+"7217"+ JS(true,CMax((int)rw["HandsPerDay"]).ToString(),5) ;
						  bf+=		MS(false,10)+"7218"+ JS(true,CMax((int)rw["PracticeHands"]).ToString(),5);
				          bf+=      MS(false,10)+"7219"+ JS(true,CMax((int)rw["HighestPointsWon"]).ToString(),5) +	MS(false,10);
/*			for (int l=1;l<=20;l++)
			{
				bf+=(MS(true,4)+MS(false,15));
			}*/
		/*	for (int l=1;l<=20;l++)
			{*/
				bf+=(MS(false,3)+MS(true,16)+MS(false,25));
			//}

			 bf+=" ";

			return bf;
		}

		protected string GetPointRange(int aPt)
		{
			if (aPt<=1000)
				 return "01";
			else if (aPt>1000 && aPt<=2000)
				 return "02"; 
			else if (aPt>2000 && aPt<=3000)
				return "03"; 
			else if (aPt>3000 && aPt<=4000)
				return "04"; 
			else if (aPt>4000 && aPt<=5000)
				return "05"; 
			else if (aPt>5000 && aPt<=6000)
				return "06"; 
			else if (aPt>6000 && aPt<=7000)
				return "07"; 
			else if (aPt>7000 && aPt<=8000)
				return "08"; 
			else if (aPt>8000 && aPt<=9000)
				return "09"; 
			else if (aPt>9000 && aPt<=10000)
				return "10"; 
			else if (aPt>10000 && aPt<=11000)
				return "11"; 
			else if (aPt>11000 && aPt<=12000)
				return "12"; 
			else if (aPt>12000 && aPt<=13000)
				return "13"; 
			else if (aPt>14000 && aPt<=15000)
				return "15"; 
			else if (aPt>15000 && aPt<=20000)
				return "16"; 
			else if (aPt>20000 && aPt<=25000)
				return "17"; 
			else if (aPt>25000 && aPt<=30000)
				return "18"; 
			else if (aPt>30000 && aPt<=35000)
				return "19"; 
			else if (aPt>35000 && aPt<=40000)
				return "20"; 
			else if (aPt>40000 && aPt<=45000)
				return "21"; 
			else if (aPt>45000 && aPt<=50000)
				return "22"; 
			else if (aPt>50000 && aPt<=75000)
				return "23"; 
			else if (aPt>75000 && aPt<=100000)
				return "24"; 
			else if (aPt>100000 && aPt<=125000)
				return "25"; 
			else if (aPt>125000 && aPt<=150000)
				return "26"; 
			else if (aPt>150000 && aPt<=175000)
				return "27"; 
			else if (aPt>175000 && aPt<=200000)
				return "28"; 
			else
				return "29";
		}

		protected object CMax(int val)
		{
			return val<=32767?val:32767;
		}
		protected string MS(bool asNumeric,int width)
		{
			char addChar= asNumeric?'0':' ';
			return new String(addChar,width);
		}
		protected string JS(bool asNumeric,string src,int width)
		{
			  if (src.Length > width) src=("?"+src.Substring(0,width-1)); 
			  int rem=width-src.Length;
			  string bf=MS(asNumeric,rem);
			if (asNumeric)
				  return (bf+src);
            else 
				return (src+bf);
		}

	}
}
