if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[webGetUserByScreenName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[webGetUserByScreenName]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE [dbo].webGetUserByScreenName
	@ScreenName	varchar(20)
AS

select	[id], FirstName, LastName, LoginName, Email, Location
from	[User] (nolock) 
where	LoginName = @ScreenName
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

