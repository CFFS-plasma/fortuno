module testsuite_parametrized2
  use mylib, only : factorial
  use fortuno, only : context => serial_context, suite => serial_suite, serial_test_base
  implicit none


  type :: calc
    integer :: arg, res
  end type

  type(calc), parameter :: factcalcs(*) = [&
      & calc(0, 1), calc(1, 1), calc(2, 2), calc(3, 6), calc(4, 24)&
      & ]


  type, extends(serial_test_base) :: factcalc_test
    type(calc) :: factcalc
  contains
    procedure :: run
    procedure :: test_fact_calc
  end type factcalc_test

contains


  function test_suite() result(testsuite)
    type(suite) :: testsuite

    integer :: icalc
    character(200) :: name

    testsuite = suite("param2")
    do icalc = 1, size(factcalcs)
      write(name, "(a, i0, a)") "factorial(", factcalcs(icalc)%arg, ")"
      call testsuite%add_test(factcalc_test(trim(name), factcalc=factcalcs(icalc)))
    end do

  end function test_suite


  subroutine test_fact_calc(this, ctx)
    class(factcalc_test), intent(in) :: this
    class(context), intent(inout) :: ctx

    call ctx%check(factorial(this%factcalc%arg) == this%factcalc%res)

  end subroutine test_fact_calc


  subroutine run(this, ctx)
    class(factcalc_test), intent(inout) :: this
    class(context), intent(inout) :: ctx

    call this%test_fact_calc(ctx)

  end subroutine run

end module testsuite_parametrized2


program testdriver_parametrized2
  use fortuno, only : serial_driver
  use testsuite_parametrized2, only : test_suite
  implicit none

  type(serial_driver), allocatable :: driver

  driver = serial_driver([test_suite()])
  call driver%run()

end program testdriver_parametrized2
