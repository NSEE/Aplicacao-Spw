/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_2592010699;
char *STD_STANDARD;
char *IEEE_P_1242562249;
char *WORK_P_1442564703;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    work_p_1442564703_init();
    ieee_p_1242562249_init();
    work_a_1218525393_3212880686_init();
    work_a_4259603014_0322270938_init();
    work_a_3924940162_4261907187_init();
    work_a_2781746508_1366615453_init();
    work_a_2929789303_2536270299_init();
    work_a_2293420734_0849473606_init();
    work_a_1834528007_2469494244_init();
    work_a_2030980471_3212880686_init();
    work_a_3636356752_1516540902_init();
    work_a_0760923540_2372691052_init();


    xsi_register_tops("work_a_0760923540_2372691052");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    WORK_P_1442564703 = xsi_get_engine_memory("work_p_1442564703");

    return xsi_run_simulation(argc, argv);

}
