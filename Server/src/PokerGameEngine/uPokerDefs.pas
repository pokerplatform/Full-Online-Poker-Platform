unit uPokerDefs;

interface

////////////////////////////////////////////////////////////////////////////////
// Game engine error codes:
////////////////////////////////////////////////////////////////////////////////
const
  GE_ERR_CODE_BASE              = 2000;
  GE_ERR_NOT_DEFINED            = GE_ERR_CODE_BASE+1;
  GE_ERR_WRONG_PACKET           = GE_ERR_CODE_BASE+2;
  GE_ERR_UNSUPPORTED_ACTION     = GE_ERR_CODE_BASE+3;
  GE_WRONG_PROCESS_ID           = GE_ERR_CODE_BASE+4;
  GE_ERR_STATE_CREATION_FAILURE = GE_ERR_CODE_BASE+5;
  GE_ERR_STATE_LOAD_FAILURE     = GE_ERR_CODE_BASE+6;
  GE_ERR_STATE_STORE_FAILURE    = GE_ERR_CODE_BASE+7;
  GE_ERR_HAS_NOT_CHILD_NODES    = GE_ERR_CODE_BASE+8;
  GE_TIMEOUT_ON_NOTFINISHEDHAND = GE_ERR_CODE_BASE+9;
  //
  GE_ERR_SPECIAL_WITHOUT_REINIT = 2050;


implementation

end.
