--
--  TMTEST / BODY
--
--  DESCRIPTION:
--
--  This package is the implementation of Timer Check Test of the RTEMS
--  Timing Test Suite.
--
--  DEPENDENCIES: 
--
--  
--
--  COPYRIGHT (c) 1989-1997.
--  On-Line Applications Research Corporation (OAR).
--  Copyright assigned to U.S. Government, 1994.
--
--  The license and distribution terms for this file may in
--  the file LICENSE in this distribution or at
--  http://www.OARcorp.com/rtems/license.html.
--
--  $Id$
--

with TIMER_DRIVER;
with INTERFACES; use INTERFACES;
with RTEMS;
with TEST_SUPPORT;
with TEXT_IO;
with TIME_TEST_SUPPORT;
with UNSIGNED32_IO;

package body TMTEST is

--PAGE
-- 
--  INIT
--

   procedure INIT (
      ARGUMENT : in     RTEMS.TASK_ARGUMENT
   ) is
      STATUS : RTEMS.STATUS_CODES;
   begin

      TEXT_IO.NEW_LINE( 2 );
      TEXT_IO.PUT_LINE( "*** TIME TEST CHECK ***" );

      TIMER_DRIVER.SET_FIND_AVERAGE_OVERHEAD( TRUE );

      TMTEST.TASK_NAME( 1 ) := RTEMS.BUILD_NAME(  'T', 'A', '1', ' ' );

      RTEMS.TASK_CREATE( 
         TMTEST.TASK_NAME( 1 ), 
         1, 
         2048, 
         RTEMS.DEFAULT_MODES,
         RTEMS.DEFAULT_ATTRIBUTES,
         TMTEST.TASK_ID( 1 ),
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_CREATE OF TA1" );

      RTEMS.TASK_START(
         TMTEST.TASK_ID( 1 ),
         TMTEST.TASK_1'ACCESS,
         0,
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_START OF TA1" );

      RTEMS.TASK_DELETE( RTEMS.SELF, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_DELETE OF SELF" );

   end INIT;

--PAGE
-- 
--  TASK_1
--

   procedure TASK_1 (
      ARGUMENT : in     RTEMS.TASK_ARGUMENT
   ) is
      INDEX                    : RTEMS.UNSIGNED32;
   begin

      TMTEST.CHECK_READ_TIMER;

TEST_SUPPORT.PAUSE;

      TIMER_DRIVER.INITIALIZE;
      TMTEST.END_TIME := TIMER_DRIVER.READ_TIMER;
      TIME_TEST_SUPPORT.PUT_TIME( 
         "NULL timer stopped at", 
         TMTEST.END_TIME, 
         1, 
         0,
         0
      );

      TIMER_DRIVER.INITIALIZE;
         for INDEX in 0 .. 1000
         loop
            TIMER_DRIVER.EMPTY_FUNCTION;
         end loop;
      TMTEST.END_TIME := TIMER_DRIVER.READ_TIMER;
      TIME_TEST_SUPPORT.PUT_TIME( 
         "LOOP (1000) timer stopped at", 
         TMTEST.END_TIME, 
         1, 
         0,
         0
      );

      TIMER_DRIVER.INITIALIZE;
         for INDEX in 0 .. 10000
         loop
            TIMER_DRIVER.EMPTY_FUNCTION;
         end loop;
      TMTEST.END_TIME := TIMER_DRIVER.READ_TIMER;
      TIME_TEST_SUPPORT.PUT_TIME( 
         "LOOP (10000) timer stopped at", 
         TMTEST.END_TIME, 
         1, 
         0,
         0
      );

      TIMER_DRIVER.INITIALIZE;
         for INDEX in 0 .. 50000
         loop
            TIMER_DRIVER.EMPTY_FUNCTION;
         end loop;
      TMTEST.END_TIME := TIMER_DRIVER.READ_TIMER;
      TIME_TEST_SUPPORT.PUT_TIME( 
         "LOOP (50000) timer stopped at", 
         TMTEST.END_TIME, 
         1, 
         0,
         0
      );

      TIMER_DRIVER.INITIALIZE;
         for INDEX in 0 .. 100000
         loop
            TIMER_DRIVER.EMPTY_FUNCTION;
         end loop;
      TMTEST.END_TIME := TIMER_DRIVER.READ_TIMER;
      TIME_TEST_SUPPORT.PUT_TIME( 
         "LOOP (100000) timer stopped at", 
         TMTEST.END_TIME, 
         1, 
         0,
         0
      );

      RTEMS.SHUTDOWN_EXECUTIVE( 0 );
   
   end TASK_1;

--PAGE
-- 
--  CHECK_READ_TIMER
--

   procedure CHECK_READ_TIMER 
   is
      INDEX : RTEMS.UNSIGNED32;
      TIME  : RTEMS.UNSIGNED32;
   begin

      for INDEX in TMTEST.DISTRIBUTION'FIRST .. TMTEST.DISTRIBUTION'LAST
      loop
          TMTEST.DISTRIBUTION( INDEX ) := 0;
      end loop;

      for INDEX in 1 .. TMTEST.OPERATION_COUNT
      loop

         loop
            TIMER_DRIVER.INITIALIZE;
            TMTEST.END_TIME := TIMER_DRIVER.READ_TIMER;
      
            exit when 
               TMTEST.END_TIME <= RTEMS.UNSIGNED32( TMTEST.DISTRIBUTION'LAST );

            TEXT_IO.PUT( "TOO LONG (" );
            UNSIGNED32_IO.PUT( TMTEST.END_TIME );
            TEXT_IO.PUT_LINE( ")!!!" );
         end loop;

         TMTEST.DISTRIBUTION( TMTEST.END_TIME ) :=
             TMTEST.DISTRIBUTION( TMTEST.END_TIME ) + 1;

      end loop;

      TEXT_IO.PUT_LINE( 
         "Units may not be in microseconds for this test!!!"
      );

      TIME := 0;

      for INDEX in TMTEST.DISTRIBUTION'FIRST .. TMTEST.DISTRIBUTION'LAST
      loop
         if TMTEST.DISTRIBUTION( INDEX ) /= 0 then
            TIME := TIME + (TMTEST.DISTRIBUTION( INDEX ) * INDEX);
            UNSIGNED32_IO.PUT( INDEX );
            TEXT_IO.PUT( " " );
            UNSIGNED32_IO.PUT( TMTEST.DISTRIBUTION( INDEX ) );
            TEXT_IO.NEW_LINE;
         end if;
      end loop;

      TEXT_IO.PUT( "Total time = " );
      UNSIGNED32_IO.PUT( TIME );
      TEXT_IO.NEW_LINE;

   end CHECK_READ_TIMER;

end TMTEST;
