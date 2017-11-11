if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetDatePart]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetDatePart]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION [dbo].GetDatePart (@dt DateTime)  
RETURNS datetime AS  
BEGIN 
    declare @m int,@d int, @y int
    declare @s varchar(50)

    set @m=Datepart(mm,@dt)
    set @d=Datepart(dd,@dt)
    set @y=Datepart(yyyy,@dt)

    set @s= convert(varchar,@y)+'-'+ convert(varchar,@m)+'-'+convert(varchar,@d)
   return convert(datetime,@s)
END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

