using System;

namespace Admin.Reports
{
	public enum cpReportType 
	{
		Weekly,
		PlayPeriod
	}

	/// <summary>
	/// Summary description for IClosePeriodReport.
	/// </summary>
	public interface IClosePeriodReport
	{
		 DateTime DtBegin
		{	get;	set;	}
	    DateTime DtEnd  
		{	get;	set;	}
		cpReportType TypeReport
		{	get;	set;	}
		 string ReportFile
		 {	get;	set;	}
		  bool SendSecondary
		  {	get;	set;	}

		  bool CreateReport();


	}
}
