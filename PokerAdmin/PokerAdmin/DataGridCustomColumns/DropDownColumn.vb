Imports System.Web.UI.WebControls
Imports System.Web.UI

Public Class DropDownColumn
    Inherits DataGridColumn

    Private mDataSource As ICollection
    Private mDataField As String
    Private mDataTextField As String
    Private mDataValueField As String
    Private mWithEmptyItem As Boolean = False

    Public Property DataSource() As ICollection
        Get
            Return mDataSource
        End Get
        Set(ByVal Value As ICollection)
            mDataSource = Value
            If TypeOf mDataSource Is DataView Then
                CType(mDataSource, DataView).Sort = DataValueField
            End If
        End Set
    End Property

    Public Property DataField() As String
        Get
            Return mDataField
        End Get
        Set(ByVal Value As String)
            mDataField = Value
        End Set
    End Property

    Public Property DataTextField() As String
        Get
            Return mDataTextField
        End Get
        Set(ByVal Value As String)
            mDataTextField = Value
        End Set
    End Property

    Public Property DataValueField() As String
        Get
            Return mDataValueField
        End Get
        Set(ByVal Value As String)
            mDataValueField = Value
        End Set
    End Property

    Public Property WithEmptyItem() As Boolean
        Get
            Return mWithEmptyItem
        End Get
        Set(ByVal Value As Boolean)
            mWithEmptyItem = Value
        End Set
    End Property

    Public Overrides Sub InitializeCell(ByVal cell As TableCell, ByVal columnIndex As Integer, ByVal itemType As ListItemType)
        MyBase.InitializeCell(cell, columnIndex, itemType)
        Select Case itemType
            Case ListItemType.Header
                cell.Text = HeaderText
            Case ListItemType.Item, ListItemType.AlternatingItem, ListItemType.SelectedItem
                AddHandler cell.DataBinding, AddressOf ItemDataBinding
            Case ListItemType.EditItem
                AddHandler cell.DataBinding, AddressOf EditItemDataBinding
                Dim DDL As New DropDownList
                cell.Controls.Add(DDL)
            Case Else
                cell.Text = "unknown ItemType"
        End Select
    End Sub

    Private Sub ItemDataBinding(ByVal sender As Object, ByVal e As EventArgs)
        Dim cell As TableCell = CType(sender, TableCell)
        Dim DGI As DataGridItem = CType(cell.NamingContainer, DataGridItem)
        Try
            If TypeOf DataSource Is ArrayList Then
                Dim al As ArrayList = DataSource
                If DGI.DataItem(DataField) >= 0 And DGI.DataItem(DataField) <= al.Count - 1 Then
                    cell.Text = al(DGI.DataItem(DataField))
                Else
                    cell.Text = "< Error value >"
                End If
            Else
                Dim dv As DataView = DataSource
                Dim dr As Integer = dv.Find(DGI.DataItem(DataField))
                If dr >= 0 Then
                    cell.Text = dv.Item(dr)(DataTextField)
                Else
                    cell.Text = DataTextField + "_" + dr.ToString() + " ? : " + DGI.DataItem(DataField).ToString()
                End If
            End If
        Catch RangeEx As IndexOutOfRangeException
            Throw New Exception("Specified DataField was not found.")
        Catch OtherEx As Exception
            Throw New Exception(OtherEx.InnerException.ToString)
        End Try
    End Sub

    Private Sub EditItemDataBinding(ByVal sender As Object, ByVal e As EventArgs)
        Dim cell As TableCell = CType(sender, TableCell)
        Dim DDL As DropDownList = CType(cell.Controls(0), DropDownList)
        Dim DataSourceItem As Object
        Dim item As ListItem
        Dim DGI As DataGridItem
        Dim idx As Integer

        'Add a first, blank option
        If WithEmptyItem Then DDL.Items.Add(New ListItem(""))
        For Each DataSourceItem In DataSource
            Select Case DataSourceItem.GetType.ToString
                Case "System.String" 'Applies to ArrayList 
                    idx = CType(DataSource, ArrayList).IndexOf(DataSourceItem)
                    item = New ListItem(DataSourceItem, idx)
                    DDL.Items.Add(item)
                Case "System.Data.DataRowView"
                    Dim DRV As DataRowView = CType(DataSourceItem, DataRowView)
                    item = New ListItem(DRV(DataTextField), DRV(DataValueField))
                    DDL.Items.Add(item)
                Case Else
                    Throw New Exception("Invalid DataSource type.")
            End Select
        Next

        Try
            DGI = CType(cell.NamingContainer, DataGridItem)
            item = DDL.Items.FindByValue(DGI.DataItem(DataField))
        Catch RangeEx As IndexOutOfRangeException
            Throw New Exception("Specified DataField was not found.")
        Catch OtherEx As Exception
            Throw New Exception(OtherEx.InnerException.ToString)
        End Try

        If Not item Is Nothing Then item.Selected = True
    End Sub

    Public Property Width(ByVal tc As TableCell) As Unit
        Get
            Dim DDL As DropDownList = CType(tc.Controls(0), DropDownList)
            Return DDL.Width
        End Get
        Set(ByVal Value As Unit)
            Dim DDL As DropDownList = CType(tc.Controls(0), DropDownList)
            DDL.Width = Value
        End Set
    End Property

End Class
