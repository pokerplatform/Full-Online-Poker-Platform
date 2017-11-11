unit uTouConstants;

interface

const
  DefCountOfBettingsOnCoefficient = 22;

// property type constants
  ptInteger     = 1;
  ptCurrency    = 3;
  ptString      = 4;
  ptComboBox    = 5;
  ptCheckBox    = 6;
  ptDateTime    = 7;

// Process Status constants
  pstUnused  = 0;  // GameProcess unused by any Tournament
  pstRunning = 1;  // GameProcess is running
  pstWaiting = 2;  // GameProcess is waiting;

// Time constants
  ttcCheckUpdateLobbyInfo_Sec = 5;
  ttcCheckEvents_Sec = 1;
  ttcCheckFinished_Sec = 30;

//  tournament category type constants
  tsCategoryTournament = 1;
  tsCategorySitAndGo   = 2;

//  tournament type constants
  tseByTime    = 1;
  tseByEnroled = 2;
  tseCombine   = 3;

//  tournament type constants
  ttpRegular    = 1;
  ttpSattelite  = 2;
  ttpRestricted = 3;

// TournamentStatusID constants
  tstAnnouncing    = $1;   // after creation
  tstRegistration  = $2;   // registration open
  tstSitting       = $3;   // registration close init tables
  tstRunning       = $4;   // running
  tstBreak         = $5;   // break
  tstCompleted     = $6;   // completed
  tstStopped       = $7;   // Stop by technical reason
  tstReinit        = $8;   // Reinit after Stop
// Additional TournamentStatusID
  tstResuming      = $10;  // Resume tournament in progress
  tstAdminPause    = $20;  // pause by admin
  tstNoEntrants    = $100; // Resume tournament in progress

// Tournament prize value type
  prvTypePercent    = 1;
  prvTypeFixedValue = 2;

// Root attributes
  Attr_Name           = 'name';
  Attr_CurrType       = 'currencytype';
  Attr_PrizeValueType = 'valuetype';
  Attr_PrizeTypeID    = 'prizetype';

// command
  cmdInit             = 'init';
  cmdPlay             = 'play';
  cmdResume           = 'resume';
  cmdChangePlace      = 'changeplace';
  cmdStandUp          = 'standup';
  cmdRebuy            = 'rebuy';
  cmdEnd              = 'end';
  cmdFree             = 'free';
  cmdBreak            = 'break';
  cmdEvent            = 'event';
  cmdKickOffUsers     = 'kickoffusers';

// event names
  eventFinishTournament = 'finishtournament';
  eventUserLost         = 'userlost';
  eventCongratulations  = 'congratulations';
  eventChangeTable      = 'changetable';
  eventBreak            = 'break';
  eventEndBreak         = 'endbreak';
  eventStart            = 'start';
  eventAutoRegistration = 'autoregistration';

// input actions name
  anProcessCrash       = 'processcrash';
  // self
  anInitTournament     = 'tsinittournament';
  anSetDefaultProperty = 'setdefprop';
  anGetDefaultProperty = 'getdefprop';
  anInitPrizePool      = 'tsinitprizepool';
  anBettings           = 'tsbettings';
  anDropTournament     = 'tsdroptournament';
  anAmdKickoffUser     = 'admtournamentkickoff';
  anAdmPauseAll        = 'admpauseall';
  anAdmPause           = 'admpause';
  // GameEngine
  anGAAction           = 'gaaction';
  anEndOfHand          = 'endofhand';
  // Bots
  anBot_Sitdown        = 'bot_sitdown';
  anBot_GetTableInfo   = 'bot_gettableinfo';
  anBot_StandUp        = 'bot_standup';
  anBot_StandUp_All    = 'bot_standup_all';
  anBot_Policy         = 'bot_policy';

// property name constants
  PropName_TournamentName               = 'Tournament Name';
  PropName_MaxRegisteredGamers          = 'Maximum Number of Registered Gamers';
  PropName_RegistrationStartAt          = 'Registration start at';
  PropName_TournamentStartAt            = 'Tournament start at';
  PropName_TournamentStartType          = 'Tournament start event';
  PropName_TournamentCategory           = 'Category';
  PropName_IntervalBetweenTournaments   = 'Interval between tournaments(days)';
  PropName_DurationRegistration_Start   = 'Duration between registration end and tournament start(min)';
  PropName_IntervalBetweenLevels        = 'Interval between levels(min)';
  PropName_IntervalBetweenBreaks        = 'Interval between breaks(min)';
  PropName_BreakDuration                = 'Break duration(min)';
  PropName_TimeOutForKickOff            = 'Time out for kick off (min)';
  PropName_TypeOfTournament             = 'Type of tournament';
  PropName_MasterTournamentID           = 'Master tournamentID(for satelitte only)';
  PropName_Password                     = 'Password (for restricted only)';
  PropName_BuyIn                        = 'BuyIn';
  PropName_Fee                          = 'Fee';
  PropName_AmountChipsForParticipant    = 'Amount of chips for participant';
  PropName_CurrencyType                 = 'Currency type';
  PropName_RebuyIsAllowed               = 'Rebuy is allowed';
  PropName_AddOnIsAllowed               = 'Add-On is allowed';
  PropName_MaximumCountRebuy            = 'Maximum count of rebuy (0 - not limited)';
  // GameEngine properties
  PropName_PokerType                    = 'Poker Type';
  PropName_TypeOfStakes                 = 'Type of Stakes';
  PropName_LowerLimitOfStakes           = 'Lower Limit Of The Stakes';
  PropName_MaximumChairsCount           = 'Maximum Chairs Count';
  PropName_TournamentType               = 'Tournament Type';

// Defoult values property constants
  PropDef_MaxRegisteredGamers        =  0;
  PropDef_RegistrationTimeShift      =  1; // min
  PropDef_TournamentStartShift       = 30; // min
  PropDef_IntervalBetweenTournaments =  0; // days
  PropDef_DurationRegistration_Start =  1; // min
  PropDef_IntervalBetweenLevels      = 10; // min
  PropDef_IntervalBetweenBreaks      = 60; // min
  PropDef_BreakDuration              =  5; // min
  PropDef_TimeOutForKickOff          = 10; // min
  PropDef_BuyIn                      = 20;
  PropDef_Fee                        =  2;
  PropDef_AmountChipsForParticipant  = 1000;
  PropDef_CurrencyType               =  2;
  PropDef_RebuyIsAllowed             = 'false';
  PropDef_AddOnIsAllowed             = 'false';
  PropDef_MaximumCountRebuy          = 3;

implementation

end.
