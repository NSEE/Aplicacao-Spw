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
static const char *ng0 = "E:/Users/Dennis/Documentos/SpW/Aplicacao-Spw/Materiais/Codigos/Xilinx/Testes/Teste_Packet_Controller/source/SpW/spwxmit.vhd";
extern char *IEEE_P_1242562249;
extern char *IEEE_P_2592010699;
extern char *WORK_P_1442564703;

unsigned char ieee_p_1242562249_sub_1781507893_1035706684(char *, char *, char *, int );
char *ieee_p_1242562249_sub_180853171_1035706684(char *, char *, int , int );
char *ieee_p_1242562249_sub_1919437128_1035706684(char *, char *, char *, char *, int );
unsigned char ieee_p_2592010699_sub_1605435078_503743352(char *, unsigned char , unsigned char );
unsigned char ieee_p_2592010699_sub_1690584930_503743352(char *, unsigned char );
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );
unsigned char ieee_p_2592010699_sub_2507238156_503743352(char *, unsigned char , unsigned char );


static void work_a_2781746508_1366615453_p_0(char *t0)
{
    char t13[16];
    char *t1;
    char *t2;
    char *t3;
    unsigned int t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned char t8;
    char *t9;
    char *t10;
    char *t11;
    unsigned int t12;
    char *t14;
    unsigned int t15;
    unsigned int t16;
    unsigned char t17;
    unsigned char t18;
    unsigned char t19;
    unsigned char t20;
    unsigned char t21;
    unsigned char t22;
    unsigned char t23;
    unsigned char t24;
    unsigned int t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    unsigned int t32;
    int t33;
    unsigned int t34;
    int t35;
    unsigned int t36;
    int t37;
    unsigned char t38;
    unsigned char t39;
    unsigned char t40;
    unsigned char t41;
    unsigned char t42;
    unsigned char t43;
    unsigned char t44;
    char *t45;
    char *t46;
    unsigned char t47;
    char *t48;
    char *t49;
    char *t50;
    char *t51;
    char *t52;

LAB0:    xsi_set_current_line(94, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t1 = (t0 + 2728U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    memcpy(t1, t2, 48U);
    xsi_set_current_line(97, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 1U);
    t1 = (t2 + t4);
    t3 = (t0 + 5464);
    t5 = xsi_record_get_element_type(t3, 1);
    t6 = (t5 + 80U);
    t7 = *((char **)t6);
    t8 = ieee_p_1242562249_sub_1781507893_1035706684(IEEE_P_1242562249, t1, t7, 0);
    if (t8 != 0)
        goto LAB2;

LAB4:    xsi_set_current_line(101, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 1U);
    t1 = (t2 + t4);
    t3 = (t0 + 5464);
    t5 = xsi_record_get_element_type(t3, 1);
    t6 = (t5 + 80U);
    t7 = *((char **)t6);
    t9 = ieee_p_1242562249_sub_1919437128_1035706684(IEEE_P_1242562249, t13, t1, t7, 1);
    t10 = (t0 + 2728U);
    t11 = *((char **)t10);
    t12 = (0 + 1U);
    t10 = (t11 + t12);
    t14 = (t13 + 12U);
    t15 = *((unsigned int *)t14);
    t16 = (1U * t15);
    memcpy(t10, t9, t16);
    xsi_set_current_line(102, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 0U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;

LAB3:    xsi_set_current_line(105, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = (0 + 0U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t17 = (t8 == (unsigned char)2);
    if (t17 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(125, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = (0 + 1U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t17 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t8);
    t3 = (t0 + 2152U);
    t5 = *((char **)t3);
    t12 = (0 + 40U);
    t3 = (t5 + t12);
    t18 = *((unsigned char *)t3);
    t19 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t17, t18);
    t6 = (t0 + 2728U);
    t7 = *((char **)t6);
    t15 = (0 + 38U);
    t6 = (t7 + t15);
    *((unsigned char *)t6) = t19;
    xsi_set_current_line(126, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = (0 + 1U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t17 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t8);
    t3 = (t0 + 2152U);
    t5 = *((char **)t3);
    t12 = (0 + 40U);
    t3 = (t5 + t12);
    t18 = *((unsigned char *)t3);
    t19 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t17, t18);
    t6 = (t0 + 1512U);
    t7 = *((char **)t6);
    t15 = (0 + 2U);
    t6 = (t7 + t15);
    t20 = *((unsigned char *)t6);
    t21 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t20);
    t22 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t19, t21);
    t9 = (t0 + 2152U);
    t10 = *((char **)t9);
    t16 = (0 + 41U);
    t9 = (t10 + t16);
    t23 = *((unsigned char *)t9);
    t24 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t22, t23);
    t11 = (t0 + 2728U);
    t14 = *((char **)t11);
    t25 = (0 + 39U);
    t11 = (t14 + t25);
    *((unsigned char *)t11) = t24;
    xsi_set_current_line(130, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 0U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t17 = (t8 == (unsigned char)3);
    if (t17 != 0)
        goto LAB11;

LAB13:
LAB12:    xsi_set_current_line(191, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = (0 + 4U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t17 = (t8 == (unsigned char)3);
    if (t17 != 0)
        goto LAB50;

LAB52:
LAB51:
LAB6:    xsi_set_current_line(199, ng0);
    t1 = (t0 + 1192U);
    t2 = *((char **)t1);
    t8 = *((unsigned char *)t2);
    t17 = (t8 == (unsigned char)3);
    if (t17 != 0)
        goto LAB53;

LAB55:
LAB54:    xsi_set_current_line(210, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = (0 + 0U);
    t1 = (t2 + t4);
    t20 = *((unsigned char *)t1);
    t21 = (t20 == (unsigned char)3);
    if (t21 == 1)
        goto LAB68;

LAB69:    t19 = (unsigned char)0;

LAB70:    if (t19 == 1)
        goto LAB65;

LAB66:    t18 = (unsigned char)0;

LAB67:    if (t18 == 1)
        goto LAB62;

LAB63:    t17 = (unsigned char)0;

LAB64:    if (t17 == 1)
        goto LAB59;

LAB60:    t8 = (unsigned char)0;

LAB61:    if (t8 != 0)
        goto LAB56;

LAB58:    xsi_set_current_line(215, ng0);
    t1 = (t0 + 4376);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);

LAB57:    xsi_set_current_line(222, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = (0 + 0U);
    t1 = (t2 + t4);
    t21 = *((unsigned char *)t1);
    t22 = (t21 == (unsigned char)3);
    if (t22 == 1)
        goto LAB89;

LAB90:    t20 = (unsigned char)0;

LAB91:    if (t20 == 1)
        goto LAB86;

LAB87:    t19 = (unsigned char)0;

LAB88:    if (t19 == 1)
        goto LAB83;

LAB84:    t18 = (unsigned char)0;

LAB85:    if (t18 == 1)
        goto LAB80;

LAB81:    t17 = (unsigned char)0;

LAB82:    if (t17 == 1)
        goto LAB77;

LAB78:    t8 = (unsigned char)0;

LAB79:    if (t8 != 0)
        goto LAB74;

LAB76:    xsi_set_current_line(227, ng0);
    t1 = (t0 + 4376);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_delta(t1, 1U, 1, 0LL);

LAB75:    xsi_set_current_line(231, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t1 = (t0 + 4440);
    t3 = (t1 + 56U);
    t5 = *((char **)t3);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t2, 48U);
    xsi_driver_first_trans_fast(t1);
    t1 = (t0 + 4280);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(98, ng0);
    t9 = (t0 + 1352U);
    t10 = *((char **)t9);
    t9 = (t0 + 2728U);
    t11 = *((char **)t9);
    t12 = (0 + 1U);
    t9 = (t11 + t12);
    memcpy(t9, t10, 8U);
    xsi_set_current_line(99, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 0U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)3;
    goto LAB3;

LAB5:    xsi_set_current_line(108, ng0);
    t3 = (t0 + 9140);
    t6 = (t0 + 2728U);
    t7 = *((char **)t6);
    t12 = (0 + 22U);
    t6 = (t7 + t12);
    memcpy(t6, t3, 4U);
    xsi_set_current_line(109, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 28U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(110, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 29U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(111, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 38U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(112, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 39U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(113, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 40U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(114, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 41U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(117, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 0U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t17 = (t8 == (unsigned char)3);
    if (t17 != 0)
        goto LAB8;

LAB10:
LAB9:    goto LAB6;

LAB8:    xsi_set_current_line(118, ng0);
    t3 = (t0 + 2152U);
    t5 = *((char **)t3);
    t12 = (0 + 26U);
    t3 = (t5 + t12);
    t18 = *((unsigned char *)t3);
    t6 = (t0 + 2152U);
    t7 = *((char **)t6);
    t15 = (0 + 27U);
    t6 = (t7 + t15);
    t19 = *((unsigned char *)t6);
    t20 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t18, t19);
    t9 = (t0 + 2728U);
    t10 = *((char **)t9);
    t16 = (0 + 26U);
    t9 = (t10 + t16);
    *((unsigned char *)t9) = t20;
    xsi_set_current_line(119, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 27U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;
    goto LAB9;

LAB11:    xsi_set_current_line(132, ng0);
    t3 = (t0 + 2152U);
    t5 = *((char **)t3);
    t12 = (0 + 22U);
    t3 = (t5 + t12);
    t6 = (t0 + 5464);
    t7 = xsi_record_get_element_type(t6, 3);
    t9 = (t7 + 80U);
    t10 = *((char **)t9);
    t18 = ieee_p_1242562249_sub_1781507893_1035706684(IEEE_P_1242562249, t3, t10, 0);
    if (t18 != 0)
        goto LAB14;

LAB16:    xsi_set_current_line(178, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t33 = (0 - 12);
    t4 = (t33 * -1);
    t12 = (1U * t4);
    t15 = (0 + 9U);
    t16 = (t15 + t12);
    t1 = (t2 + t16);
    t8 = *((unsigned char *)t1);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t25 = (0 + 26U);
    t3 = (t5 + t25);
    *((unsigned char *)t3) = t8;
    xsi_set_current_line(179, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 28U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t3 = (t0 + 2152U);
    t5 = *((char **)t3);
    t33 = (0 - 12);
    t12 = (t33 * -1);
    t15 = (1U * t12);
    t16 = (0 + 9U);
    t25 = (t16 + t15);
    t3 = (t5 + t25);
    t17 = *((unsigned char *)t3);
    t18 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t8, t17);
    t6 = (t0 + 2728U);
    t7 = *((char **)t6);
    t32 = (0 + 28U);
    t6 = (t7 + t32);
    *((unsigned char *)t6) = t18;
    xsi_set_current_line(180, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    if (12 > 0)
        goto LAB36;

LAB37:    if (-1 == -1)
        goto LAB41;

LAB42:    t33 = 0;

LAB38:    t4 = (12 - t33);
    t12 = (t4 * 1U);
    t15 = (0 + 9U);
    t16 = (t15 + t12);
    t1 = (t2 + t16);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    if (12 > 0)
        goto LAB43;

LAB44:    if (-1 == -1)
        goto LAB48;

LAB49:    t35 = 0;

LAB45:    t37 = (t35 - 1);
    t25 = (12 - t37);
    t32 = (t25 * 1U);
    t34 = (0 + 9U);
    t36 = (t34 + t32);
    t3 = (t5 + t36);
    memcpy(t3, t1, 12U);
    xsi_set_current_line(181, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 22U);
    t1 = (t2 + t4);
    t3 = (t0 + 5464);
    t5 = xsi_record_get_element_type(t3, 3);
    t6 = (t5 + 80U);
    t7 = *((char **)t6);
    t9 = ieee_p_1242562249_sub_1919437128_1035706684(IEEE_P_1242562249, t13, t1, t7, 1);
    t10 = (t0 + 2728U);
    t11 = *((char **)t10);
    t12 = (0 + 22U);
    t10 = (t11 + t12);
    t14 = (t13 + 12U);
    t15 = *((unsigned int *)t14);
    t16 = (1U * t15);
    memcpy(t10, t9, t16);

LAB15:    xsi_set_current_line(186, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 27U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t3 = (t0 + 2152U);
    t5 = *((char **)t3);
    t12 = (0 + 26U);
    t3 = (t5 + t12);
    t17 = *((unsigned char *)t3);
    t18 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t8, t17);
    t6 = (t0 + 2728U);
    t7 = *((char **)t6);
    t15 = (0 + 26U);
    t6 = (t7 + t15);
    t19 = *((unsigned char *)t6);
    t20 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t18, t19);
    t21 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t20);
    t9 = (t0 + 2728U);
    t10 = *((char **)t9);
    t16 = (0 + 27U);
    t9 = (t10 + t16);
    *((unsigned char *)t9) = t21;
    goto LAB12;

LAB14:    xsi_set_current_line(135, ng0);
    t11 = (t0 + 2152U);
    t14 = *((char **)t11);
    t15 = (0 + 39U);
    t11 = (t14 + t15);
    t20 = *((unsigned char *)t11);
    t21 = (t20 == (unsigned char)3);
    if (t21 == 1)
        goto LAB20;

LAB21:    t19 = (unsigned char)0;

LAB22:    if (t19 != 0)
        goto LAB17;

LAB19:    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 38U);
    t1 = (t2 + t4);
    t17 = *((unsigned char *)t1);
    t18 = (t17 == (unsigned char)3);
    if (t18 == 1)
        goto LAB25;

LAB26:    t8 = (unsigned char)0;

LAB27:    if (t8 != 0)
        goto LAB23;

LAB24:    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 39U);
    t1 = (t2 + t4);
    t17 = *((unsigned char *)t1);
    t18 = (t17 == (unsigned char)3);
    if (t18 == 1)
        goto LAB30;

LAB31:    t8 = (unsigned char)0;

LAB32:    if (t8 != 0)
        goto LAB28;

LAB29:    xsi_set_current_line(168, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 28U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t12 = (0 + 26U);
    t3 = (t5 + t12);
    *((unsigned char *)t3) = t8;
    xsi_set_current_line(169, ng0);
    t1 = (t0 + 9152);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t4 = (12 - 6);
    t12 = (t4 * 1U);
    t15 = (0 + 9U);
    t16 = (t15 + t12);
    t3 = (t5 + t16);
    memcpy(t3, t1, 7U);
    xsi_set_current_line(170, ng0);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t13, 7, 4);
    t2 = (t0 + 2728U);
    t3 = *((char **)t2);
    t4 = (0 + 22U);
    t2 = (t3 + t4);
    memcpy(t2, t1, 4U);
    xsi_set_current_line(171, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 28U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(172, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 40U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)3;

LAB18:    goto LAB15;

LAB17:    xsi_set_current_line(137, ng0);
    t28 = (t0 + 2152U);
    t29 = *((char **)t28);
    t25 = (0 + 28U);
    t28 = (t29 + t25);
    t24 = *((unsigned char *)t28);
    t30 = (t0 + 2728U);
    t31 = *((char **)t30);
    t32 = (0 + 26U);
    t30 = (t31 + t32);
    *((unsigned char *)t30) = t24;
    xsi_set_current_line(138, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 30U);
    t1 = (t2 + t4);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t12 = (12 - 12);
    t15 = (t12 * 1U);
    t16 = (0 + 9U);
    t25 = (t16 + t15);
    t3 = (t5 + t25);
    memcpy(t3, t1, 8U);
    xsi_set_current_line(139, ng0);
    t1 = (t0 + 9144);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t4 = (12 - 4);
    t12 = (t4 * 1U);
    t15 = (0 + 9U);
    t16 = (t15 + t12);
    t3 = (t5 + t16);
    memcpy(t3, t1, 5U);
    xsi_set_current_line(140, ng0);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t13, 13, 4);
    t2 = (t0 + 2728U);
    t3 = *((char **)t2);
    t4 = (0 + 22U);
    t2 = (t3 + t4);
    memcpy(t2, t1, 4U);
    xsi_set_current_line(141, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 28U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;
    xsi_set_current_line(142, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 29U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)2;
    goto LAB18;

LAB20:    t26 = (t0 + 2152U);
    t27 = *((char **)t26);
    t16 = (0 + 29U);
    t26 = (t27 + t16);
    t22 = *((unsigned char *)t26);
    t23 = (t22 == (unsigned char)3);
    t19 = t23;
    goto LAB22;

LAB23:    xsi_set_current_line(145, ng0);
    t6 = (t0 + 2152U);
    t7 = *((char **)t6);
    t15 = (0 + 28U);
    t6 = (t7 + t15);
    t21 = *((unsigned char *)t6);
    t9 = (t0 + 2728U);
    t10 = *((char **)t9);
    t16 = (0 + 26U);
    t9 = (t10 + t16);
    *((unsigned char *)t9) = t21;
    xsi_set_current_line(146, ng0);
    t1 = (t0 + 9149);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t4 = (12 - 2);
    t12 = (t4 * 1U);
    t15 = (0 + 9U);
    t16 = (t15 + t12);
    t3 = (t5 + t16);
    memcpy(t3, t1, 3U);
    xsi_set_current_line(147, ng0);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t13, 3, 4);
    t2 = (t0 + 2728U);
    t3 = *((char **)t2);
    t4 = (0 + 22U);
    t2 = (t3 + t4);
    memcpy(t2, t1, 4U);
    xsi_set_current_line(148, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 28U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)3;
    xsi_set_current_line(149, ng0);
    t1 = (t0 + 2728U);
    t2 = *((char **)t1);
    t4 = (0 + 41U);
    t1 = (t2 + t4);
    *((unsigned char *)t1) = (unsigned char)3;
    goto LAB18;

LAB25:    t3 = (t0 + 1512U);
    t5 = *((char **)t3);
    t12 = (0 + 3U);
    t3 = (t5 + t12);
    t19 = *((unsigned char *)t3);
    t20 = (t19 == (unsigned char)3);
    t8 = t20;
    goto LAB27;

LAB28:    xsi_set_current_line(152, ng0);
    t6 = (t0 + 1512U);
    t7 = *((char **)t6);
    t15 = (0 + 14U);
    t6 = (t7 + t15);
    t21 = *((unsigned char *)t6);
    t9 = (t0 + 2728U);
    t10 = *((char **)t9);
    t33 = (0 - 12);
    t16 = (t33 * -1);
    t25 = (1U * t16);
    t32 = (0 + 9U);
    t34 = (t32 + t25);
    t9 = (t10 + t34);
    *((unsigned char *)t9) = t21;
    xsi_set_current_line(153, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = (0 + 14U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t12 = (0 + 28U);
    t3 = (t5 + t12);
    *((unsigned char *)t3) = t8;
    xsi_set_current_line(154, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = (0 + 14U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t17 = (t8 == (unsigned char)2);
    if (t17 != 0)
        goto LAB33;

LAB35:    xsi_set_current_line(161, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = (0 + 28U);
    t1 = (t2 + t4);
    t8 = *((unsigned char *)t1);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t12 = (0 + 26U);
    t3 = (t5 + t12);
    *((unsigned char *)t3) = t8;
    xsi_set_current_line(162, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t33 = (0 - 7);
    t4 = (t33 * -1);
    t12 = (1U * t4);
    t15 = (0 + 15U);
    t16 = (t15 + t12);
    t1 = (t2 + t16);
    t8 = *((unsigned char *)t1);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t35 = (1 - 12);
    t25 = (t35 * -1);
    t32 = (1U * t25);
    t34 = (0 + 9U);
    t36 = (t34 + t32);
    t3 = (t5 + t36);
    *((unsigned char *)t3) = t8;
    xsi_set_current_line(163, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t33 = (0 - 7);
    t4 = (t33 * -1);
    t12 = (1U * t4);
    t15 = (0 + 15U);
    t16 = (t15 + t12);
    t1 = (t2 + t16);
    t8 = *((unsigned char *)t1);
    t17 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t8);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t35 = (2 - 12);
    t25 = (t35 * -1);
    t32 = (1U * t25);
    t34 = (0 + 9U);
    t36 = (t34 + t32);
    t3 = (t5 + t36);
    *((unsigned char *)t3) = t17;
    xsi_set_current_line(164, ng0);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t13, 3, 4);
    t2 = (t0 + 2728U);
    t3 = *((char **)t2);
    t4 = (0 + 22U);
    t2 = (t3 + t4);
    memcpy(t2, t1, 4U);

LAB34:    goto LAB18;

LAB30:    t3 = (t0 + 1512U);
    t5 = *((char **)t3);
    t12 = (0 + 13U);
    t3 = (t5 + t12);
    t19 = *((unsigned char *)t3);
    t20 = (t19 == (unsigned char)3);
    t8 = t20;
    goto LAB32;

LAB33:    xsi_set_current_line(156, ng0);
    t3 = (t0 + 2152U);
    t5 = *((char **)t3);
    t12 = (0 + 28U);
    t3 = (t5 + t12);
    t18 = *((unsigned char *)t3);
    t19 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t18);
    t6 = (t0 + 2728U);
    t7 = *((char **)t6);
    t15 = (0 + 26U);
    t6 = (t7 + t15);
    *((unsigned char *)t6) = t19;
    xsi_set_current_line(157, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = (0 + 15U);
    t1 = (t2 + t4);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t12 = (12 - 8);
    t15 = (t12 * 1U);
    t16 = (0 + 9U);
    t25 = (t16 + t15);
    t3 = (t5 + t25);
    memcpy(t3, t1, 8U);
    xsi_set_current_line(158, ng0);
    t1 = ieee_p_1242562249_sub_180853171_1035706684(IEEE_P_1242562249, t13, 9, 4);
    t2 = (t0 + 2728U);
    t3 = *((char **)t2);
    t4 = (0 + 22U);
    t2 = (t3 + t4);
    memcpy(t2, t1, 4U);
    goto LAB34;

LAB36:    if (-1 == 1)
        goto LAB39;

LAB40:    t33 = 12;
    goto LAB38;

LAB39:    t33 = 0;
    goto LAB38;

LAB41:    t33 = 12;
    goto LAB38;

LAB43:    if (-1 == 1)
        goto LAB46;

LAB47:    t35 = 12;
    goto LAB45;

LAB46:    t35 = 0;
    goto LAB45;

LAB48:    t35 = 12;
    goto LAB45;

LAB50:    xsi_set_current_line(192, ng0);
    t3 = (t0 + 2728U);
    t5 = *((char **)t3);
    t12 = (0 + 29U);
    t3 = (t5 + t12);
    *((unsigned char *)t3) = (unsigned char)3;
    xsi_set_current_line(193, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = (0 + 5U);
    t1 = (t2 + t4);
    t3 = (t0 + 1512U);
    t5 = *((char **)t3);
    t12 = (0 + 7U);
    t3 = (t5 + t12);
    t7 = ((IEEE_P_2592010699) + 4024);
    t9 = ((WORK_P_1442564703) + 4376);
    t10 = xsi_record_get_element_type(t9, 5);
    t11 = (t10 + 80U);
    t14 = *((char **)t11);
    t26 = ((WORK_P_1442564703) + 4376);
    t27 = xsi_record_get_element_type(t26, 6);
    t28 = (t27 + 80U);
    t29 = *((char **)t28);
    t6 = xsi_base_array_concat(t6, t13, t7, (char)97, t1, t14, (char)97, t3, t29, (char)101);
    t30 = (t0 + 2728U);
    t31 = *((char **)t30);
    t15 = (0 + 30U);
    t30 = (t31 + t15);
    t16 = (2U + 6U);
    memcpy(t30, t6, t16);
    goto LAB51;

LAB53:    xsi_set_current_line(200, ng0);
    t1 = (t0 + 2608U);
    t3 = *((char **)t1);
    t1 = (t0 + 2728U);
    t5 = *((char **)t1);
    t1 = (t5 + 0);
    memcpy(t1, t3, 48U);
    goto LAB54;

LAB56:    xsi_set_current_line(213, ng0);
    t45 = (t0 + 1512U);
    t46 = *((char **)t45);
    t34 = (0 + 3U);
    t45 = (t46 + t34);
    t47 = *((unsigned char *)t45);
    t48 = (t0 + 4376);
    t49 = (t48 + 56U);
    t50 = *((char **)t49);
    t51 = (t50 + 56U);
    t52 = *((char **)t51);
    *((unsigned char *)t52) = t47;
    xsi_driver_first_trans_delta(t48, 0U, 1, 0LL);
    goto LAB57;

LAB59:    t28 = (t0 + 2152U);
    t29 = *((char **)t28);
    t25 = (0 + 39U);
    t28 = (t29 + t25);
    t41 = *((unsigned char *)t28);
    t42 = (t41 == (unsigned char)2);
    if (t42 == 1)
        goto LAB71;

LAB72:    t30 = (t0 + 2152U);
    t31 = *((char **)t30);
    t32 = (0 + 29U);
    t30 = (t31 + t32);
    t43 = *((unsigned char *)t30);
    t44 = (t43 == (unsigned char)2);
    t40 = t44;

LAB73:    t8 = t40;
    goto LAB61;

LAB62:    t26 = (t0 + 2152U);
    t27 = *((char **)t26);
    t16 = (0 + 38U);
    t26 = (t27 + t16);
    t38 = *((unsigned char *)t26);
    t39 = (t38 == (unsigned char)3);
    t17 = t39;
    goto LAB64;

LAB65:    t6 = (t0 + 2152U);
    t7 = *((char **)t6);
    t15 = (0 + 22U);
    t6 = (t7 + t15);
    t9 = (t0 + 5464);
    t10 = xsi_record_get_element_type(t9, 3);
    t11 = (t10 + 80U);
    t14 = *((char **)t11);
    t24 = ieee_p_1242562249_sub_1781507893_1035706684(IEEE_P_1242562249, t6, t14, 0);
    t18 = t24;
    goto LAB67;

LAB68:    t3 = (t0 + 2152U);
    t5 = *((char **)t3);
    t12 = (0 + 0U);
    t3 = (t5 + t12);
    t22 = *((unsigned char *)t3);
    t23 = (t22 == (unsigned char)3);
    t19 = t23;
    goto LAB70;

LAB71:    t40 = (unsigned char)1;
    goto LAB73;

LAB74:    xsi_set_current_line(225, ng0);
    t45 = (t0 + 1512U);
    t46 = *((char **)t45);
    t34 = (0 + 13U);
    t45 = (t46 + t34);
    t47 = *((unsigned char *)t45);
    t48 = (t0 + 4376);
    t49 = (t48 + 56U);
    t50 = *((char **)t49);
    t51 = (t50 + 56U);
    t52 = *((char **)t51);
    *((unsigned char *)t52) = t47;
    xsi_driver_first_trans_delta(t48, 1U, 1, 0LL);
    goto LAB75;

LAB77:    t30 = (t0 + 1512U);
    t31 = *((char **)t30);
    t32 = (0 + 3U);
    t30 = (t31 + t32);
    t43 = *((unsigned char *)t30);
    t44 = (t43 == (unsigned char)2);
    t8 = t44;
    goto LAB79;

LAB80:    t28 = (t0 + 2152U);
    t29 = *((char **)t28);
    t25 = (0 + 29U);
    t28 = (t29 + t25);
    t41 = *((unsigned char *)t28);
    t42 = (t41 == (unsigned char)2);
    t17 = t42;
    goto LAB82;

LAB83:    t26 = (t0 + 2152U);
    t27 = *((char **)t26);
    t16 = (0 + 39U);
    t26 = (t27 + t16);
    t39 = *((unsigned char *)t26);
    t40 = (t39 == (unsigned char)3);
    t18 = t40;
    goto LAB85;

LAB86:    t6 = (t0 + 2152U);
    t7 = *((char **)t6);
    t15 = (0 + 22U);
    t6 = (t7 + t15);
    t9 = (t0 + 5464);
    t10 = xsi_record_get_element_type(t9, 3);
    t11 = (t10 + 80U);
    t14 = *((char **)t11);
    t38 = ieee_p_1242562249_sub_1781507893_1035706684(IEEE_P_1242562249, t6, t14, 0);
    t19 = t38;
    goto LAB88;

LAB89:    t3 = (t0 + 2152U);
    t5 = *((char **)t3);
    t12 = (0 + 0U);
    t3 = (t5 + t12);
    t23 = *((unsigned char *)t3);
    t24 = (t23 == (unsigned char)3);
    t20 = t24;
    goto LAB91;

}

static void work_a_2781746508_1366615453_p_1(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    unsigned int t9;

LAB0:    xsi_set_current_line(237, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4296);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(240, ng0);
    t3 = (t0 + 2312U);
    t4 = *((char **)t3);
    t3 = (t0 + 4504);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t4, 48U);
    xsi_driver_first_trans_fast(t3);
    xsi_set_current_line(243, ng0);
    t1 = (t0 + 2152U);
    t3 = *((char **)t1);
    t9 = (0 + 26U);
    t1 = (t3 + t9);
    t2 = *((unsigned char *)t1);
    t4 = (t0 + 4568);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t2;
    xsi_driver_first_trans_fast_port(t4);
    xsi_set_current_line(244, ng0);
    t1 = (t0 + 2152U);
    t3 = *((char **)t1);
    t9 = (0 + 27U);
    t1 = (t3 + t9);
    t2 = *((unsigned char *)t1);
    t4 = (t0 + 4632);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t2;
    xsi_driver_first_trans_fast_port(t4);
    goto LAB3;

}


extern void work_a_2781746508_1366615453_init()
{
	static char *pe[] = {(void *)work_a_2781746508_1366615453_p_0,(void *)work_a_2781746508_1366615453_p_1};
	xsi_register_didat("work_a_2781746508_1366615453", "isim/tb_teste_controller_isim_beh.exe.sim/work/a_2781746508_1366615453.didat");
	xsi_register_executes(pe);
}
