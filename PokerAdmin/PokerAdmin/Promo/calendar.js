

<SCRIPT LANGUAGE="JavaScript">

<!--
var count = 0;
function IsLeapYear( iYear )
{
   if( iYear % 400 == 0 || ( iYear % 4 == 0 && iYear % 100 != 0 ) )
      return 1;
   else
      return 0;
}
function dateFix(FixDate, WorkType)
{
    if ( !( WorkType == 5 && FixDate == "" ) )
    { 
        var dt = new Date(FixDate);

        if ( FixDate.indexOf('/') >= 0 )
        {
            if ( isNaN(Date.parse(FixDate)) )
            {
                dt = new Date();
                od = dt.getDate();
                om = dt.getMonth();
                oy = dt.getYear();
                
                FixDate = (om + 1) + '/' + od + '/' + oy;
            }
        }
        else
        {
            dt = new Date();
            od = dt.getDate();
            om = dt.getMonth();
            oy = dt.getYear();

            FixDate = (om + 1) + '/' + od + '/' + oy;
        }

        var oy
        var om
        var od
        var a
        od = dt.getDate();
        om = dt.getMonth() + 1;
        oy = dt.getYear();

        if ( WorkType == 1 )
        {
            // to sunday 
            while ( !( dt.getDay() == 0 ) )
            {
                dt.setTime(dt - 1000 * 60 * 60 * 24);
            }
        }
        if ( WorkType == 2 )
        {
            // to monday
            while ( !( dt.getDay() == 1 ) )
            {
                dt.setTime(dt - 1000 * 60 * 60 * 24);
            }
        }
        if ( WorkType == 21 )
        {
            // to yestermonday
            dt = new Date();
            // to first monday
            while ( !( dt.getDay() == 1 ) )
            {
                dt.setTime(dt - 1000 * 60 * 60 * 24);
                od = dt.getDate();
                om = dt.getMonth();
                oy = dt.getYear();
            }
            //  to  prev sunday
            //window.alert("|<first "+dt);
            dt.setTime(dt - 1000 * 60 * 60 * 24);
            //window.alert("|<two "+dt);                        
            //  to  prvios monday back
            while ( !( dt.getDay() == 1 ) )
            {
                dt.setTime(dt - 1000 * 60 * 60 * 24);
                od = dt.getDate();
                om = dt.getMonth();
                oy = dt.getYear();
            } 
            //window.alert("|<|<three min "+dt);
            a = dt;                                              
            var min_dt = dt.getTime();
            // to thursday forward
            dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24)); // to +
            //window.alert(">||<four "+dt);
            //to monday forward
            while ( !( dt.getDay() == 1 ) ) 
            {
                dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24));
            }
            //  to  thursday forward
            //window.alert(">|>|five "+dt);                        
            dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24)); // to +
            //window.alert(">|>|>|six "+dt);
            //to monday forward                         
            while ( ! ( dt.getDay() == 1 ) )
            {
                dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24));
            }
            //  to  monday forward
            //window.alert(">|>|>|seven max "+dt);                        
            b = dt;
            var max_dt = dt.getTime();
            var dt = new Date(FixDate);
            dt.setTime(dt.getTime() + parseInt(1));
            //window.alert(a+" < "+dt+' < '+b);
            //window.alert(min_dt+" < "+dt.getTime()+' < '+max_dt);                        
            //window.alert('1)'+((dt.getTime()>=min_dt) ));
            //window.alert('2)'+((dt.getTime()<max_dt)));
            if ( !( ( dt.getTime() >= min_dt ) && ( dt.getTime() < max_dt ) ) )
            {
                // in not in curr two week
                dt = new Date();
            }
            else
            {
                var dt = new Date(FixDate);
            }
        }

        if ( WorkType == 3 )
        {
            // week control
            while ( !( dt.getDay() == 1 ) )
            { 
                dt.setTime(dt - 1000 * 60 * 60 * 24);
                od = dt.getDate();
                om = dt.getMonth();
                oy = dt.getYear();
            }
            //  to  monday back
            var min_dt = dt.getTime();
            dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24)); // to +
            while ( !( dt.getDay() == 1 ) )
            {   
                dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24));
            }
            //  to  monday forward
            var max_dt = dt.getTime();
            var dt = new Date();
            
            if ( !( ( dt.getTime() >= min_dt ) && ( dt.getTime() < max_dt ) ) )
            {
            // in not in curr week
                dt = new Date();
            }
            else
            {
                var dt = new Date(FixDate);
            }
        }       

        if ( WorkType == 4 )
        {
            // week control
            beginyear = new Date();
            beginyear = dt.getYear();
            min_dt = new Date('01/01/'+beginyear);
            var last_sunday = new Date();
            od = last_sunday.getDate();
            om = last_sunday.getMonth();
            oy = last_sunday.getYear();
            last_sunday = new Date((om + 1) + '/' + od + '/' + oy);
            while ( !( last_sunday.getDay() == 0 ) )
            {
                last_sunday.setTime(last_sunday.getTime() + parseInt(1000 * 60 * 60 * 24));
            }
            //  to  monday forward 00:00
            if ( ( dt.getTime() < (last_sunday.getTime() + parseInt(1000 * 60 * 60 * 24) ) ) )
            {
                dt = new Date(FixDate);
            }
            else
            {
                dt = new Date();
            }
        }

        od = dt.getDate();
        om = dt.getMonth();
        oy = dt.getYear();
        om = parseInt(om) + 1;

        if ( parseInt(om) < 10 )
        {
            om = '0' + om;
        }

        if ( parseInt(od) < 10 )
        {
            od = '0' + od;
        }

        if ( parseInt(oy) < 1975 )
        {
            oy = 2000;
        }

        var my_date = om + '/' + od + '/' + oy;
        return my_date;
    }
    else
    {
        // 5 - enable null value
        return '';
    }
}
// Cool calendar by Nick
var CurrentFieldName = '';
var DivOpened = true;
// 0 any day clickable
// 1 to sunday
// 2 to monday
// 3 if not current week then now
// 4 from year begin to currweek
var CalWorkType = 0;

function CalHide()
{
    count = 0;
    document.all['calendar'].style.visibility = 'hidden';
    document.calendar.document.body.innerHTML = "";
}

function SetNow()
{
    CalHide();
    var dt1 = new Date();
    m_n = parseInt(dt1.getMonth() + 1);
    if ( parseInt(m_n) < 10 )
    {
        m_n = '0' + m_n;
    }
    curr_day = dt1.getDate();
    year = dt1.getYear();
    set_date(dt1.getDate());
    return 1;
}
  
function set_today(some)
{
    //correct div position
    if (count != 0)
		return;
    count++;
    deltaX = -50;
    deltaY = 20;
    main_some = some;

    
    if ( CurrentFieldName == 'AutorizationDate' )
    {
        deltaX = -350;
        deltaY = -120;
    }
    if ( CurrentFieldName == 'OperationDate' )
    {
        deltaX = 80;
        deltaY = -100;
    }
    if ( CurrentFieldName == 'ExpireDate' )
    {
        deltaX = -350;
        deltaY = -100;
    }
    if ( CurrentFieldName == 'FirstPaymentDate' )
    {
        deltaX = -310;
        deltaY = -130;
    }
    if ( CurrentFieldName == 'tbCloseDay' )
    {
        deltaX = -250;
        deltaY = - 50;
    }
    if ( CurrentFieldName == 'textBoxContactDate' )
    {
        deltaX =  10;
        deltaY = -50;
    }
    
    document.all['calendar'].style.left = event.clientX + deltaX;
    document.all['calendar'].style.top  = event.clientY + deltaY;
    document.all['calendar'].style.visibility = 'visible';

    if ( some.form(CurrentFieldName).value == '' )
    {
        today = new Date();
    }
    else
    {
        today = new Date(some.form(CurrentFieldName).value);
    } 
    
    year = today.getYear();
    my_year = year;
    month_num = today.getMonth();
    my_month = month_num;
    day = today.getDate();
    week_day = today.getDay();
    get_month_name(month_num);

    m_name = '';
    num_days = 0;
    first_day = new Date(year, month_num, 1);
    first_num = first_day.getDay();
    get_month_name(month_num);
      
    create_calendar();
    document.all['calendar'].style.width = document.calendar.document.body.scrollWidth + 5;
    document.all['calendar'].style.height = document.calendar.document.body.scrollHeight + 4;
}

function get_month_name(month_num)
{
    switch (month_num)
    {
        case 0:
            m_name = 'January';
            num_days = 31;
            m_n = '01';
            break;
        case 1:
            m_name = 'February';
            IsLeapYear(year) ? num_days = 29 : num_days = 28;
            m_n = '02';
            break; 
        case 2:
            m_name = 'March';
            num_days = 31;
            m_n = '03';
            break;
        case 3:
            m_name = 'April';
            num_days = 30;
            m_n = '04';
            break;
        case 4:
            m_name = 'May';
            num_days = 31;
            m_n = '05';
            break;
        case 5:
            m_name = 'June';
            num_days = 30;
            m_n = '06';
            break;
        case 6:
            m_name = 'July';
            num_days = 31;
            m_n = '07';
            break; 
        case 7:
            m_name = 'August';
            num_days = 31;
            m_n = '08';
            break;
        case 8:
            m_name = 'September';
            num_days = 30;
            m_n = '09';
            break;
        case 9:
            m_name = 'October';
            num_days = 31;
            m_n = '10';
            break;
        case 10:
            m_name = 'November';
            num_days = 30;
            m_n = '11';
            break;
        case 11:
            m_name = 'December';
            num_days = 31;
            m_n = '12';
            break;
    } 
}

function create_calendar()
{
    my_htm = '';
    my_htm = '';
    my_htm += '<HTML><HEAD><LINK href="' + '<%=GetCssPageUrl()%>' + '" type=text/css rel=stylesheet>';
    my_htm += '</head><body ><TABLE width=100% border=0 class=Header><TR><TD colspan=2>';
    my_htm += '<TABLE width=100% border=0 class=SubHeader style="color:#666666;background:#EFEFEF">' +
        '<TR>' +
            '<TD><INPUT TYPE=button class=cButton value="<<" onClick=parent.prev_month();></TD>' +
            '<TD colspan=5>' + m_name + '&nbsp;' + year + '</TD>' +
            '<TD><INPUT TYPE=button class=cButton value=">>" onClick=parent.next_month();></TD></TR>' +
        '<TR><TD colspan=7>&nbsp;</TD></TR><TR>' +
            '<TD>Sun</TD><TD>Mon</TD><TD>Tue</TD><TD>Wed</TD><TD>Thu</TD><TD>Fri</TD><TD>Sat</TD></TR>';
    c = 0;
    d = 0;
    enable = '';
        
    // search first and last weekday
    var dt = new Date();
    if ( CalWorkType == 3 )
    {
        while ( !( dt.getDay() == 1 ) )
        {
            dt.setTime(dt - 1000 * 60 * 60 * 24);
        }
        //  to  monday back
        var min_dt = dt.getTime();
        // prev monday
    }
    if ( CalWorkType == 21 )
    {
        while ( !( dt.getDay() == 1 ) )
        {
            dt.setTime(dt - 1000 * 60 * 60 * 24);
        }
        //  to  monday back
        dt.setTime(dt - 1000 * 60 * 60 * 24);
        while ( !( dt.getDay() == 1 ) )
        {
            dt.setTime(dt - 1000 * 60 * 60 * 24);
        }
        //  to  monday back                                
        var min_dt = dt.getTime();
        // prev monday
    }

    if ( CalWorkType == 4 )
    {                            
        beginyear = new Date();
        beginyear = dt.getYear();
        min_dt = new Date('01/01/1975');
    }
    dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24)); // to one day forward
    while ( !( dt.getDay() == 1 ) )
    {
        dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24));
    }
    //   to  monday forward
    if ( CalWorkType == 21 )
    {              
        dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24));
        while ( !( dt.getDay() == 1 ) )
        {
            dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24));
        }
        // to monday forward
    }
    var max_dt = dt.getTime();
    // next monday
    // #search
    for ( i = 1; d < num_days; i++ )
    {
        c = ++c;
        if ( c <= 7 )
        {
            if ( i <= first_num )
            {
                my_htm += '<TD></TD>';
            }
            else
            {
                d = ++d;
                if ( d == day && month_num == my_month && my_year == year )
                {
                    bgrd = ' style=background:#FFFFFF';
                }
                else
                {
                    bgrd = '';
                }
                enable = ' disabled ';

                if ( CalWorkType == 0 )
                {
                    enable = '';
                }

                if ( CalWorkType == 1 && c == 1 )
                {
                    enable = '';
                }

                if ( CalWorkType == 2 && c == 2 )
                {
                    enable = '';
                }

                if ( CalWorkType == 3 )
                {
                    var sdt = new Date((parseInt(month_num) + 1) + '/' + (parseInt(d) + 1) + '/' + year);
                    if ( !( sdt.getTime() >= min_dt && sdt.getTime() < max_dt ) )
                    {
                        // in not in curr week
                        enable = 'disabled';
                    }
                    else
                    {
                        enable = '';
                    }
                }

                if ( CalWorkType == 21 )
                {
                    var sdt = new Date((parseInt(month_num) + 1) + '/' + (parseInt(d) + 1) + '/' + year);
                    if ( !( sdt.getTime() >= min_dt && sdt.getTime() < max_dt ) )
                    {
                        // in not in curr week
                        enable = 'disabled';
                    }
                    else
                    {
                        enable = '';
                    }
                }

                if ( CalWorkType == 4 )
                {
                    var sdt = new Date((parseInt(month_num) + 1) + '/' + (parseInt(d) + 1) + '/' + year);
                    if ( !( sdt.getTime() > min_dt && sdt.getTime() < max_dt ) )
                    {
                        // in not in curr week
                        enable = 'disabled';
                    }
                    else
                    {
                        enable = '';
                    }
                }

                if ( enable == '' )
                {
                    my_htm += '<TD><input type=button class=cButton value='+d+' style=width:23px'+bgrd+' onClick=parent.set_date('+d+');></TD>';
                }
                else
                {
                    my_htm += '<TD>'+d+'</TD>';
                }
            }       
        }
        else
        {
            my_htm += '</tr><tr>';
            c = 0;
        }
    }
    my_htm += '</TABLE></TD></TR><TR><TD><input type=button class=cButton value="today" style=width:100px onClick="parent.SetNow(this);"></TD><TD><input type=button class=cButton value="close" style=width:100px onClick="parent.CalHide();"></TD></TR></TABLE>';
	my_htm += '</body></html>'
    //document.calendar.document.body.innerHTML = my_htm;	
    document.calendar.document.write (my_htm);	
}

function next_month()
{
    my_htm = "";
    CalHide();
    count++;
    document.all.calendar.style.visibility = 'visible';
    if ( month_num == 11 )
    {
        year = ++year;
        month_num = 0;
    }
    else
    {
        month_num = ++month_num;
    }
    first_day = new Date(year, month_num, 1);
    first_num = first_day.getDay();
    get_month_name(month_num);
    create_calendar();
    document.all['calendar'].style.width  = document.calendar.document.body.offsetWidth ;
    document.all['calendar'].style.height = document.calendar.document.body.scrollHeight + 4;	
}

function prev_month()
{
    my_htm = "";
    CalHide();
    count++;
    document.all.calendar.style.visibility = 'visible';

    if ( month_num == 0 )
    {
        year = --year;
        month_num = 11;
    }
    else
    {
        month_num = --month_num;
    }
    first_day = new Date(year, month_num, 1);
    first_num = first_day.getDay();
    get_month_name(month_num);
    create_calendar();
    document.all['calendar'].style.width  = document.calendar.document.body.offsetWidth ;
    document.all['calendar'].style.height = document.calendar.document.body.scrollHeight + 4;	
}

function set_date(curr_day)
{
    CalHide();
    my_htm = "";
    var my_date = m_n + '/' + curr_day + '/' + year;
    //var my_date=curr_day+'/'+year;
    var dt = new Date(my_date);
    var om;
    var od;
    var a;
    od = dt.getDate();
    om = dt.getMonth();
    oy = dt.getYear();

    if ( CalWorkType == 1 )
    {
        // to sunday 
        while ( !( dt.getDay() == 0 ) )
        {
            dt.setTime(dt - 1000 * 60 * 60 * 24);
        }
    }
    if ( CalWorkType == 2 )
    {
        // to monday
        while ( !( dt.getDay() == 1 ) )
        {
            dt.setTime(dt - 1000 * 60 * 60 * 24);
        }
    }
    if ( CalWorkType == 21 )
    {
        // to monday
        //
    }
    if ( CalWorkType == 3 )
    {
        // week control
        while ( !( dt.getDay() == 1 ) )
        {
            dt.setTime(dt - 1000 * 60 * 60 * 24);
            od = dt.getDate();
            om = dt.getMonth();
            oy = dt.getYear();
        }
        //  to  monday back
        var min_dt = dt.getTime();
        dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24)); // to +
        while ( !( dt.getDay() == 1 ) )
        {
            dt.setTime(dt.getTime() + parseInt(1000 * 60 * 60 * 24));
        }
        //  to  monday forward
        var max_dt = dt.getTime();
        var dt = new Date();
        if ( !( dt.getTime() >= min_dt && dt.getTime() < max_dt ) )
        {
            // in not in curr week
            dt = new Date();
        }
        else
        {
            dt = new Date(my_date);
        }
    }

    if ( CalWorkType == 4 )
    {
        // week control
        beginyear = new Date();
        beginyear = dt.getYear();
        min_dt = new Date('01/01/1975');
        var last_sunday = new Date();
        od = last_sunday.getDate();
        om = last_sunday.getMonth();
        oy = last_sunday.getYear();
        last_sunday = new Date((om + 1) + '/' + od + '/' + oy);
        while ( !( last_sunday.getDay() == 0 ) )
        {
            last_sunday.setTime(last_sunday.getTime() + parseInt(1000 * 60 * 60 * 24));
        }
        //  to  monday forward 00:00
        if ( dt.getTime() < (last_sunday.getTime() + parseInt(1000 * 60 * 60 * 24) ) )
        {
            dt = new Date(my_date);
        }
        else
        {
            dt = new Date();
        }
    }

    od = dt.getDate();
    om = dt.getMonth();
    oy = dt.getYear();
    om = parseInt(om) + 1;
    if ( parseInt(om) < 10 )
    {
        om = '0' + om;
    }
    if ( parseInt(od) < 10 )
    {
        od = '0' + od;
    }
    my_date = om + '/' + od + '/' + oy;
    main_some.form(CurrentFieldName).value = my_date;
    document.all['calendar'].style.visibility = 'hidden';
}

//-->
</SCRIPT>
