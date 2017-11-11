using System;
using System.Web.Mail;
using Common;
using Common.Web;

namespace Admin.CommonUse
{
	public class CSentMail
	{

		public static int Send(Common.Web.Core oDB, string mTo,string mFrom,string mSubject, string mBody, 
			System.Web.Mail.MailFormat mBodyFormat)
		{
			return Send(oDB, mTo,mFrom,mSubject,mBody,1,mBodyFormat);
		}

		public static int Send(Common.Web.Core oDB, string mTo,string mFrom,string mSubject, string mBody, int sentBy,
													System.Web.Mail.MailFormat mBodyFormat)
		{
			bool bSent =false;
			try
			{
				MailMessage msg = new MailMessage();
				msg.To = mTo ;
				msg.From =mFrom;
				msg.Subject = mSubject;
				msg.Body = mBody ;
				msg.BodyFormat = mBodyFormat;
				try
				{
					SmtpMail.SmtpServer = Config.GetDbConfigValue(oDB, Config.DBConfig.SMTPServer); 
					SmtpMail.Send(msg);
				}
				catch(System.Web.HttpException ehttp)
				{
					Log.Write("SmtpMail", ehttp);
					return 1;
				}
              
				bSent=true;

				int ID=oDB.ExecuteReturnInt("admSaveSentEmail",new object[] {"@DateSent",DateTime.Now,"@Subject",mSubject,
																		 "@SentTo",mTo,"@SentFrom",mFrom,"@Message",mBody,"@EmailSentByID",sentBy});
                if (ID<=0)
					return 2;
                else
					return 0;
			}
			catch(Exception exception)
			{
				Log.Write("SmtpMail", exception);
				return (bSent?2:1);
			}
		}
	}
}
