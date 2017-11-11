if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntBiggestHand]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntBiggestHand]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntClosePeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntClosePeriod]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntConcurrentPlayers]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntConcurrentPlayers]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntDeletePlayPeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntDeletePlayPeriod]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntGetPlayPeriods]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntGetPlayPeriods]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntGetReportClosePeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntGetReportClosePeriod]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntGetUserID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntGetUserID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntHandsPlayed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntHandsPlayed]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntHandsPlayedByUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntHandsPlayedByUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntMostActivePlayers]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntMostActivePlayers]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntMostPopularGames]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntMostPopularGames]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntMostWinsForPlayer]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntMostWinsForPlayer]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntNotPlayedPlayers]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntNotPlayedPlayers]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntSavePlayPeriod]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntSavePlayPeriod]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntTimeSpendByUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntTimeSpendByUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntUserTransations]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntUserTransations]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[wntUsersSignupAndPlay]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[wntUsersSignupAndPlay]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntBiggestHand
       @dtBegin datetime  = null
       ,@dtEnd  datetime  = null

 AS

declare	@sql		varchar(8000)
	,@where	varchar(4000)

set @where = 'WHERE dp.txTypeID=6 AND ua.CurrencyTypeID=2'   

if (@dtBegin is not null and @dtEnd is null)
	set @where = dbo.fnGetWhereCause(@where, 'dp.RecordDate >=''' + convert(varchar,@dtBegin)+'''')
if (@dtBegin is null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'dp.RecordDate <=''' + convert(varchar,@dtEnd)+'''')
if (@dtBegin is not null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'dp.RecordDate BETWEEN ''' + convert(varchar,@dtBegin)+ ''' AND ''' + convert(varchar,@dtEnd)+'''')

 set @Sql= 'SELECT TOP 1 dbo.fnNullAsMoney (dp.txAmount) as Amount, tgd.GameLogID as HandID
                   FROM Tx dp (nolock)  INNER JOIN TxGameDetail tgd ON dp.[id]=tgd.txid INNER JOIN UserAccount ua ON ua.[id]=dp.AccountID ' +
                         @where+' ORDER BY dbo.fnNullAsMoney (dp.txAmount) DESC'

 print @sql
 exec(@sql)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntClosePeriod 
     @PeriodID  int
AS

   declare @ID int
   declare @Balance decimal
   declare @dFrom DateTime , @dTo DateTime 
   declare @Comment	varchar(512)
   declare @CursOpened  bit

   set @CursOpened=0

   DECLARE uBalance CURSOR FOR  SELECT  [id],Balance FROM   UserAccount (nolock) 
    IF (@@ERROR <> 0) GOTO ErrorHandler

   SELECT @dFrom=DateFrom,@dTo=DateTo FROM PlayPeriods (nolock) WHERE [ID]=@PeriodID
   IF (@@ERROR <> 0) GOTO ErrorHandler

   BEGIN TRANSACTION wntClosePeriod

	OPEN uBalance
		IF (@@ERROR <> 0) GOTO ErrorHandler
	 set @CursOpened=1

	FETCH NEXT FROM uBalance INTO @id, @Balance
		IF (@@ERROR <> 0) GOTO ErrorHandler

             WHILE @@FETCH_STATUS = 0
	    BEGIN
                 --   if @Balance >0 
        --             begin
	                    set @Balance= - @Balance
             		       set @Comment= 'Close Period '+convert(varchar,@dFrom)+'-'+convert(varchar,@dTo)
	                   exec   [dbo].admSaveTransaction @Balance,@ID, @Comment,26
			IF (@@ERROR <> 0) GOTO ErrorHandler
--                      end 
		      FETCH NEXT FROM uBalance INTO @id, @Balance
		IF (@@ERROR <> 0) GOTO ErrorHandler
                 END

   UPDATE PlayPeriods SET IsClosed=1  WHERE [ID]=@PeriodID
         IF (@@ERROR <> 0) GOTO ErrorHandler

   COMMIT TRANSACTION wntClosePeriod
   CLOSE uBalance
   DEALLOCATE uBalance
   set @CursOpened=0

   RETURN 0

ErrorHandler:
ROLLBACK TRANSACTION wntClosePeriod
if  @CursOpened=1
begin
   CLOSE uBalance
   DEALLOCATE uBalance
end
   set @CursOpened=0
RETURN 1
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntConcurrentPlayers
       @dtBegin datetime 
       ,@dtEnd  datetime 
       ,@Interval  int
       ,@IntervalType  int 

 AS

declare	@cnt	int
       ,@Min  int
       ,@Max int
       ,@tmpdtEnd  datetime
       ,@tmpdtBg  datetime
        


set @cnt=0
set @Max=0
set @Min=-1

  SELECT @tmpdtBg=MIN(SessionStart) FROM ClientSessionHistory (nolock) 
  SELECT @tmpdtEND=MAX(SessionStart) FROM ClientSessionHistory (nolock) 
  
   IF @tmpdtEND < @dtEND  set @dtEND=@tmpdtEnd
   IF @tmpdtBg > @dtBegin  set @dtBegin=@tmpdtBG

 set @tmpdtBG=@dtBegin

       if @IntervalType =1
                set @tmpdtEnd=DATEADD(mi,@interval,@tmpdtBG)
       else if @IntervalType =2
                set @tmpdtEnd=DATEADD(hh,@interval,@tmpdtBG)
       else if @IntervalType =3
                set @tmpdtEnd=DATEADD(dd,@interval,@tmpdtBG)
       else if @IntervalType =4
                set @tmpdtEnd=DATEADD(mm,@interval,@tmpdtBG)


 WHILE (@tmpdtEnd <= @dtEnd)
  BEGIN
         SELECT @cnt=COUNT(*) FROM ClientSessionHistory (nolock) WHERE  (SessionStart BETWEEN @tmpdtBG AND @tmpdtEnd ) AND UserID is not null GROUP BY  UserID
         IF @cnt >0 AND @cnt is not null
           begin
               IF @cnt>@Max  
                 BEGIN
                    set @Max=@cnt
                    if @Min=-1 set @Min=@Max 
                 END
                if @cnt<@Min   set @Min=@cnt
           end

	   print @tmpdtBG
	   print @tmpdtEnd
	   print @min
	   print @max
	   print @cnt
               

                set @tmpdtBG=DATEADD(ss,1,@tmpdtEnd)
       if @IntervalType =1
                set @tmpdtEnd=DATEADD(mi,@interval,@tmpdtEnd)
       else if @IntervalType =2
                set @tmpdtEnd=DATEADD(hh,@interval,@tmpdtEnd)
       else if @IntervalType =3
                set @tmpdtEnd=DATEADD(dd,@interval,@tmpdtEnd)
       else if @IntervalType =4
                set @tmpdtEnd=DATEADD(mm,@interval,@tmpdtEnd)
       else
          BREAK

  END

  if @Min=-1 set @Min=0

  SELECT @Min as Minimum ,@Max as Maximum
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntDeletePlayPeriod
       @ID  int
 AS

 DELETE PlayPeriods FROM PlayPeriods WHERE [ID]=@ID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntGetPlayPeriods
 AS

 SELECT [ID],DateFrom,DateTo,IsClosed FROM PlayPeriods (nolock) ORDER BY [ID]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntGetReportClosePeriod
     @bPeriod  datetime =null
    ,@ePeriod  datetime =null
    ,@PlayPeriod   int=-1 
 AS

 declare @Days int

 if @bPeriod is null
   set @bperiod=convert(datetime,'2005-01-01')
 if @ePeriod is null
   set @eperiod=getdate()

  set @Days=DATEDIFF ( day , @bPeriod , @ePeriod ) 
 if @PlayPeriod<0
    set @PlayPeriod=MONTH(@ePeriod)

  declare  @table TABLE([PID] int DEFAULT 0 PRIMARY KEY,PlayPeriod int DEFAULT 0, Rank int DEFAULT 0,
                                         PointRange int DEFAULT 0,TotalActualPoint int DEFAULT 0,
                                         HandsPlayed int DEFAULT 0, HandsWon int DEFAULT 0,
                                         MinutesPerDay int DEFAULT 0.00,HandsPerDay int DEFAULT 0.00,
			 PracticeHands int DEFAULT 0,HighestPointsWon int DEFAULT 0 ) 

 -- Fill table User's ID
    INSERT INTO @table ([PID],PlayPeriod) SELECT u.[ID] , @PlayPeriod as PL FROM vwUsers u WHERE UserTypeID=1 ORDER BY u.[ID]

 -- determine MAX money won and Total momey won
    UPDATE  @table SET HighestPointsWon=hp.HPoints,
                                         TotalActualPoint=hp.TotalPoints
    FROM (SELECT u.[id],MAX(tx.TxAmount) as HPoints, SUM(tx.TxAmount) as TotalPoints  FROM vwUsers u (nolock) INNER JOIN
                 UserAccount ua ON u.[ID]=ua.UserID INNER JOIN tx (nolock) on ua.[ID]=tx.AccountID WHERE ua.CurrencyTypeID=2 AND u.UserTypeID=1 and tx.TxTypeID=6 
                 and tx.RecordDate BETWEEN @bPeriod AND @ePeriod GROUP BY u.[ID] ) as hp
                 WHERE PID=hp.[ID]

 -- determine count of minutes logged per day
    UPDATE  @table SET MinutesPerDay=hp.MPDay
    FROM (SELECT u.[id], (SUM(DATEDIFF ( minute , ch.SessionStart,ch.SessionEnd))/@Days) as MPDay  FROM vwUsers u (nolock) INNER JOIN
                 ClientSessionHistory ch ON u.[ID]=ch.UserID WHERE u.UserTypeID=1
                 and ch.SessionStart>= @bPeriod AND ch.SessionEnd <= @ePeriod GROUP BY u.[ID] ) as hp
                 WHERE PID=hp.[ID]

 -- determine Rank
  declare  @tb TABLE(tbRank int IDENTITY (1,1), [PrID] int DEFAULT 0 PRIMARY KEY, MWon money DEFAULT 0.00) 

    INSERT INTO  @tb (PrID, MWon)
    SELECT u.[id], SUM(tx.TxAmount) as MWon  FROM vwUsers u (nolock) INNER JOIN
                 UserAccount ua (nolock) ON u.[ID]=ua.UserID INNER JOIN tx (nolock) on ua.[ID]=tx.AccountID WHERE u.UserTypeID=1 and tx.TxTypeID=6 and ua.CurrencyTypeID=2
                 and tx.RecordDate BETWEEN @bPeriod AND @ePeriod GROUP BY u.[ID]  ORDER BY MWon DESC

    UPDATE  @table SET Rank=tb.tbRank FROM (SELECT tbRank,PrID FROM @tb) tb WHERE PID=tb.PrID

 -- determine Hands played as Hands per Day
    UPDATE @table SET HandsPlayed=hp.AllHands, HandsPerDay=hp.HdsPerDay
    FROM (SELECT u.[id],Count(*) as AllHands , (Count(*)/@Days) as HdsPerDay FROM Tx (nolock) INNER JOIN TxGameDetail tgd (nolock) ON 
      tx.[id]=tgd.txid INNER JOIN UserAccount ua (nolock) ON ua.[id]=tx.AccountID
     INNER JOIN vwUsers u (nolock) ON u.[id]=ua.userID WHERE ua.CurrencyTypeID=2 AND tx.RecordDate BETWEEN @bPeriod AND @ePeriod 
     GROUP BY u.[id],tgd.GameLogID) hp  WHERE PID=hp.[id]

 -- Practice Hands

    UPDATE @table SET PracticeHands=hp.AllHands
    FROM (SELECT u.[id],Count(*) as AllHands  FROM Tx (nolock) INNER JOIN TxGameDetail tgd (nolock) ON 
      tx.[id]=tgd.txid INNER JOIN UserAccount ua ON ua.[id]=tx.AccountID
     INNER JOIN vwUsers u (nolock) ON u.[id]=ua.userID WHERE ua.CurrencyTypeID=1 AND tx.RecordDate BETWEEN @bPeriod AND @ePeriod 
     GROUP BY u.[id],tgd.GameLogID) hp  WHERE PID=hp.[id]

 --  Hands Won
    UPDATE @table SET HandsWon=hp.AllHands
    FROM (SELECT u.[id],Count(*) as AllHands  FROM Tx (nolock) INNER JOIN TxGameDetail tgd (nolock) ON 
      tx.[id]=tgd.txid INNER JOIN UserAccount ua (nolock) ON ua.[id]=tx.AccountID
     INNER JOIN vwUsers u (nolock) ON u.[id]=ua.userID WHERE ua.CurrencyTypeID=2 AND tx.RecordDate BETWEEN @bPeriod AND @ePeriod 
     AND tx.TxTypeID=6  GROUP BY u.[id],tgd.GameLogID) hp  WHERE PID=hp.[id]

 -- Select Result
   SELECT * FROM @table
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntGetUserID
       @LoginName  varchar(50)
 AS

  declare @ID  int
     set @ID=0

   SELECT @ID=[ID] FROM vwUsers (nolock) WHERE LoginName=@LoginName

  return @ID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntHandsPlayed
       @dtBegin datetime  = null
       ,@dtEnd  datetime  = null
       ,@CurrencyPlay  bit=0
       ,@CurrencyMoney  bit=0
       ,@UserID  int=0

 AS

declare	@sql		varchar(8000)
	,@where	varchar(4000)

set @where = ''  

if (@dtBegin is not null and @dtEnd is null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate >=''' + convert(varchar,@dtBegin)+'''')
if (@dtBegin is null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate <=''' + convert(varchar,@dtEnd)+'''')
if (@dtBegin is not null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate BETWEEN ''' + convert(varchar,@dtBegin)+ ''' AND ''' + convert(varchar,@dtEnd)+'''')

if @CurrencyPlay>0 and @CurrencyMoney<=0
	set @where = dbo.fnGetWhereCause(@where, 'ua.CurrencyTypeID=1')
if @CurrencyPlay<=0 and @CurrencyMoney>0
	set @where = dbo.fnGetWhereCause(@where, 'ua.CurrencyTypeID=2')
if @CurrencyPlay>0 and @CurrencyMoney>0
  begin
	set @where = dbo.fnGetWhereCause(@where, 'ua.CurrencyTypeID=1')
             set @where = @where +' or ua.CurrencyTypeID=2'  
  end

if @UserID>0
  begin
	set @where = dbo.fnGetWhereCause(@where, 'u.[ID]=' + convert(varchar,@UserID))
	 set @sql='SELECT dbo.GetDatePart(tx.RecordDate) as HandDate,tgd.GameLogID as HandID,gp.[Name] as game,u.[id] as UserID,u.LoginName,Count(*) as AllHands  FROM Tx 
		      INNER JOIN TxGameDetail tgd ON 
		      tx.[id]=tgd.txid INNER JOIN UserAccount ua ON ua.[id]=tx.AccountID
		     INNER JOIN vwUsers u ON u.[id]=ua.userID INNER JOIN GameProcess gp ON gp.ID=tgd.GameProcessID '+ @where +
		    ' GROUP BY dbo.GetDatePart(tx.RecordDate),tgd.GameLogID,gp.[Name],u.[id],u.LoginName'
  end
else
	 set @sql='SELECT dbo.GetDatePart(tx.RecordDate) as HandDate,0 as HandID,"" as game,0 as UserID,"" as LoginName,Count(*) as AllHands  FROM Tx 
		      INNER JOIN TxGameDetail tgd ON 
		      tx.[id]=tgd.txid INNER JOIN UserAccount ua ON ua.[id]=tx.AccountID
		      INNER JOIN GameProcess gp ON gp.ID=tgd.GameProcessID '+ @where +
		    ' GROUP BY dbo.GetDatePart(tx.RecordDate)'

 exec(@sql)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntHandsPlayedByUser
       @dtBegin datetime  = null
       ,@dtEnd  datetime  = null
       ,@UserID int=0

 AS

declare	@sql		varchar(8000)
	,@where	varchar(4000)

set @where = ''  

if (@dtBegin is not null and @dtEnd is null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate >=''' + convert(varchar,@dtBegin)+'''')
if (@dtBegin is null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate <=''' + convert(varchar,@dtEnd)+'''')
if (@dtBegin is not null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate BETWEEN ''' + convert(varchar,@dtBegin)+ ''' AND ''' + convert(varchar,@dtEnd)+'''')
if (@UserID>0)
	set @where = dbo.fnGetWhereCause(@where, 'u.[ID] =' + convert(varchar,@UserID))

	 set @sql='SELECT hr.UserID,hr.LoginName,hr.Currency,SUM(hr.AllHands) as Hands FROM (SELECT '
	if @UserID>0
                 set @sql=@sql+'u.[id] as UserID,u.LoginName,'
             else
                 set @sql=@sql+'0 as UserID, "" as LoginName,'

                 set @sql=@sql+'ct.[Name] as Currency,Count(*) as AllHands  FROM Tx (nolock) 
                              INNER JOIN TxGameDetail tgd ON 
                              tx.[id]=tgd.txid INNER JOIN UserAccount ua ON ua.[id]=tx.AccountID '

	if @UserID>0
                 set @sql=@sql+'INNER JOIN vwUsers u ON u.[id]=ua.userID '

                 set @sql=@sql+ 'INNER JOIN CurrencyType ct ON ct.ID=ua.CurrencyTypeID '+ @where +' GROUP BY '

	if @UserID>0   set @sql=@sql+ 'u.[id],u.LoginName,'

                 set @sql=@sql+ 'ct.Name,tgd.GameLogID) as hr GROUP BY hr.UserID,hr.LoginName,hr.Currency'

 print @sql
 exec(@sql)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntMostActivePlayers
      @dtBegin datetime  = null
       ,@dtEnd  datetime  = null
       ,@CurrencyPlay  bit=0
       ,@CurrencyMoney  bit=0

 AS

declare	@sql		varchar(8000)
	,@where	varchar(4000)
              ,@koef		int


set @where = 'WHERE Tx.TxTypeID = 6 OR Tx.TxTypeID = 5'  
set @koef=1

if (@dtBegin is not null and @dtEnd is null)
  begin
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate >=''' + convert(varchar,@dtBegin)+'''')
             set @koef=DATEDIFF(dd,@dtBegin,Getdate())
  end
if (@dtBegin is null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate <=''' + convert(varchar,@dtEnd)+'''')
if (@dtBegin is not null and @dtEnd is not null)
  begin
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate >= ''' + convert(varchar,@dtBegin)+ ''' AND tx.RecordDate <= ''' + convert(varchar,@dtEnd)+'''')
             set @koef=DATEDIFF(dd,@dtBegin,@dtEnd)
  end

if @CurrencyPlay>0 and @CurrencyMoney<=0
	set @where = dbo.fnGetWhereCause(@where, 'ua.CurrencyTypeID=1')
if @CurrencyPlay<=0 and @CurrencyMoney>0
	set @where = dbo.fnGetWhereCause(@where, 'ua.CurrencyTypeID=2')
if @CurrencyPlay>0 and @CurrencyMoney>0
  begin
	set @where = dbo.fnGetWhereCause(@where, 'ua.CurrencyTypeID=1')
             set @where = @where +' or ua.CurrencyTypeID=2'  
  end

set @sql='SELECT u.id,u.LoginName, CONVERT(money, COUNT(tx.id)) / '+convert(varchar,@koef)+' AS Rate 
                FROM         dbo.vwUsers u (nolock) INNER JOIN
                      dbo.UserAccount ua ON ua.UserID = u.id INNER JOIN
                      dbo.Tx ON ua.id = dbo.Tx.AccountID '+ @where+' 
                      GROUP BY u.id,u.LoginName
                      ORDER BY COUNT(u.id)  DESC' 

  exec(@sql)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntMostPopularGames
      @dtBegin datetime  = null
       ,@dtEnd  datetime  = null
       ,@asLeast  bit  =0
 AS

declare	@sql		varchar(8000)
	,@where	varchar(4000)
              ,@koef		int


set @where = 'WHERE Tx.TxTypeID = 6 OR Tx.TxTypeID = 5'  
set @koef=1

if (@dtBegin is not null and @dtEnd is null)
  begin
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate >=''' + convert(varchar,@dtBegin)+'''')
             set @koef=DATEDIFF(dd,@dtBegin,Getdate())
  end
if (@dtBegin is null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate <=''' + convert(varchar,@dtEnd)+'''')
if (@dtBegin is not null and @dtEnd is not null)
  begin
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate >= ''' + convert(varchar,@dtBegin)+ ''' AND tx.RecordDate <= ''' + convert(varchar,@dtEnd)+'''')
             set @koef=DATEDIFF(dd,@dtBegin,@dtEnd)
  end

set @sql='SELECT gp.Name, CONVERT(money, COUNT(u.id)) / '+convert(varchar,@koef)+' AS Rate, gp.id
                FROM         dbo.vwUsers u (nolock) INNER JOIN
                      dbo.UserAccount ua ON ua.UserID = u.id INNER JOIN
                      dbo.Tx ON ua.id = dbo.Tx.AccountID INNER JOIN
                      dbo.TxGameDetail tgd ON tgd.TxID = dbo.Tx.id INNER JOIN
                      dbo.GameProcess gp ON tgd.GameProcessID = gp.id '+ @where+' 
                      GROUP BY gp.id, gp.Name
                      ORDER BY COUNT(u.id) ' 

  if  @asLeast =0
       set @sql=@sql+'DESC' 

  exec(@sql)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntMostWinsForPlayer
       @dtBegin datetime  = null
       ,@dtEnd  datetime  = null
       ,@UserID int=0 
       ,@CurrencyTypeID int=0 

 AS

declare	@sql		varchar(8000)
	,@where	varchar(4000)

set @where = 'WHERE dp.txTypeID=6 '   

if (@dtBegin is not null and @dtEnd is null)
	set @where = dbo.fnGetWhereCause(@where, 'dp.RecordDate >=''' + convert(varchar,@dtBegin)+'''')
if (@dtBegin is null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'dp.RecordDate <=''' + convert(varchar,@dtEnd)+'''')
if (@dtBegin is not null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'dp.RecordDate BETWEEN ''' + convert(varchar,@dtBegin)+ ''' AND ''' + convert(varchar,@dtEnd)+'''')
if (@UserID >0)
	set @where = dbo.fnGetWhereCause(@where, 'u.[ID]=' + convert(varchar,@UserID))

if @CurrencyTypeID<=0 
	set @where = dbo.fnGetWhereCause(@where, 'ua.CurrencyTypeID=2')
else
	set @where = dbo.fnGetWhereCause(@where, 'ua.CurrencyTypeID='+convert(varchar,@CurrencyTypeID))

 set @Sql= 'SELECT p.Amount,p.UserID,p.LoginName,MAX(tx.RecordDate)  as DateWon FROM
                   (SELECT MAX(dbo.fnNullAsMoney (dp.txAmount)) as Amount,u.[ID] as UserID,u.LoginName
                   FROM Tx dp  INNER JOIN UserAccount ua ON ua.[id]=dp.AccountID INNER JOIN vwUsers u ON ua.UserID=u.[ID] ' +
                         @where+' GROUP BY u.[ID],u.LoginName) as p, tx, UserAccount ua,vwUsers u  WHERE  tx.txAmount=p.Amount and
                   ua.[id]=tx.AccountID AND  ua.UserID=u.[ID] and u.ID=p.UserID GROUP BY p.UserID,p.LoginName,p.Amount'
 print @sql
 exec(@sql)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntNotPlayedPlayers
      @dtBegin datetime  = null
       ,@dtEnd  datetime  = null
 AS

declare	@sql		varchar(8000)
	,@where	varchar(4000)

set @where = 'WHERE u.UserTypeID = 1 AND tgd.TxID = tx.[ID] AND ua.[ID] = tx.AccountID AND tx.TxTypeID NOT IN (1, 2, 13, 26)'  

if (@dtBegin is not null and @dtEnd is null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate >=''' + convert(varchar,@dtBegin)+'''')
if (@dtBegin is null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate <=''' + convert(varchar,@dtEnd)+'''')
if (@dtBegin is not null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'tx.RecordDate >= ''' + convert(varchar,@dtBegin)+ ''' AND tx.RecordDate <= ''' + convert(varchar,@dtEnd)+'''')

set @sql='SELECT     id, LoginName, RecordDate FROM dbo.vwUsers u (nolock) 
                 WHERE     (id NOT IN (SELECT  u.[ID]  FROM  dbo.TxGameDetail tgd, dbo.Tx, dbo.vwUsers u INNER JOIN
                                    dbo.UserAccount ua ON ua.UserID = u.id '+ @where+')) AND (UserTypeID = 1)'

 exec(@sql)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntSavePlayPeriod
       @ID  int
      ,@DateFrom   datetime
      ,@DateTo      datetime
      ,@IsClosed	  bit  =null		
 AS

   declare @IsUpdate  bit
      set @isUpdate=1

  if @ID<=0  
      set @isupdate=0
  else
     begin
        if not exists(SELECT [ID] FROM PlayPeriods (nolock) WHERE [ID]=@ID) set @isupdate=0
     end

        if @isupdate=0
          begin
            INSERT INTO PlayPeriods (DateFrom,DateTo) VALUES(@DateFrom,@DateTo)
	set @ID = scope_identity()
          end
        else 
            UPDATE  PlayPeriods SET DateFrom=@DateFrom,DateTo=@DateTo

    if @IsClosed is not null
      UPDATE PlayPeriods SET  IsClosed=@IsClosed WHERE [ID]=@ID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntTimeSpendByUser
       @dtBegin datetime  = null
       ,@dtEnd  datetime  = null
       ,@UserID int=0

 AS

declare	@sql		varchar(8000)
	,@where	varchar(4000)

set @where = ''  

if (@dtBegin is not null and @dtEnd is null)
	set @where = dbo.fnGetWhereCause(@where, 'cs.SessionStart >=''' + convert(varchar,@dtBegin)+'''')
if (@dtBegin is null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'cs.SessionEnd <=''' + convert(varchar,@dtEnd)+'''')
if (@dtBegin is not null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'cs.SessionStart >= ''' + convert(varchar,@dtBegin)+ ''' AND cs.SessionEnd<= ''' + convert(varchar,@dtEnd)+'''')
if (@UserID>0)
	set @where = dbo.fnGetWhereCause(@where, 'u.[ID]=' + convert(varchar,@UserID))


if @UserID > 0
       set @sql='SELECT u.[id] as UserID,u.LoginName,SUM(DATEDIFF(mi,cs.SessionStart,cs.SessionEnd)) as SpentTime  FROM ClientSessionHistory cs (nolock) 
                 INNER JOIN vwUsers u ON u.[id]=cs.UserID '+ @where +
                ' GROUP BY u.[id],u.LoginName ORDER BY u.[id]'
else
       set @sql='SELECT 0 as UserID,"" as LoginName,SUM(DATEDIFF(mi,cs.SessionStart,cs.SessionEnd)) as SpentTime  FROM ClientSessionHistory cs (nolock) 
                 INNER JOIN vwUsers u ON u.[id]=cs.UserID '+ @where 

 exec(@sql)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntUserTransations
       @dtBegin datetime  = null
       ,@dtEnd  datetime  = null
       ,@UserID  int=0

 AS

declare	@sql		varchar(8000)
	,@where	varchar(4000)

set @where = 'WHERE ua.CurrencyTypeID=2'  

if (@dtBegin is not null and @dtEnd is null)
	set @where = dbo.fnGetWhereCause(@where, 'dp.RecordDate >=''' + convert(varchar,@dtBegin)+'''')
if (@dtBegin is null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'dp.RecordDate <=''' + convert(varchar,@dtEnd)+'''')
if (@dtBegin is not null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'dp.RecordDate BETWEEN ''' + convert(varchar,@dtBegin)+ ''' AND ''' + convert(varchar,@dtEnd)+'''')

if @UserID>0
	set @where = dbo.fnGetWhereCause(@where, 'u.[ID]=' + convert(varchar,@UserID))

 set @Sql= 'SELECT  dp.RecordDate,u.LoginName,u.[ID] ,tt.Name,SUM(dbo.fnNullAsMoney (dp.txAmount)) as Amount
                   FROM Tx dp  (nolock) INNER JOIN UserAccount ua ON ua.[ID]=dp.AccountID INNER JOIN [User] u ON u.[ID]=ua.UserID
                   INNER JOIN txType tt ON dp.TxTypeID=tt.[ID]'+
                         @where+' GROUP BY dp.RecordDate,u.[ID],u.LoginName,tt.[Name]  ORDER BY dp.RecordDate,u.[ID]'

 print @sql
 exec(@sql)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].wntUsersSignupAndPlay 
    @dtBegin datetime  = null
    ,@dtEnd  datetime  = null
 AS

declare	@sql		varchar(8000)
	,@where	varchar(4000)

set @where = 'WHERE u.UserTypeID=1'  

if (@dtBegin is not null and @dtEnd is null)
	set @where = dbo.fnGetWhereCause(@where, 'u.RecordDate>=''' + convert(varchar,@dtBegin)+'''')
if (@dtBegin is null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'u.RecordDate<=''' + convert(varchar,@dtEnd)+'''')
if (@dtBegin is not null and @dtEnd is not null)
	set @where = dbo.fnGetWhereCause(@where, 'u.RecordDate BETWEEN ''' + convert(varchar,@dtBegin)+ ''' AND ''' + convert(varchar,@dtEnd)+'''')

  set @sql='SELECT SUM(t.Registered) as Registered, SUM(t.Played) as Played FROM
                  (SELECT COUNT(*) as Registered, 0 as Played FROM  vwUsers u '+ @where + '
                  UNION ALL
                  SELECT 0 as Registered,COUNT(u.[id]) as Played FROM vwUsers u 
                  WHERE u.[ID] IN (SELECT u.[ID] FROM vwUsers u INNER JOIN UserAccount ua ON ua.UserID=u.[ID] 
                  INNER JOIN tx ON tx.AccountID=ua.[ID] '+ @where + ' GROUP BY u.[ID] )) as t'
   print @sql
  exec(@sql)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

