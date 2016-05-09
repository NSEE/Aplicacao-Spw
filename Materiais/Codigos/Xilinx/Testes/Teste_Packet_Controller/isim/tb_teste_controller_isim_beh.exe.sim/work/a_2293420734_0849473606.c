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

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "E:/Users/Dennis/Documentos/SpW/Aplicacao-Spw/Materiais/Codigos/Xilinx/Testes/Teste_Packet_Controller/source/SpW/spwram.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_1657552908_1035706684(char *, char *, char *);
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_2293420734_0849473606_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    int t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    xsi_set_current_line(40, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4280);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(41, ng0);
    t3 = (t0 + 1352U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(42, ng0);
    t3 = (t0 + 2312U);
    t7 = *((char **)t3);
    t3 = (t0 + 1512U);
    t8 = *((char **)t3);
    t3 = (t0 + 8012U);
    t9 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t8, t3);
    t10 = (t9 - 0);
    t11 = (t10 * 1);
    xsi_vhdl_check_range_of_index(0, 2047, 1, t9);
    t12 = (9U * t11);
    t13 = (0 + t12);
    t14 = (t7 + t13);
    t15 = (t0 + 4376);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    memcpy(t19, t14, 9U);
    xsi_driver_first_trans_fast_port(t15);
    goto LAB6;

}

static void work_a_2293420734_0849473606_p_1(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    int t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(50, ng0);
    t1 = (t0 + 1152U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4296);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(51, ng0);
    t3 = (t0 + 1832U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(52, ng0);
    t3 = (t0 + 2152U);
    t7 = *((char **)t3);
    t3 = (t0 + 1992U);
    t8 = *((char **)t3);
    t3 = (t0 + 8044U);
    t9 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t8, t3);
    t10 = (t9 - 0);
    t11 = (t10 * 1);
    t12 = (9U * t11);
    t13 = (0U + t12);
    t14 = (t0 + 4440);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t7, 9U);
    xsi_driver_first_trans_delta(t14, t13, 9U, 0LL);
    goto LAB6;

}


extern void work_a_2293420734_0849473606_init()
{
	static char *pe[] = {(void *)work_a_2293420734_0849473606_p_0,(void *)work_a_2293420734_0849473606_p_1};
	xsi_register_didat("work_a_2293420734_0849473606", "isim/tb_teste_controller_isim_beh.exe.sim/work/a_2293420734_0849473606.didat");
	xsi_register_executes(pe);
}
