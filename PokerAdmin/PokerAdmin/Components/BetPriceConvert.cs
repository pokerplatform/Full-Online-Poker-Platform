using System;
using Common;


namespace Admin.Components
{
	/// <summary>
	/// Summary description for BetPriceConvert.
	/// </summary>
	public class BetPriceConvert
	{
		public BetPriceConvert() {}

		public static decimal Euro2Usa(object Euro)
		{
			decimal dRes = 0;

			
			float euro = float.Parse(Euro.ToString());
			if ( euro > 1 )
			{
				if ( euro < 2 )
				{
					dRes = Convert.ToDecimal(100 / (1 - euro));
				}
				else
				{
					dRes = Convert.ToDecimal(100 * (euro - 1));
				}
			}
			
			//dRes = Utils.GetDecimal(Euro);
			return dRes;
		}
		public static decimal Usa2Euro(object American)
		{
			decimal fRes = 0;
			
			decimal american = decimal.Parse(American.ToString());

			if ( american != 0 )
			{
				if ( american > 0 )
				{
					fRes = (100 + Math.Abs(american))/100;
				}
				else
				{
					fRes = (100 + Math.Abs(american))/Math.Abs(american);
				}
			}

			//fRes = float.Parse(Utils.GetDecimal(American).ToString());
			return fRes;
		}
	}
}
