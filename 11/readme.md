
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [标志寄存器](#标志寄存器)
	* [ZF标志](#zf标志)
	* [PF标志](#pf标志)
	* [SF标志](#sf标志)
	* [CF标志](#cf标志)
	* [OF标志](#of标志)
	* [adc标志](#adc标志)
	* [sbb标志](#sbb标志)
	* [cmp指令](#cmp指令)
	* [检测比较结果的条件转移指令](#检测比较结果的条件转移指令)
	* [DF标志和串传送指令](#df标志和串传送指令)
	* [push和popf](#push和popf)
	* [标志寄存器在Debug中的表示](#标志寄存器在debug中的表示)

<!-- /code_chunk_output -->



# 标志寄存器

标志寄存器(简称flag)（其中存储的信息通常被称为程序状态字PSW）的作用：
1. 用来存储相关指令的某些执行结果
2. 用来为cpu执行相关指令提供行为依据
3. 用来控制CPU的相关工作方式

`flag`寄存器按位起作用，每一位都有专门的含义。

## ZF标志

## PF标志

## SF标志

## CF标志

## OF标志

## adc标志

## sbb标志

## cmp指令

## 检测比较结果的条件转移指令

## DF标志和串传送指令

## push和popf

## 标志寄存器在Debug中的表示