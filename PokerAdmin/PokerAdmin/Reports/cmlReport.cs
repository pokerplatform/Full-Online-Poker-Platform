using System.Text ;
using System;
using System.Data; 
using Common.Db;
using System.IO;

namespace Admin.Reports
{
	public class cmlReport :  IClosePeriodReport
	{
        private const string cnstGetReport="cmlGetReportClosePeriod";

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

		public cmlReport()	{}
 
		public cmlReport(DateTime dB,DateTime dE, cpReportType rptType, bool bySecondary)
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
																		"@PlayPeriod", TypeReport==cpReportType.Weekly ?0:-1} );
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
			ret+="  "+DateTime.Now.ToString("hhmm")+"  ARK000000"+ (TypeReport==cpReportType.PlayPeriod ? "4AJ" : "3RR");
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
			  string bf=JS(true,rw["PID"].ToString(),9)+MS(false,114)+MS(true,16)+dt+" "+MS(true,4)+"31ARKADIUM";
				          bf+=    MS(false,17)+ (TypeReport==cpReportType.PlayPeriod ? "4AJ" : "3RR")+dt+dt+MS(true,23)+MS(false,50);
				          bf+=      "010"+"001"+"001"+"7229"+TransVisits(((int)rw["VisitsForPeriod"]));
				          bf+=      MS(false,14)+"7231"+TransVisitsToDate((int)rw["VisitsToDate"]);
				          bf+=      MS(false,13)+"7233"+TransGamePlayed((int)rw["RoulettePlay"] );       
						  bf+=		MS(false,13)+"7234"+ TransGamePlayed((int)rw["BlackJackPlay"] ) ;   
				          bf+=      MS(false,13)+"7235"+ TransHandsPlayed((int)rw["HandsPlayed"]) ; 
				  		  bf+=      MS(false,13)+"7236"+ rw["TimesRankedTo20"].ToString() ; 
				    	  bf+=      MS(false,14)+"7237"+ rw["SaturdayRank5"].ToString() ; 
					      bf+=      MS(false,14)+"7238"+ rw["SaturdayRank20"].ToString() ; 
		      			  bf+=      MS(false,14)+"7239"+ TransMinutes((int)rw["MinutePerVisit"]) ; 
					      bf+=      MS(false,14)+"7240"+ TransMinutes((int)rw["MinutePerVisitToDate"]) ; 
		      			  bf+=(MS(false,14)+MS(false,3)+MS(true,16)+MS(false,25));

			 bf+=" ";

			return bf;
		}


		protected string TransMinutes(int vs)
		{
			if (vs==0)
				return "0";
			else if (vs >1 && vs <=10)
				return "1";
			else if (vs >10 && vs <=20)
				return "2";
			else if (vs >20 && vs <=50)
				return "3";
			else if (vs >50 && vs <=100)
				return "4";
			else if (vs >100 && vs <=200)
				return "5";
			else if (vs >200 && vs <=500)
				return "6";
			else
				return "7";
		}

		protected string TransVisits(int vs)
		{
			if (vs==0)
					return "0";
			else if (vs==1) 
					return "1";
			else if (vs >1 && vs <=5)
				    return "2";
			else if (vs >5 && vs <=10)
				return "3";
			else if (vs >10 && vs <=20)
				return "4";
			else if (vs >20 && vs <=50)
				return "5";
			else if (vs >50 && vs <=100)
				return "6";
			else
				return "7";
		}

		protected string TransVisitsToDate(int vs)
		{
			if (vs==0)
				return "00";
			else if (vs==1) 
				return "01";
			else if (vs >1 && vs <=5)
				return "02";
			else if (vs >5 && vs <=10)
				return "03";
			else if (vs >10 && vs <=20)
				return "04";
			else if (vs >20 && vs <=50)
				return "05";
			else if (vs >50 && vs <=100)
				return "06";
			else if (vs >100 && vs <=200)
				return "07";
			else if (vs >200 && vs <=300)
				return "08";
			else if (vs >300 && vs <=400)
				return "10";
			else if (vs >400 && vs <=500)
				return "11";
			else
				return "12";
		}

		protected string TransGamePlayed(int vs)
		{
			if (vs==0)
				return "00";
			else if (vs>0 && vs<=10) 
				return "01";
			else if (vs >10 && vs <=20)
				return "02";
			else if (vs >20 && vs <=30)
				return "03";
			else if (vs >30 && vs <=40)
				return "04";
			else if (vs >40 && vs <=50)
				return "05";
			else if (vs >50 && vs <=60)
				return "06";
			else if (vs >60 && vs <=70)
				return "07";
			else if (vs >70 && vs <=80)
				return "08";
			else if (vs >80 && vs <=90)
				return "09";
			else if (vs >90 && vs <=100)
				return "10";
			else 
				return "11";
		}

		protected string TransHandsPlayed(int vs)
		{
			if (vs==0)
				return "00";
			else if (vs>0 && vs<=25) 
				return "01";
			else if (vs >25 && vs <=50)
				return "02";
			else if (vs >50 && vs <=75)
				return "03";
			else if (vs >75 && vs <=100)
				return "04";
			else if (vs >100 && vs <=125)
				return "05";
			else if (vs >125 && vs <=150)
				return "06";
			else if (vs >150 && vs <=175)
				return "07";
			else if (vs >175 && vs <=200)
				return "08";
			else if (vs >200 && vs <=225)
				return "09";
			else if (vs >225 && vs <=250)
				return "10";
			else 
				return "11";
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
