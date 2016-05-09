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
static const char *ng0 = "E:/Users/Dennis/Documentos/SpW/Aplicacao-Spw/Materiais/Codigos/Xilinx/Testes/Teste_Packet_Controller/source/registrador.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_1657552908_1035706684(char *, char *, char *);
char *ieee_p_1242562249_sub_180853171_1035706684(char *, char *, int , int );
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_3636356752_1516540902_p_0(char *t0)
{
    char t7[16];
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t8;
    int t9;
    int t10;
    int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    unsigned char t24;
    char *t25;

LAB0:    xsi_set_current_line(65, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 8496);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(68, ng0);
    t3 = (t0 + 2312U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:
LAB6:    xsi_set_current_line(73, ng0);
    t1 = (t0 + 2792U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB8;

LAB10:
LAB9:    xsi_set_current_line(78, ng0);
    t1 = (t0 + 3272U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB11;

LAB13:
LAB12:    xsi_set_current_line(83, ng0);
    t1 = (t0 + 3752U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB14;

LAB16:
LAB15:    xsi_set_current_line(88, ng0);
    t1 = (t0 + 1992U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB17;

LAB19:
LAB18:    goto LAB3;

LAB5:    xsi_set_current_line(69, ng0);
    t3 = (t0 + 4728U);
    t8 = *((char **)t3);
    t9 = *((int *)t8);
    t3 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t7, t9, 7);
    t10 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t3, t7);
    t11 = (t10 - 0);
    t12 = (t11 * 1);
    t13 = (8U * t12);
    t14 = (0U + t13);
    t15 = (7 - 7);
    t16 = (t15 * -1);
    t17 = (1 * t16);
    t18 = (t14 + t17);
    t19 = (t0 + 8704);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    *((unsigned char *)t23) = (unsigned char)2;
    xsi_driver_first_trans_delta(t19, t18, 1, 0LL);
    goto LAB6;

LAB8:    xsi_set_current_line(74, ng0);
    t1 = (t0 + 5088U);
    t4 = *((char **)t1);
    t9 = *((int *)t4);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t7, t9, 7);
    t10 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t1, t7);
    t11 = (t10 - 0);
    t12 = (t11 * 1);
    t13 = (8U * t12);
    t14 = (0U + t13);
    t15 = (7 - 7);
    t16 = (t15 * -1);
    t17 = (1 * t16);
    t18 = (t14 + t17);
    t8 = (t0 + 8704);
    t19 = (t8 + 56U);
    t20 = *((char **)t19);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    *((unsigned char *)t22) = (unsigned char)2;
    xsi_driver_first_trans_delta(t8, t18, 1, 0LL);
    goto LAB9;

LAB11:    xsi_set_current_line(79, ng0);
    t1 = (t0 + 4368U);
    t4 = *((char **)t1);
    t9 = *((int *)t4);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t7, t9, 7);
    t10 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t1, t7);
    t11 = (t10 - 0);
    t12 = (t11 * 1);
    t13 = (8U * t12);
    t14 = (0U + t13);
    t15 = (7 - 7);
    t16 = (t15 * -1);
    t17 = (1 * t16);
    t18 = (t14 + t17);
    t8 = (t0 + 8704);
    t19 = (t8 + 56U);
    t20 = *((char **)t19);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    *((unsigned char *)t22) = (unsigned char)2;
    xsi_driver_first_trans_delta(t8, t18, 1, 0LL);
    goto LAB12;

LAB14:    xsi_set_current_line(84, ng0);
    t1 = (t0 + 4488U);
    t4 = *((char **)t1);
    t9 = *((int *)t4);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t7, t9, 7);
    t10 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t1, t7);
    t11 = (t10 - 0);
    t12 = (t11 * 1);
    t13 = (8U * t12);
    t14 = (0U + t13);
    t15 = (7 - 7);
    t16 = (t15 * -1);
    t17 = (1 * t16);
    t18 = (t14 + t17);
    t8 = (t0 + 8704);
    t19 = (t8 + 56U);
    t20 = *((char **)t19);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    *((unsigned char *)t22) = (unsigned char)2;
    xsi_driver_first_trans_delta(t8, t18, 1, 0LL);
    goto LAB15;

LAB17:    xsi_set_current_line(91, ng0);
    t1 = (t0 + 1832U);
    t4 = *((char **)t1);
    t6 = *((unsigned char *)t4);
    t24 = (t6 == (unsigned char)2);
    if (t24 != 0)
        goto LAB20;

LAB22:    xsi_set_current_line(96, ng0);
    t1 = (t0 + 4072U);
    t3 = *((char **)t1);
    t1 = (t0 + 1352U);
    t4 = *((char **)t1);
    t1 = (t0 + 16184U);
    t9 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t4, t1);
    t10 = (t9 - 0);
    t12 = (t10 * 1);
    xsi_vhdl_check_range_of_index(0, 127, 1, t9);
    t13 = (8U * t12);
    t14 = (0 + t13);
    t8 = (t3 + t14);
    t19 = (t0 + 8768);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    memcpy(t23, t8, 8U);
    xsi_driver_first_trans_fast_port(t19);

LAB21:    goto LAB18;

LAB20:    xsi_set_current_line(92, ng0);
    t1 = (t0 + 1512U);
    t8 = *((char **)t1);
    t1 = (t0 + 1352U);
    t19 = *((char **)t1);
    t1 = (t0 + 16184U);
    t9 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t19, t1);
    t10 = (t9 - 0);
    t12 = (t10 * 1);
    t13 = (8U * t12);
    t14 = (0U + t13);
    t20 = (t0 + 8704);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    t23 = (t22 + 56U);
    t25 = *((char **)t23);
    memcpy(t25, t8, 8U);
    xsi_driver_first_trans_delta(t20, t14, 8U, 0LL);
    goto LAB21;

}

static void work_a_3636356752_1516540902_p_1(char *t0)
{
    char t5[16];
    char t19[16];
    char t30[16];
    char t32[16];
    char t37[16];
    char t41[16];
    char t50[16];
    char t52[16];
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned int t4;
    char *t6;
    int t7;
    int t8;
    int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    char *t20;
    int t21;
    int t22;
    int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;
    char *t29;
    char *t31;
    char *t33;
    char *t34;
    int t35;
    unsigned int t36;
    char *t38;
    int t39;
    char *t40;
    char *t42;
    int t43;
    int t44;
    int t45;
    unsigned int t46;
    unsigned int t47;
    char *t48;
    char *t49;
    char *t51;
    char *t53;
    char *t54;
    int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned char t58;
    char *t59;
    char *t60;
    char *t61;
    char *t62;
    char *t63;

LAB0:    xsi_set_current_line(106, ng0);

LAB3:    t1 = (t0 + 4072U);
    t2 = *((char **)t1);
    t3 = (7 - 3);
    t4 = (t3 * 1U);
    t1 = (t0 + 4608U);
    t6 = *((char **)t1);
    t7 = *((int *)t6);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t5, t7, 7);
    t8 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t1, t5);
    t9 = (t8 - 0);
    t10 = (t9 * 1);
    t11 = (8U * t10);
    t12 = (0 + t11);
    t13 = (t12 + t4);
    t14 = (t2 + t13);
    t15 = (t0 + 4072U);
    t16 = *((char **)t15);
    t17 = (7 - 3);
    t18 = (t17 * 1U);
    t15 = (t0 + 4728U);
    t20 = *((char **)t15);
    t21 = *((int *)t20);
    t15 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t19, t21, 7);
    t22 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t15, t19);
    t23 = (t22 - 0);
    t24 = (t23 * 1);
    t25 = (8U * t24);
    t26 = (0 + t25);
    t27 = (t26 + t18);
    t28 = (t16 + t27);
    t31 = ((IEEE_P_2592010699) + 4024);
    t33 = (t32 + 0U);
    t34 = (t33 + 0U);
    *((int *)t34) = 3;
    t34 = (t33 + 4U);
    *((int *)t34) = 0;
    t34 = (t33 + 8U);
    *((int *)t34) = -1;
    t35 = (0 - 3);
    t36 = (t35 * -1);
    t36 = (t36 + 1);
    t34 = (t33 + 12U);
    *((unsigned int *)t34) = t36;
    t34 = (t37 + 0U);
    t38 = (t34 + 0U);
    *((int *)t38) = 3;
    t38 = (t34 + 4U);
    *((int *)t38) = 0;
    t38 = (t34 + 8U);
    *((int *)t38) = -1;
    t39 = (0 - 3);
    t36 = (t39 * -1);
    t36 = (t36 + 1);
    t38 = (t34 + 12U);
    *((unsigned int *)t38) = t36;
    t29 = xsi_base_array_concat(t29, t30, t31, (char)97, t14, t32, (char)97, t28, t37, (char)101);
    t38 = (t0 + 4072U);
    t40 = *((char **)t38);
    t38 = (t0 + 4848U);
    t42 = *((char **)t38);
    t43 = *((int *)t42);
    t38 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t41, t43, 7);
    t44 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t38, t41);
    t45 = (t44 - 0);
    t36 = (t45 * 1);
    t46 = (8U * t36);
    t47 = (0 + t46);
    t48 = (t40 + t47);
    t51 = ((IEEE_P_2592010699) + 4024);
    t53 = (t52 + 0U);
    t54 = (t53 + 0U);
    *((int *)t54) = 7;
    t54 = (t53 + 4U);
    *((int *)t54) = 0;
    t54 = (t53 + 8U);
    *((int *)t54) = -1;
    t55 = (0 - 7);
    t56 = (t55 * -1);
    t56 = (t56 + 1);
    t54 = (t53 + 12U);
    *((unsigned int *)t54) = t56;
    t49 = xsi_base_array_concat(t49, t50, t51, (char)97, t29, t30, (char)97, t48, t52, (char)101);
    t56 = (4U + 4U);
    t57 = (t56 + 8U);
    t58 = (16U != t57);
    if (t58 == 1)
        goto LAB5;

LAB6:    t54 = (t0 + 8832);
    t59 = (t54 + 56U);
    t60 = *((char **)t59);
    t61 = (t60 + 56U);
    t62 = *((char **)t61);
    memcpy(t62, t49, 16U);
    xsi_driver_first_trans_fast_port(t54);

LAB2:    t63 = (t0 + 8512);
    *((int *)t63) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(16U, t57, 0);
    goto LAB6;

}

static void work_a_3636356752_1516540902_p_2(char *t0)
{
    char t6[16];
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    char *t7;
    int t8;
    int t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    unsigned char t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;

LAB0:    xsi_set_current_line(107, ng0);

LAB3:    t1 = (t0 + 4072U);
    t2 = *((char **)t1);
    t3 = (7 - 7);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t1 = (t0 + 4728U);
    t7 = *((char **)t1);
    t8 = *((int *)t7);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t6, t8, 7);
    t9 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t1, t6);
    t10 = (t9 - 0);
    t11 = (t10 * 1);
    t12 = (8U * t11);
    t13 = (0 + t12);
    t14 = (t13 + t5);
    t15 = (t2 + t14);
    t16 = *((unsigned char *)t15);
    t17 = (t0 + 8896);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    *((unsigned char *)t21) = t16;
    xsi_driver_first_trans_fast_port(t17);

LAB2:    t22 = (t0 + 8528);
    *((int *)t22) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3636356752_1516540902_p_3(char *t0)
{
    char t5[16];
    char t19[16];
    char t30[16];
    char t32[16];
    char t37[16];
    char t41[16];
    char t50[16];
    char t52[16];
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned int t4;
    char *t6;
    int t7;
    int t8;
    int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    char *t20;
    int t21;
    int t22;
    int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;
    char *t29;
    char *t31;
    char *t33;
    char *t34;
    int t35;
    unsigned int t36;
    char *t38;
    int t39;
    char *t40;
    char *t42;
    int t43;
    int t44;
    int t45;
    unsigned int t46;
    unsigned int t47;
    char *t48;
    char *t49;
    char *t51;
    char *t53;
    char *t54;
    int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned char t58;
    char *t59;
    char *t60;
    char *t61;
    char *t62;
    char *t63;

LAB0:    xsi_set_current_line(110, ng0);

LAB3:    t1 = (t0 + 4072U);
    t2 = *((char **)t1);
    t3 = (7 - 3);
    t4 = (t3 * 1U);
    t1 = (t0 + 4968U);
    t6 = *((char **)t1);
    t7 = *((int *)t6);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t5, t7, 7);
    t8 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t1, t5);
    t9 = (t8 - 0);
    t10 = (t9 * 1);
    t11 = (8U * t10);
    t12 = (0 + t11);
    t13 = (t12 + t4);
    t14 = (t2 + t13);
    t15 = (t0 + 4072U);
    t16 = *((char **)t15);
    t17 = (7 - 3);
    t18 = (t17 * 1U);
    t15 = (t0 + 5088U);
    t20 = *((char **)t15);
    t21 = *((int *)t20);
    t15 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t19, t21, 7);
    t22 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t15, t19);
    t23 = (t22 - 0);
    t24 = (t23 * 1);
    t25 = (8U * t24);
    t26 = (0 + t25);
    t27 = (t26 + t18);
    t28 = (t16 + t27);
    t31 = ((IEEE_P_2592010699) + 4024);
    t33 = (t32 + 0U);
    t34 = (t33 + 0U);
    *((int *)t34) = 3;
    t34 = (t33 + 4U);
    *((int *)t34) = 0;
    t34 = (t33 + 8U);
    *((int *)t34) = -1;
    t35 = (0 - 3);
    t36 = (t35 * -1);
    t36 = (t36 + 1);
    t34 = (t33 + 12U);
    *((unsigned int *)t34) = t36;
    t34 = (t37 + 0U);
    t38 = (t34 + 0U);
    *((int *)t38) = 3;
    t38 = (t34 + 4U);
    *((int *)t38) = 0;
    t38 = (t34 + 8U);
    *((int *)t38) = -1;
    t39 = (0 - 3);
    t36 = (t39 * -1);
    t36 = (t36 + 1);
    t38 = (t34 + 12U);
    *((unsigned int *)t38) = t36;
    t29 = xsi_base_array_concat(t29, t30, t31, (char)97, t14, t32, (char)97, t28, t37, (char)101);
    t38 = (t0 + 4072U);
    t40 = *((char **)t38);
    t38 = (t0 + 5208U);
    t42 = *((char **)t38);
    t43 = *((int *)t42);
    t38 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t41, t43, 7);
    t44 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t38, t41);
    t45 = (t44 - 0);
    t36 = (t45 * 1);
    t46 = (8U * t36);
    t47 = (0 + t46);
    t48 = (t40 + t47);
    t51 = ((IEEE_P_2592010699) + 4024);
    t53 = (t52 + 0U);
    t54 = (t53 + 0U);
    *((int *)t54) = 7;
    t54 = (t53 + 4U);
    *((int *)t54) = 0;
    t54 = (t53 + 8U);
    *((int *)t54) = -1;
    t55 = (0 - 7);
    t56 = (t55 * -1);
    t56 = (t56 + 1);
    t54 = (t53 + 12U);
    *((unsigned int *)t54) = t56;
    t49 = xsi_base_array_concat(t49, t50, t51, (char)97, t29, t30, (char)97, t48, t52, (char)101);
    t56 = (4U + 4U);
    t57 = (t56 + 8U);
    t58 = (16U != t57);
    if (t58 == 1)
        goto LAB5;

LAB6:    t54 = (t0 + 8960);
    t59 = (t54 + 56U);
    t60 = *((char **)t59);
    t61 = (t60 + 56U);
    t62 = *((char **)t61);
    memcpy(t62, t49, 16U);
    xsi_driver_first_trans_fast_port(t54);

LAB2:    t63 = (t0 + 8544);
    *((int *)t63) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(16U, t57, 0);
    goto LAB6;

}

static void work_a_3636356752_1516540902_p_4(char *t0)
{
    char t6[16];
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    char *t7;
    int t8;
    int t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    unsigned char t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;

LAB0:    xsi_set_current_line(111, ng0);

LAB3:    t1 = (t0 + 4072U);
    t2 = *((char **)t1);
    t3 = (7 - 7);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t1 = (t0 + 5088U);
    t7 = *((char **)t1);
    t8 = *((int *)t7);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t6, t8, 7);
    t9 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t1, t6);
    t10 = (t9 - 0);
    t11 = (t10 * 1);
    t12 = (8U * t11);
    t13 = (0 + t12);
    t14 = (t13 + t5);
    t15 = (t2 + t14);
    t16 = *((unsigned char *)t15);
    t17 = (t0 + 9024);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    *((unsigned char *)t21) = t16;
    xsi_driver_first_trans_fast_port(t17);

LAB2:    t22 = (t0 + 8560);
    *((int *)t22) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3636356752_1516540902_p_5(char *t0)
{
    char t7[16];
    char t18[16];
    char t20[16];
    char t25[16];
    char t30[16];
    char t32[16];
    char *t1;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    char *t8;
    int t9;
    int t10;
    int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    char *t17;
    char *t19;
    char *t21;
    char *t22;
    int t23;
    unsigned int t24;
    char *t26;
    int t27;
    char *t29;
    char *t31;
    char *t33;
    char *t34;
    int t35;
    unsigned int t36;
    unsigned char t37;
    char *t38;
    char *t39;
    char *t40;
    char *t41;
    char *t42;

LAB0:    xsi_set_current_line(114, ng0);

LAB3:    t1 = (t0 + 17416);
    t3 = (t0 + 4072U);
    t4 = *((char **)t3);
    t5 = (7 - 3);
    t6 = (t5 * 1U);
    t3 = (t0 + 4368U);
    t8 = *((char **)t3);
    t9 = *((int *)t8);
    t3 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t7, t9, 7);
    t10 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t3, t7);
    t11 = (t10 - 0);
    t12 = (t11 * 1);
    t13 = (8U * t12);
    t14 = (0 + t13);
    t15 = (t14 + t6);
    t16 = (t4 + t15);
    t19 = ((IEEE_P_2592010699) + 4024);
    t21 = (t20 + 0U);
    t22 = (t21 + 0U);
    *((int *)t22) = 0;
    t22 = (t21 + 4U);
    *((int *)t22) = 0;
    t22 = (t21 + 8U);
    *((int *)t22) = 1;
    t23 = (0 - 0);
    t24 = (t23 * 1);
    t24 = (t24 + 1);
    t22 = (t21 + 12U);
    *((unsigned int *)t22) = t24;
    t22 = (t25 + 0U);
    t26 = (t22 + 0U);
    *((int *)t26) = 3;
    t26 = (t22 + 4U);
    *((int *)t26) = 0;
    t26 = (t22 + 8U);
    *((int *)t26) = -1;
    t27 = (0 - 3);
    t24 = (t27 * -1);
    t24 = (t24 + 1);
    t26 = (t22 + 12U);
    *((unsigned int *)t26) = t24;
    t17 = xsi_base_array_concat(t17, t18, t19, (char)97, t1, t20, (char)97, t16, t25, (char)101);
    t26 = (t0 + 17417);
    t31 = ((IEEE_P_2592010699) + 4024);
    t33 = (t32 + 0U);
    t34 = (t33 + 0U);
    *((int *)t34) = 0;
    t34 = (t33 + 4U);
    *((int *)t34) = 13;
    t34 = (t33 + 8U);
    *((int *)t34) = 1;
    t35 = (13 - 0);
    t24 = (t35 * 1);
    t24 = (t24 + 1);
    t34 = (t33 + 12U);
    *((unsigned int *)t34) = t24;
    t29 = xsi_base_array_concat(t29, t30, t31, (char)97, t17, t18, (char)97, t26, t32, (char)101);
    t24 = (1U + 4U);
    t36 = (t24 + 14U);
    t37 = (19U != t36);
    if (t37 == 1)
        goto LAB5;

LAB6:    t34 = (t0 + 9088);
    t38 = (t34 + 56U);
    t39 = *((char **)t38);
    t40 = (t39 + 56U);
    t41 = *((char **)t40);
    memcpy(t41, t29, 19U);
    xsi_driver_first_trans_fast_port(t34);

LAB2:    t42 = (t0 + 8576);
    *((int *)t42) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(19U, t36, 0);
    goto LAB6;

}

static void work_a_3636356752_1516540902_p_6(char *t0)
{
    char t6[16];
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    char *t7;
    int t8;
    int t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    unsigned char t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;

LAB0:    xsi_set_current_line(115, ng0);

LAB3:    t1 = (t0 + 4072U);
    t2 = *((char **)t1);
    t3 = (7 - 7);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t1 = (t0 + 4368U);
    t7 = *((char **)t1);
    t8 = *((int *)t7);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t6, t8, 7);
    t9 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t1, t6);
    t10 = (t9 - 0);
    t11 = (t10 * 1);
    t12 = (8U * t11);
    t13 = (0 + t12);
    t14 = (t13 + t5);
    t15 = (t2 + t14);
    t16 = *((unsigned char *)t15);
    t17 = (t0 + 9152);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    *((unsigned char *)t21) = t16;
    xsi_driver_first_trans_fast_port(t17);

LAB2:    t22 = (t0 + 8592);
    *((int *)t22) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3636356752_1516540902_p_7(char *t0)
{
    char t7[16];
    char t18[16];
    char t20[16];
    char t25[16];
    char t30[16];
    char t32[16];
    char *t1;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    char *t8;
    int t9;
    int t10;
    int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    char *t17;
    char *t19;
    char *t21;
    char *t22;
    int t23;
    unsigned int t24;
    char *t26;
    int t27;
    char *t29;
    char *t31;
    char *t33;
    char *t34;
    int t35;
    unsigned int t36;
    unsigned char t37;
    char *t38;
    char *t39;
    char *t40;
    char *t41;
    char *t42;

LAB0:    xsi_set_current_line(118, ng0);

LAB3:    t1 = (t0 + 17431);
    t3 = (t0 + 4072U);
    t4 = *((char **)t3);
    t5 = (7 - 3);
    t6 = (t5 * 1U);
    t3 = (t0 + 4488U);
    t8 = *((char **)t3);
    t9 = *((int *)t8);
    t3 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t7, t9, 7);
    t10 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t3, t7);
    t11 = (t10 - 0);
    t12 = (t11 * 1);
    t13 = (8U * t12);
    t14 = (0 + t13);
    t15 = (t14 + t6);
    t16 = (t4 + t15);
    t19 = ((IEEE_P_2592010699) + 4024);
    t21 = (t20 + 0U);
    t22 = (t21 + 0U);
    *((int *)t22) = 0;
    t22 = (t21 + 4U);
    *((int *)t22) = 0;
    t22 = (t21 + 8U);
    *((int *)t22) = 1;
    t23 = (0 - 0);
    t24 = (t23 * 1);
    t24 = (t24 + 1);
    t22 = (t21 + 12U);
    *((unsigned int *)t22) = t24;
    t22 = (t25 + 0U);
    t26 = (t22 + 0U);
    *((int *)t26) = 3;
    t26 = (t22 + 4U);
    *((int *)t26) = 0;
    t26 = (t22 + 8U);
    *((int *)t26) = -1;
    t27 = (0 - 3);
    t24 = (t27 * -1);
    t24 = (t24 + 1);
    t26 = (t22 + 12U);
    *((unsigned int *)t26) = t24;
    t17 = xsi_base_array_concat(t17, t18, t19, (char)97, t1, t20, (char)97, t16, t25, (char)101);
    t26 = (t0 + 17432);
    t31 = ((IEEE_P_2592010699) + 4024);
    t33 = (t32 + 0U);
    t34 = (t33 + 0U);
    *((int *)t34) = 0;
    t34 = (t33 + 4U);
    *((int *)t34) = 13;
    t34 = (t33 + 8U);
    *((int *)t34) = 1;
    t35 = (13 - 0);
    t24 = (t35 * 1);
    t24 = (t24 + 1);
    t34 = (t33 + 12U);
    *((unsigned int *)t34) = t24;
    t29 = xsi_base_array_concat(t29, t30, t31, (char)97, t17, t18, (char)97, t26, t32, (char)101);
    t24 = (1U + 4U);
    t36 = (t24 + 14U);
    t37 = (19U != t36);
    if (t37 == 1)
        goto LAB5;

LAB6:    t34 = (t0 + 9216);
    t38 = (t34 + 56U);
    t39 = *((char **)t38);
    t40 = (t39 + 56U);
    t41 = *((char **)t40);
    memcpy(t41, t29, 19U);
    xsi_driver_first_trans_fast_port(t34);

LAB2:    t42 = (t0 + 8608);
    *((int *)t42) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(19U, t36, 0);
    goto LAB6;

}

static void work_a_3636356752_1516540902_p_8(char *t0)
{
    char t6[16];
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    char *t7;
    int t8;
    int t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    unsigned char t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;

LAB0:    xsi_set_current_line(119, ng0);

LAB3:    t1 = (t0 + 4072U);
    t2 = *((char **)t1);
    t3 = (7 - 7);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t1 = (t0 + 4488U);
    t7 = *((char **)t1);
    t8 = *((int *)t7);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t6, t8, 7);
    t9 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t1, t6);
    t10 = (t9 - 0);
    t11 = (t10 * 1);
    t12 = (8U * t11);
    t13 = (0 + t12);
    t14 = (t13 + t5);
    t15 = (t2 + t14);
    t16 = *((unsigned char *)t15);
    t17 = (t0 + 9280);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    *((unsigned char *)t21) = t16;
    xsi_driver_first_trans_fast_port(t17);

LAB2:    t22 = (t0 + 8624);
    *((int *)t22) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_3636356752_1516540902_init()
{
	static char *pe[] = {(void *)work_a_3636356752_1516540902_p_0,(void *)work_a_3636356752_1516540902_p_1,(void *)work_a_3636356752_1516540902_p_2,(void *)work_a_3636356752_1516540902_p_3,(void *)work_a_3636356752_1516540902_p_4,(void *)work_a_3636356752_1516540902_p_5,(void *)work_a_3636356752_1516540902_p_6,(void *)work_a_3636356752_1516540902_p_7,(void *)work_a_3636356752_1516540902_p_8};
	xsi_register_didat("work_a_3636356752_1516540902", "isim/tb_teste_controller_isim_beh.exe.sim/work/a_3636356752_1516540902.didat");
	xsi_register_executes(pe);
}
