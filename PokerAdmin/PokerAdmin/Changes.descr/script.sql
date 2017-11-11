if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PushingContent]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PushingContent]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PushingContentFiles]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PushingContentFiles]
GO

CREATE TABLE [dbo].[PushingContent] (
	[ID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [varchar] (50) COLLATE Cyrillic_General_CI_AS NOT NULL ,
	[ActivateDate] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PushingContentFiles] (
	[ID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [varchar] (50) COLLATE Cyrillic_General_CI_AS NOT NULL ,
	[URL] [varchar] (250) COLLATE Cyrillic_General_CI_AS NOT NULL ,
	[PushingContentID] [int] NOT NULL ,
	[Version] [int] NOT NULL ,
	[FileSize] [int] NOT NULL ,
	[ModifyDate] [datetime] NOT NULL ,
	[Width] [int] NOT NULL ,
	[Height] [int] NOT NULL ,
	[PushingContentTypeID] [int] NOT NULL 
) ON [PRIMARY]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PushingContentType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PushingContentType]
GO

CREATE TABLE [dbo].[PushingContentType] (
	[ID] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE Cyrillic_General_CI_AS NOT NULL 
) ON [PRIMARY]
GO





if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[admDeletePushingContentFile]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[admDeletePushingContentFile]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[admDeletePushingContentList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[admDeletePushingContentList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[admGetPushingContentFileDetails]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[admGetPushingContentFileDetails]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[admGetPushingContentFilesList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[admGetPushingContentFilesList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[admGetPushingContentList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[admGetPushingContentList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[admSavePushingContentFile]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[admSavePushingContentFile]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[admSavePushingContentList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[admSavePushingContentList]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].admDeletePushingContentFile
     @IDs	varchar(8000)
 AS

     DELETE  PushingContentFiles from  PushingContentFiles bm inner join dbo.fnGetIDasTable(@IDs, ',') si on bm.[id] = si.[id]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].admDeletePushingContentList
   @IDs	varchar(8000)
 AS

  delete PushingContent from PushingContent f inner join dbo.fnGetIDasTable(@IDs, ',') si on f.[id] = si.[id] 
    WHERE f.[id] NOT IN (SELECT PushingContentID FROM PushingContentFiles GROUP BY  PushingContentID)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].admGetPushingContentFileDetails
   @id  int
AS

     select [Name],URL, PushingContentID, Version,FileSize, ModifyDate, Width, Height ,PushingContentTypeID from PushingContentFiles WHERE [ID]=@ID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].admGetPushingContentFilesList 
   @Contentid  int
AS

     select [id],[Name],URL, PushingContentID, Version,FileSize, ModifyDate, Width, Height ,PushingContentTypeID  from PushingContentFiles WHERE PushingContentID=@Contentid
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].admGetPushingContentList
 AS

SELECT     [ID], [Name], ActivateDate  FROM dbo.PushingContent pc
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [dbo].admSavePushingContentFile
   @id  int
   ,@Name varchar(50)=''
   ,@URL varchar(250)=''
   ,@PushingContentID   int
   ,@FileSize int=0
   ,@Width int=0 
   ,@Height int=0
   ,@ContentTypeID  int
   ,@Version int =-1 
 AS


  if not exists (SELECT [id] FROM PushingContentFiles WHERE [id]=@id)
   begin
     INSERT INTO PushingContentFiles ([Name],URL,PushingContentID,FileSize,Width,Height,ModifyDate,Version,PushingContentTypeID) 
               VALUES (@Name,@URL,@PushingContentID,@FileSize,@Width,@Height,GetDate(),1,@ContentTypeID)
     set @id=@@identity
   end
  else
      UPDATE PushingContentFiles SET [Name]=@Name,URL=@URL,PushingContentID=@PushingContentID,FileSize=@FileSize,
            Width=@Width,Height=@Height,ModifyDate=GetDate(),Version = (case  @Version when  -1 then  Version + 1 else Version end) ,
            PushingContentTypeID=@ContentTypeID WHERE [id]=@id

  if @@Error <>0
       return -1
  else
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

CREATE PROCEDURE [dbo].admSavePushingContentList
   @id  int
   ,@Name varchar(50) =''
   ,@ActivateDate  datetime=null
 AS

  if @ActivateDate is null  set @ActivateDate=getdate()

 if not exists (SELECT TOP 1 [id] FROM PushingContent WHERE [id]=@id)
   begin
       INSERT INTO PushingContent ([Name], ActivateDate) VALUES (@Name, @ActivateDate)
       set @id=@@identity
   end
 else
   UPDATE PushingContent SET [Name]=@Name, ActivateDate=@ActivateDate WHERE [id]=@id

  return @id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

