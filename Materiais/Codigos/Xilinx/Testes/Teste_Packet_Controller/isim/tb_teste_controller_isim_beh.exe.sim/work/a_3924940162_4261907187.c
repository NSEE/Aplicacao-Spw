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
static const char *ng0 = "E:/Users/Dennis/Documentos/SpW/Aplicacao-Spw/Materiais/Codigos/Xilinx/Testes/Teste_Packet_Controller/source/SpW/spwrecv.vhd";
extern char *IEEE_P_1242562249;
extern char *IEEE_P_2592010699;

unsigned char ieee_p_1242562249_sub_1781507893_1035706684(char *, char *, char *, int );
char *ieee_p_1242562249_sub_180853171_1035706684(char *, char *, int , int );
char *ieee_p_1242562249_sub_1919437128_1035706684(char *, char *, char *, char *, int );
unsigned char ieee_p_1242562249_sub_3125432260_1035706684(char *, char *, char *, int );
unsigned char ieee_p_2592010699_sub_1690584930_503743352(char *, unsigned char );
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );
unsigned char ieee_p_2592010699_sub_2507238156_503743352(char *, unsigned char , unsigned char );


static void work_a_3924940162_4261907187_p_0(char *t0)
{
    char t6[16];
    char t36[16];
    char *t1;
    char *t2;
    char *t3;
    unsigned char t4;
    unsigned char t5;
    char *t7;
    unsigned int t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    unsigned int t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    int t25;
    int t26;
    int t27;
    int t28;
    int t29;
    unsigned char t30;
    unsigned char t31;
    unsigned char t32;
    unsigned char t33;
    unsigned int t34;
    unsigned int t35;

LAB0:    xsi_set_current_line(108, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t1 = (t0 + 2808U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    memcpy(t1, t2, 56U);
    xsi_set_current_line(109, ng0);
    t1 = (t0 + 2928U);
    t2 = *((char **)t1);
    t1 = (t2 + 0);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(112, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t5 = (t4 == (unsigned char)3);
    if (t5 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 44U);
    t1 = (t2 + t8);
    t3 = (t0 + 5648);
    t7 = xsi_record_get_element_type(t3, 13);
    t9 = (t7 + 80U);
    t10 = *((char **)t9);
    t4 = ieee_p_1242562249_sub_3125432260_1035706684(IEEE_P_1242562249, t1, t10, 0);
    if (t4 != 0)
        goto LAB5;

LAB6:
LAB3:    xsi_set_current_line(121, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 24U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(122, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 25U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(123, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 26U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(125, ng0);
    t1 = (t0 + 1672U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t5 = (t4 == (unsigned char)3);
    if (t5 != 0)
        goto LAB7;

LAB9:
LAB8:    xsi_set_current_line(219, ng0);
    t1 = (t0 + 1192U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t5 = (t4 == (unsigned char)2);
    if (t5 != 0)
        goto LAB67;

LAB69:
LAB68:    xsi_set_current_line(237, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 0U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = t4;
    xsi_driver_first_trans_delta(t3, 0U, 1, 0LL);
    xsi_set_current_line(238, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 1U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = t4;
    xsi_driver_first_trans_delta(t3, 1U, 1, 0LL);
    xsi_set_current_line(239, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 24U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = t4;
    xsi_driver_first_trans_delta(t3, 2U, 1, 0LL);
    xsi_set_current_line(240, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 25U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = t4;
    xsi_driver_first_trans_delta(t3, 3U, 1, 0LL);
    xsi_set_current_line(241, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (7 - 7);
    t13 = (t8 * 1U);
    t21 = (0 + 28U);
    t23 = (t21 + t13);
    t1 = (t2 + t23);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t1, 2U);
    xsi_driver_first_trans_delta(t3, 4U, 2U, 0LL);
    xsi_set_current_line(242, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (7 - 5);
    t13 = (t8 * 1U);
    t21 = (0 + 28U);
    t23 = (t21 + t13);
    t1 = (t2 + t23);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t1, 6U);
    xsi_driver_first_trans_delta(t3, 6U, 6U, 0LL);
    xsi_set_current_line(243, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 26U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = t4;
    xsi_driver_first_trans_delta(t3, 12U, 1, 0LL);
    xsi_set_current_line(244, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 27U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = t4;
    xsi_driver_first_trans_delta(t3, 13U, 1, 0LL);
    xsi_set_current_line(245, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 36U);
    t1 = (t2 + t8);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t1, 8U);
    xsi_driver_first_trans_delta(t3, 14U, 8U, 0LL);
    xsi_set_current_line(246, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 0U);
    t1 = (t2 + t8);
    t5 = *((unsigned char *)t1);
    t30 = (t5 == (unsigned char)3);
    if (t30 == 1)
        goto LAB73;

LAB74:    t4 = (unsigned char)0;

LAB75:    if (t4 != 0)
        goto LAB70;

LAB72:    xsi_set_current_line(249, ng0);
    t1 = (t0 + 4576);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    *((unsigned char *)t9) = (unsigned char)2;
    xsi_driver_first_trans_delta(t1, 22U, 1, 0LL);

LAB71:    xsi_set_current_line(251, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 52U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = t4;
    xsi_driver_first_trans_delta(t3, 23U, 1, 0LL);
    xsi_set_current_line(252, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 53U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t3 = (t0 + 4576);
    t7 = (t3 + 56U);
    t9 = *((char **)t7);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = t4;
    xsi_driver_first_trans_delta(t3, 24U, 1, 0LL);
    xsi_set_current_line(255, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t1 = (t0 + 4640);
    t3 = (t1 + 56U);
    t7 = *((char **)t3);
    t9 = (t7 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 56U);
    xsi_driver_first_trans_fast(t1);
    t1 = (t0 + 4480);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(114, ng0);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t6, 85, 8);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t8 = (0 + 44U);
    t3 = (t7 + t8);
    memcpy(t3, t1, 8U);
    goto LAB3;

LAB5:    xsi_set_current_line(117, ng0);
    t11 = (t0 + 1992U);
    t12 = *((char **)t11);
    t13 = (0 + 44U);
    t11 = (t12 + t13);
    t14 = (t0 + 5648);
    t15 = xsi_record_get_element_type(t14, 13);
    t16 = (t15 + 80U);
    t17 = *((char **)t16);
    t18 = ieee_p_1242562249_sub_1919437128_1035706684(IEEE_P_1242562249, t6, t11, t17, 1);
    t19 = (t0 + 2808U);
    t20 = *((char **)t19);
    t21 = (0 + 44U);
    t19 = (t20 + t21);
    t22 = (t6 + 12U);
    t23 = *((unsigned int *)t22);
    t24 = (1U * t23);
    memcpy(t19, t18, t24);
    goto LAB3;

LAB7:    xsi_set_current_line(128, ng0);
    t25 = (1 - 1);
    t1 = (t0 + 9917);
    *((int *)t1) = 0;
    t3 = (t0 + 9921);
    *((int *)t3) = t25;
    t26 = 0;
    t27 = t25;

LAB10:    if (t26 <= t27)
        goto LAB11;

LAB13:    goto LAB8;

LAB11:    xsi_set_current_line(129, ng0);
    t7 = (t0 + 1832U);
    t9 = *((char **)t7);
    t7 = (t0 + 9917);
    t28 = *((int *)t7);
    t29 = (t28 - 0);
    t8 = (t29 * -1);
    xsi_vhdl_check_range_of_index(0, 0, -1, *((int *)t7));
    t13 = (1U * t8);
    t21 = (0 + t13);
    t10 = (t9 + t21);
    t30 = *((unsigned char *)t10);
    t11 = (t0 + 2928U);
    t12 = *((char **)t11);
    t11 = (t12 + 0);
    *((unsigned char *)t11) = t30;
    xsi_set_current_line(132, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 0U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)3;
    xsi_set_current_line(134, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t25 = (0 - 9);
    t8 = (t25 * -1);
    t13 = (1U * t8);
    t21 = (0 + 11U);
    t23 = (t21 + t13);
    t1 = (t2 + t23);
    t4 = *((unsigned char *)t1);
    t5 = (t4 == (unsigned char)3);
    if (t5 != 0)
        goto LAB14;

LAB16:    xsi_set_current_line(197, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (9 - 9);
    t13 = (t8 * 1U);
    t21 = (0 + 11U);
    t23 = (t21 + t13);
    t1 = (t2 + t23);
    t7 = ((IEEE_P_2592010699) + 4024);
    t9 = (t36 + 0U);
    t10 = (t9 + 0U);
    *((int *)t10) = 9;
    t10 = (t9 + 4U);
    *((int *)t10) = 1;
    t10 = (t9 + 8U);
    *((int *)t10) = -1;
    t25 = (1 - 9);
    t24 = (t25 * -1);
    t24 = (t24 + 1);
    t10 = (t9 + 12U);
    *((unsigned int *)t10) = t24;
    t3 = xsi_base_array_concat(t3, t6, t7, (char)99, (unsigned char)2, (char)97, t1, t36, (char)101);
    t10 = (t0 + 2808U);
    t11 = *((char **)t10);
    t24 = (0 + 11U);
    t10 = (t11 + t24);
    t34 = (1U + 9U);
    memcpy(t10, t3, t34);
    xsi_set_current_line(198, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 21U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t3 = (t0 + 2928U);
    t7 = *((char **)t3);
    t5 = *((unsigned char *)t7);
    t30 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t4, t5);
    t3 = (t0 + 2808U);
    t9 = *((char **)t3);
    t13 = (0 + 21U);
    t3 = (t9 + t13);
    *((unsigned char *)t3) = t30;

LAB15:    xsi_set_current_line(202, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 1U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t5 = (t4 == (unsigned char)2);
    if (t5 != 0)
        goto LAB47;

LAB49:
LAB48:    xsi_set_current_line(213, ng0);
    t1 = (t0 + 2928U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t1 = (t0 + 2808U);
    t3 = *((char **)t1);
    if (8 > 0)
        goto LAB59;

LAB60:    if (-1 == -1)
        goto LAB64;

LAB65:    t25 = 0;

LAB61:    t8 = (8 - t25);
    t13 = (t8 * 1U);
    t21 = (0 + 2U);
    t23 = (t21 + t13);
    t1 = (t3 + t23);
    t9 = ((IEEE_P_2592010699) + 4024);
    t10 = (t36 + 0U);
    t11 = (t10 + 0U);
    *((int *)t11) = 8;
    t11 = (t10 + 4U);
    *((int *)t11) = 1;
    t11 = (t10 + 8U);
    *((int *)t11) = -1;
    t28 = (1 - 8);
    t24 = (t28 * -1);
    t24 = (t24 + 1);
    t11 = (t10 + 12U);
    *((unsigned int *)t11) = t24;
    t7 = xsi_base_array_concat(t7, t6, t9, (char)99, t4, (char)97, t1, t36, (char)101);
    t11 = (t0 + 2808U);
    t12 = *((char **)t11);
    t24 = (0 + 2U);
    t11 = (t12 + t24);
    t34 = (1U + 8U);
    memcpy(t11, t7, t34);

LAB12:    t1 = (t0 + 9917);
    t26 = *((int *)t1);
    t2 = (t0 + 9921);
    t27 = *((int *)t2);
    if (t26 == t27)
        goto LAB13;

LAB66:    t25 = (t26 + 1);
    t26 = t25;
    t3 = (t0 + 9917);
    *((int *)t3) = t26;
    goto LAB10;

LAB14:    xsi_set_current_line(137, ng0);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t24 = (0 + 21U);
    t3 = (t7 + t24);
    t30 = *((unsigned char *)t3);
    t9 = (t0 + 2928U);
    t10 = *((char **)t9);
    t31 = *((unsigned char *)t10);
    t32 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t30, t31);
    t33 = (t32 == (unsigned char)2);
    if (t33 != 0)
        goto LAB17;

LAB19:    xsi_set_current_line(141, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 22U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t5 = (t4 == (unsigned char)3);
    if (t5 != 0)
        goto LAB20;

LAB22:    xsi_set_current_line(171, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t5 = (t4 == (unsigned char)3);
    if (t5 != 0)
        goto LAB41;

LAB43:    xsi_set_current_line(177, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 27U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(178, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 26U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)3;
    xsi_set_current_line(179, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (8 - 7);
    t13 = (t8 * 1U);
    t21 = (0 + 2U);
    t23 = (t21 + t13);
    t1 = (t2 + t23);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t24 = (0 + 36U);
    t3 = (t7 + t24);
    memcpy(t3, t1, 8U);

LAB42:    xsi_set_current_line(181, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;

LAB21:
LAB18:    xsi_set_current_line(185, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 21U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(186, ng0);
    t1 = (t0 + 2928U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t1 = (t0 + 2808U);
    t3 = *((char **)t1);
    t8 = (0 + 22U);
    t1 = (t3 + t8);
    *((unsigned char *)t1) = t4;
    xsi_set_current_line(187, ng0);
    t1 = (t0 + 2928U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t5 = (t4 == (unsigned char)3);
    if (t5 != 0)
        goto LAB44;

LAB46:    xsi_set_current_line(192, ng0);
    t1 = xsi_get_transient_memory(10U);
    memset(t1, 0, 10U);
    t2 = t1;
    memset(t2, (unsigned char)2, 10U);
    t25 = (9 - 9);
    t8 = (t25 * -1);
    t13 = (1U * t8);
    t3 = (t2 + t13);
    *((unsigned char *)t3) = (unsigned char)3;
    t7 = (t0 + 2808U);
    t9 = *((char **)t7);
    t21 = (0 + 11U);
    t7 = (t9 + t21);
    memcpy(t7, t1, 10U);

LAB45:    goto LAB15;

LAB17:    xsi_set_current_line(139, ng0);
    t9 = (t0 + 2808U);
    t11 = *((char **)t9);
    t34 = (0 + 52U);
    t9 = (t11 + t34);
    *((unsigned char *)t9) = (unsigned char)3;
    goto LAB18;

LAB20:    xsi_set_current_line(143, ng0);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t13 = (8 - 7);
    t21 = (t13 * 1U);
    t23 = (0 + 2U);
    t24 = (t23 + t21);
    t3 = (t7 + t24);
    t9 = (t0 + 9925);
    t25 = xsi_mem_cmp(t9, t3, 2U);
    if (t25 == 1)
        goto LAB24;

LAB28:    t11 = (t0 + 9927);
    t28 = xsi_mem_cmp(t11, t3, 2U);
    if (t28 == 1)
        goto LAB25;

LAB29:    t14 = (t0 + 9929);
    t29 = xsi_mem_cmp(t14, t3, 2U);
    if (t29 == 1)
        goto LAB26;

LAB30:
LAB27:    xsi_set_current_line(164, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t5 = (t4 == (unsigned char)3);
    if (t5 != 0)
        goto LAB38;

LAB40:
LAB39:    xsi_set_current_line(167, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)3;

LAB23:    goto LAB21;

LAB24:    xsi_set_current_line(145, ng0);
    t16 = (t0 + 1992U);
    t17 = *((char **)t16);
    t34 = (0 + 23U);
    t16 = (t17 + t34);
    t30 = *((unsigned char *)t16);
    t31 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t30);
    t18 = (t0 + 2808U);
    t19 = *((char **)t18);
    t35 = (0 + 24U);
    t18 = (t19 + t35);
    *((unsigned char *)t18) = t31;
    xsi_set_current_line(146, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    goto LAB23;

LAB25:    xsi_set_current_line(148, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t5 = (t4 == (unsigned char)3);
    if (t5 != 0)
        goto LAB32;

LAB34:
LAB33:    xsi_set_current_line(151, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(152, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t5 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t4);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t13 = (0 + 26U);
    t3 = (t7 + t13);
    *((unsigned char *)t3) = t5;
    xsi_set_current_line(153, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 27U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)3;
    xsi_set_current_line(154, ng0);
    t1 = (t0 + 9931);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t8 = (0 + 36U);
    t3 = (t7 + t8);
    memcpy(t3, t1, 8U);
    goto LAB23;

LAB26:    xsi_set_current_line(156, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t5 = (t4 == (unsigned char)3);
    if (t5 != 0)
        goto LAB35;

LAB37:
LAB36:    xsi_set_current_line(159, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(160, ng0);
    t1 = (t0 + 1992U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    t4 = *((unsigned char *)t1);
    t5 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t4);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t13 = (0 + 26U);
    t3 = (t7 + t13);
    *((unsigned char *)t3) = t5;
    xsi_set_current_line(161, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 27U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)3;
    xsi_set_current_line(162, ng0);
    t1 = (t0 + 9939);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t8 = (0 + 36U);
    t3 = (t7 + t8);
    memcpy(t3, t1, 8U);
    goto LAB23;

LAB31:;
LAB32:    xsi_set_current_line(149, ng0);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t13 = (0 + 53U);
    t3 = (t7 + t13);
    *((unsigned char *)t3) = (unsigned char)3;
    goto LAB33;

LAB35:    xsi_set_current_line(157, ng0);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t13 = (0 + 53U);
    t3 = (t7 + t13);
    *((unsigned char *)t3) = (unsigned char)3;
    goto LAB36;

LAB38:    xsi_set_current_line(165, ng0);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t13 = (0 + 53U);
    t3 = (t7 + t13);
    *((unsigned char *)t3) = (unsigned char)3;
    goto LAB39;

LAB41:    xsi_set_current_line(173, ng0);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t13 = (0 + 25U);
    t3 = (t7 + t13);
    *((unsigned char *)t3) = (unsigned char)3;
    xsi_set_current_line(174, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (8 - 7);
    t13 = (t8 * 1U);
    t21 = (0 + 2U);
    t23 = (t21 + t13);
    t1 = (t2 + t23);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t24 = (0 + 28U);
    t3 = (t7 + t24);
    memcpy(t3, t1, 8U);
    goto LAB42;

LAB44:    xsi_set_current_line(189, ng0);
    t1 = xsi_get_transient_memory(10U);
    memset(t1, 0, 10U);
    t3 = t1;
    memset(t3, (unsigned char)2, 10U);
    t25 = (3 - 9);
    t8 = (t25 * -1);
    t13 = (1U * t8);
    t7 = (t3 + t13);
    *((unsigned char *)t7) = (unsigned char)3;
    t9 = (t0 + 2808U);
    t10 = *((char **)t9);
    t21 = (0 + 11U);
    t9 = (t10 + t21);
    memcpy(t9, t1, 10U);
    goto LAB45;

LAB47:    xsi_set_current_line(203, ng0);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t13 = (0 + 2U);
    t3 = (t7 + t13);
    t9 = (t0 + 9947);
    t30 = 1;
    if (9U == 9U)
        goto LAB53;

LAB54:    t30 = 0;

LAB55:    if (t30 != 0)
        goto LAB50;

LAB52:
LAB51:    goto LAB48;

LAB50:    xsi_set_current_line(205, ng0);
    t14 = (t0 + 2808U);
    t15 = *((char **)t14);
    t23 = (0 + 1U);
    t14 = (t15 + t23);
    *((unsigned char *)t14) = (unsigned char)3;
    xsi_set_current_line(206, ng0);
    t1 = (t0 + 2928U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t1 = (t0 + 2808U);
    t3 = *((char **)t1);
    t8 = (0 + 22U);
    t1 = (t3 + t8);
    *((unsigned char *)t1) = t4;
    xsi_set_current_line(207, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 21U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(208, ng0);
    t1 = xsi_get_transient_memory(10U);
    memset(t1, 0, 10U);
    t2 = t1;
    memset(t2, (unsigned char)2, 10U);
    t25 = (3 - 9);
    t8 = (t25 * -1);
    t13 = (1U * t8);
    t3 = (t2 + t13);
    *((unsigned char *)t3) = (unsigned char)3;
    t7 = (t0 + 2808U);
    t9 = *((char **)t7);
    t21 = (0 + 11U);
    t7 = (t9 + t21);
    memcpy(t7, t1, 10U);
    goto LAB51;

LAB53:    t21 = 0;

LAB56:    if (t21 < 9U)
        goto LAB57;
    else
        goto LAB55;

LAB57:    t11 = (t3 + t21);
    t12 = (t9 + t21);
    if (*((unsigned char *)t11) != *((unsigned char *)t12))
        goto LAB54;

LAB58:    t21 = (t21 + 1);
    goto LAB56;

LAB59:    if (-1 == 1)
        goto LAB62;

LAB63:    t25 = 8;
    goto LAB61;

LAB62:    t25 = 0;
    goto LAB61;

LAB64:    t25 = 8;
    goto LAB61;

LAB67:    xsi_set_current_line(220, ng0);
    t1 = (t0 + 2808U);
    t3 = *((char **)t1);
    t8 = (0 + 0U);
    t1 = (t3 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(221, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 1U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(222, ng0);
    t1 = (t0 + 9956);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t8 = (0 + 2U);
    t3 = (t7 + t8);
    memcpy(t3, t1, 9U);
    xsi_set_current_line(223, ng0);
    t1 = xsi_get_transient_memory(10U);
    memset(t1, 0, 10U);
    t2 = t1;
    memset(t2, (unsigned char)2, 10U);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t8 = (0 + 11U);
    t3 = (t7 + t8);
    memcpy(t3, t1, 10U);
    xsi_set_current_line(224, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 24U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(225, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 25U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(226, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 26U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(227, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 27U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(228, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 23U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(229, ng0);
    t1 = (t0 + 9965);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t8 = (0 + 28U);
    t3 = (t7 + t8);
    memcpy(t3, t1, 8U);
    xsi_set_current_line(230, ng0);
    t1 = (t0 + 9973);
    t3 = (t0 + 2808U);
    t7 = *((char **)t3);
    t8 = (0 + 36U);
    t3 = (t7 + t8);
    memcpy(t3, t1, 8U);
    xsi_set_current_line(231, ng0);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t6, 0, 8);
    t2 = (t0 + 2808U);
    t3 = *((char **)t2);
    t8 = (0 + 44U);
    t2 = (t3 + t8);
    memcpy(t2, t1, 8U);
    xsi_set_current_line(232, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 52U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(233, ng0);
    t1 = (t0 + 2808U);
    t2 = *((char **)t1);
    t8 = (0 + 53U);
    t1 = (t2 + t8);
    *((unsigned char *)t1) = (unsigned char)2;
    goto LAB68;

LAB70:    xsi_set_current_line(247, ng0);
    t14 = (t0 + 4576);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    *((unsigned char *)t18) = (unsigned char)3;
    xsi_driver_first_trans_delta(t14, 22U, 1, 0LL);
    goto LAB71;

LAB73:    t3 = (t0 + 1992U);
    t7 = *((char **)t3);
    t13 = (0 + 44U);
    t3 = (t7 + t13);
    t9 = (t0 + 5648);
    t10 = xsi_record_get_element_type(t9, 13);
    t11 = (t10 + 80U);
    t12 = *((char **)t11);
    t31 = ieee_p_1242562249_sub_1781507893_1035706684(IEEE_P_1242562249, t3, t12, 0);
    t4 = t31;
    goto LAB75;

}

static void work_a_3924940162_4261907187_p_1(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(262, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4496);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(263, ng0);
    t3 = (t0 + 2152U);
    t4 = *((char **)t3);
    t3 = (t0 + 4704);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t4, 56U);
    xsi_driver_first_trans_fast(t3);
    goto LAB3;

}


extern void work_a_3924940162_4261907187_init()
{
	static char *pe[] = {(void *)work_a_3924940162_4261907187_p_0,(void *)work_a_3924940162_4261907187_p_1};
	xsi_register_didat("work_a_3924940162_4261907187", "isim/tb_teste_controller_isim_beh.exe.sim/work/a_3924940162_4261907187.didat");
	xsi_register_executes(pe);
}
