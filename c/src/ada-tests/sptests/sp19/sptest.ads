--
--  SPTEST / SPECIFICATION
--
--  DESCRIPTION:
--
--  This package is the specification for Test 19 of the RTEMS
--  Single Processor Test Suite.
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

with CLOCK_DRIVER;
with RTEMS;

package SPTEST is

--
--  These arrays contain the IDs and NAMEs of all RTEMS tasks created
--  by this test.
--

   TASK_ID   : array ( RTEMS.UNSIGNED32 range 1 .. 6 ) of RTEMS.ID;
   TASK_NAME : array ( RTEMS.UNSIGNED32 range 1 .. 6 ) of RTEMS.NAME;

--
--  This array contains the floating point factors used by the
--  floating point tasks in this test.
--

   FP_FACTORS : array ( RTEMS.UNSIGNED32 range 0 .. 9 ) of FLOAT;

--
--  This array contains the integer factors used by the
--  integer tasks in this test.
--

   INTEGER_FACTORS : array ( RTEMS.UNSIGNED32 range 0 .. 9 ) of 
      RTEMS.UNSIGNED32;

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
--  FIRST_FP_TASK
--
--  DESCRIPTION:
--
--  This RTEMS task tests the restart and deletion of floating point tasks.
--

   procedure FIRST_FP_TASK (
      ARGUMENT : in     RTEMS.TASK_ARGUMENT
   );

--
--  FP_TASK
--
--  DESCRIPTION:
--
--  This RTEMS task tests the basic capabilities of a floating point
--  task.
--

   procedure FP_TASK (
      ARGUMENT : in     RTEMS.TASK_ARGUMENT
   );

--
--  TASK_1
--
--  DESCRIPTION:
--
--  This RTEMS task provides a non-floating point task to test
--  that an application can utilize a mixture of floating point
--  and non-floating point tasks.
--

   procedure TASK_1 (
      ARGUMENT : in     RTEMS.TASK_ARGUMENT
   );

--
--  This is the Driver Address Table for this test.
--

   DEVICE_DRIVERS : aliased RTEMS.DRIVER_ADDRESS_TABLE( 1 .. 1 ) :=
   (1=>
      (
        CLOCK_DRIVER.INITIALIZE'ACCESS,              -- Initialization
        RTEMS.NO_DRIVER_ENTRY,                       -- Open
        RTEMS.NO_DRIVER_ENTRY,                       -- Close
        RTEMS.NO_DRIVER_ENTRY,                       -- Read
        RTEMS.NO_DRIVER_ENTRY,                       -- Write
        RTEMS.NO_DRIVER_ENTRY                        -- Control
      )
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
       SPTEST.INIT'ACCESS,                            -- entry point
       RTEMS.NO_PREEMPT,                              -- initial mode
       0                                              -- argument list
     )
   );

--
--  This is the Configuration Table for this test.
--

   CONFIGURATION : aliased RTEMS.CONFIGURATION_TABLE := (
      RTEMS.NULL_ADDRESS,        -- will be replaced by BSP
      64 * 1024,                 -- executive RAM size
      10,                        -- maximum # tasks
      0,                         -- maximum # timers
      0,                         -- maximum # semaphores
      0,                         -- maximum # message queues
      0,                         -- maximum # messages
      0,                         -- maximum # partitions
      0,                         -- maximum # regions
      0,                         -- maximum # dp memory areas
      0,                         -- maximum # periods
      0,                         -- maximum # user extensions
      RTEMS.MILLISECONDS_TO_MICROSECONDS(10), -- # us in a tick
      50                         -- # ticks in a timeslice
  );

end SPTEST;
