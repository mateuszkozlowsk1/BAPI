*&---------------------------------------------------------------------*
*& Report zp_load_business_partners
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zp_load_business_partners.

DATA: lv_dataset           TYPE  string,
      lv_message           TYPE  string,
      lv_dataset_line      TYPE  string,
      ls_centraldata       TYPE  bapibus1006_central,
      ls_centraldataperson TYPE  bapibus1006_central_person,
      ls_adressdata        TYPE  bapibus1006_address.

lv_dataset = '/usr/sap/NPL/D00/work/personal_data.csv'.

OPEN DATASET lv_dataset FOR INPUT MESSAGE lv_message IN TEXT MODE ENCODING DEFAULT.

IF sy-subrc <> 0.
  WRITE : lv_message.
ENDIF.

DO.
  READ DATASET lv_dataset INTO lv_dataset_line.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  SPLIT lv_dataset_line AT ',' INTO TABLE DATA(lt_split_dataset).
  IF sy-index = 1.
    CLEAR lt_split_dataset.
    CONTINUE.
  ENDIF.

  CHECK lt_split_dataset IS NOT INITIAL.

  ls_centraldataperson-firstname = lt_split_dataset[ 1 ].
  ls_centraldataperson-lastname = lt_split_dataset[ 2 ].
  ls_adressdata-postl_cod1 = lt_split_dataset[ 3 ].
  ls_adressdata-city = lt_split_dataset[ 4 ].
  ls_adressdata-country = 'PL'.




  CALL FUNCTION 'BAPI_BUPA_CREATE_FROM_DATA'
    EXPORTING
      partnercategory   = '1'
      centraldata       = ls_centraldata
      centraldataperson = ls_centraldataperson
      addressdata       = ls_adressdata.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.



ENDDO.

CLOSE DATASET lv_dataset.
