--
--  TMTEST / SPECIFICATION
--
--  DESCRIPTION:
--
--  This package is the specification for Test 2 of the RTEMS
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
with RTEMS;

package TMTEST is

--
--  The following is the ID of the semaphore used for timing operations.
--

   SEMAPHORE_ID : RTEMS.ID;

--
--  The following variable is set to the execution time returned
--  by the timer.
--

   END_TIME  : RTEMS.UNSIGNED32;

--
--  INIT
--
--  DESCRIPTION:
--
--  This RTEMS task initializes the application.
--

   procedure INIT (
      ARGUMENT : in     RTEMS.TASK_ARGUMENT
   );

--
--  TEST_INIT
--
--  DESCRIPTION:
--
--  This subprogram performs test initialization.
--

   procedure TEST_INIT;

--
--  HIGH_TASK
--
--  DESCRIPTION:
--
--  This RTEMS task starts the timer and performs a blocking 
--  SEMAPHORE_OBTAIN.
--

   procedure HIGH_TASK (
      ARGUMENT : in     RTEMS.TASK_ARGUMENT
   );

--
--  MIDDLE_TASKS
--
--  DESCRIPTION:
--
--  These RTEMS task start the timer and performs a blocking 
--  SEMAPHORE_OBTAIN.
--

   procedure MIDDLE_TASKS (
      ARGUMENT : in     RTEMS.TASK_ARGUMENT
   );

--
--  LOW_TASK
--
--  DESCRIPTION:
--
--  This RTEMS task stops the timer and reports the execution time for
--  a blocking SEMAPHORE_OBTAIN.
--

   procedure LOW_TASK (
      ARGUMENT : in     RTEMS.TASK_ARGUMENT
   );

--
--  This is the Initialization Tasks Table for this test.
--

   INITIALIZATION_TASKS : aliased RTEMS.INITIALIZATION_TASKS_TABLE( 1 .. 1 ) := 
   (1=>
     (
       RTEMS.BUILD_NAME( 'U', 'I', '1', ' ' ),        -- task name
       2048,                                          -- stack size
       1,                                             -- priority
       RTEMS.DEFAULT_ATTRIBUTES,                      -- attributes
       TMTEST.INIT'ACCESS,                            -- entry point
       RTEMS.NO_PREEMPT,                              -- initial mode
       0                                              -- argument list
     )
   );

--
--  This is the Configuration Table for this test.
--

   CONFIGURATION : aliased RTEMS.CONFIGURATION_TABLE := (
      RTEMS.NULL_ADDRESS,        -- will be replaced by BSP
      256 * 1024,                -- executive RAM size
      111,                       -- maximum # tasks
      110,                       -- maximum # timers
      101,                       -- maximum # semaphores
      0,                         -- maximum # message queues
      0,                         -- maximum # messages
      0,                         -- maximum # partitions
      0,                         -- maximum # regions
      0,                         -- maximum # dp memory areas
      0,                         -- maximum # periods
      0,                         -- maximum # user extensions
      RTEMS.MILLISECONDS_TO_MICROSECONDS(10), -- # us in a tick
      0                          -- # ticks in a timeslice
  );

end TMTEST;
