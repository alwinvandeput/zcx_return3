# Introduction
ABAP exception class for handling all kind of procedural and OO error messages

This is a generic ABAP Exception Handling class which combines the good old SAP MESSAGEs (SE91 messages) and BAPIRET2 structure.

For more information, see SAP blog:
https://blogs.sap.com/2020/05/11/abap-exception-class-zcx_return3

# ZCX_RETURN3_750.abap
This class is for ABAP 750 and above.

It support statement RAISE EXCEPTION ... [USING] MESSAGE ... .
Example:

        RAISE EXCEPTION TYPE zcx_return3
          MESSAGE e058(00)
          WITH '1' '2' '3' '4'.

# ZCX_RETURN3.abap
This class is for ABAP 740 and before. It does not support statement RAISE EXCEPTION with [USING] MESSAGE.

# ZCA_ZCX_RETURN3_TEMPLATES.abap
This program contains all code templates (a.k.a snippets or patterns) for adding quickly error handling code. 
It contains the templates for raising and catching ZCX_RETURN3 exceptions.

# ZCA_ZCX_RETURN3_UNIT_TEST.abap
This ABAP program executes the unit tests for class ZCX_RETURN3.
Start the unit test with Ctrl + Shift + F10.
