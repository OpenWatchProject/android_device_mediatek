/****************************************************************************
 ****************************************************************************
 ***
 ***   This header was automatically generated from a Linux kernel header
 ***   of the same name, to make information necessary for userspace to
 ***   call into the kernel available to libc.  It contains only constants,
 ***   structures, and macros generated from the original header, and thus,
 ***   contains no copyrightable information.
 ***
 ***   To edit the content of this header, modify the corresponding
 ***   source file (e.g. under external/kernel-headers/original/) then
 ***   run bionic/libc/kernel/tools/update_all.py
 ***
 ***   Any manual change here will be lost the next time this script will
 ***   be run. You've been warned!
 ***
 ****************************************************************************
 ****************************************************************************/
#ifndef _MT_GEPF_H
#define _MT_GEPF_H
#include <linux/ioctl.h>
#define KERNEL_LOG
#define _SUPPORT_MAX_GEPF_FRAME_REQUEST_ 32
#define _SUPPORT_MAX_GEPF_REQUEST_RING_SIZE_ 32
#define SIG_ERESTARTSYS 512
#define GEPF_DEV_MAJOR_NUMBER 251
#define GEPF_MAGIC 'g'
#define GEPF_REG_RANGE (0x1000)
#define GEPF_BASE_HW 0x1502C000
#define GEPF_INT_ST ((unsigned int) 1 << 1)
typedef struct {
  unsigned int module;
  unsigned int Addr;
  unsigned int Val;
} GEPF_REG_STRUCT;
typedef struct {
  GEPF_REG_STRUCT * pData;
  unsigned int Count;
} GEPF_REG_IO_STRUCT;
typedef enum {
  GEPF_IRQ_CLEAR_NONE,
  GEPF_IRQ_CLEAR_WAIT,
  GEPF_IRQ_WAIT_CLEAR,
  GEPF_IRQ_CLEAR_STATUS,
  GEPF_IRQ_CLEAR_ALL
} GEPF_IRQ_CLEAR_ENUM;
typedef enum {
  GEPF_IRQ_TYPE_INT_GEPF_ST,
  GEPF_IRQ_TYPE_AMOUNT
} GEPF_IRQ_TYPE_ENUM;
typedef struct {
  GEPF_IRQ_CLEAR_ENUM Clear;
  GEPF_IRQ_TYPE_ENUM Type;
  unsigned int Status;
  unsigned int Timeout;
  int UserKey;
  int ProcessID;
  unsigned int bDumpReg;
} GEPF_WAIT_IRQ_STRUCT;
typedef struct {
  GEPF_IRQ_TYPE_ENUM Type;
  int UserKey;
  unsigned int Status;
} GEPF_CLEAR_IRQ_STRUCT;
typedef struct {
  unsigned int GEPF_CRT_0;
  unsigned int GEPF_CRT_1;
  unsigned int GEPF_CRT_2;
  unsigned int GEPF_FOCUS_BASE_ADDR;
  unsigned int GEPF_FOCUS_OFFSET;
  unsigned int GEPF_Y_BASE_ADDR;
  unsigned int GEPF_YUV_IMG_SIZE;
  unsigned int GEPF_UV_BASE_ADDR;
  unsigned int GEPF_DEPTH_BASE_ADDR;
  unsigned int GEPF_DEPTH_IMG_SIZE;
  unsigned int GEPF_BLUR_BASE_ADDR;
  unsigned int GEPF_YUV_BASE_ADDR;
  unsigned int TEMP_PRE_Y_BASE_ADDR;
  unsigned int TEMP_Y_BASE_ADDR;
  unsigned int TEMP_DEPTH_BASE_ADDR;
  unsigned int TEMP_PRE_DEPTH_BASE_ADDR;
  unsigned int BYPASS_DEPTH_BASE_ADDR;
  unsigned int BYPASS_DEPTH_WR_BASE_ADDR;
  unsigned int BYPASS_BLUR_BASE_ADDR;
  unsigned int BYPASS_BLUR_WR_BASE_ADDR;
  unsigned int TEMP_BLUR_BASE_ADDR;
  unsigned int TEMP_PRE_BLUR_BASE_ADDR;
  unsigned int TEMP_BLUR_WR_BASE_ADDR;
  unsigned int TEMP_DEPTH_WR_BASE_ADDR;
  unsigned int GEPF_DEPTH_WR_BASE_ADDR;
  unsigned int GEPF_BLUR_WR_BASE_ADDR;
  unsigned int TEMP_CTR_1;
  unsigned int GEPF_480_Y_ADDR;
  unsigned int GEPF_480_UV_ADDR;
  unsigned int GEPF_STRIDE_Y_UV;
  unsigned int GEPF_STRIDE_DEPTH;
  unsigned int TEMP_STRIDE_DEPTH;
  unsigned int GEPF_STRIDE_Y_UV_480;
} GEPF_Config;
typedef enum {
  GEPF_CMD_RESET,
  GEPF_CMD_DUMP_REG,
  GEPF_CMD_DUMP_ISR_LOG,
  GEPF_CMD_READ_REG,
  GEPF_CMD_WRITE_REG,
  GEPF_CMD_WAIT_IRQ,
  GEPF_CMD_CLEAR_IRQ,
  GEPF_CMD_ENQUE_NUM,
  GEPF_CMD_ENQUE,
  GEPF_CMD_ENQUE_REQ,
  GEPF_CMD_DEQUE_NUM,
  GEPF_CMD_DEQUE,
  GEPF_CMD_DEQUE_REQ,
  GEPF_CMD_TOTAL,
} GEPF_CMD_ENUM;
typedef struct {
  unsigned int m_ReqNum;
  GEPF_Config * m_pGepfConfig;
} GEPF_Request;
#define GEPF_RESET _IO(GEPF_MAGIC, GEPF_CMD_RESET)
#define GEPF_DUMP_REG _IO(GEPF_MAGIC, GEPF_CMD_DUMP_REG)
#define GEPF_DUMP_ISR_LOG _IO(GEPF_MAGIC, GEPF_CMD_DUMP_ISR_LOG)
#define GEPF_READ_REGISTER _IOWR(GEPF_MAGIC, GEPF_CMD_READ_REG, GEPF_REG_IO_STRUCT)
#define GEPF_WRITE_REGISTER _IOWR(GEPF_MAGIC, GEPF_CMD_WRITE_REG, GEPF_REG_IO_STRUCT)
#define GEPF_WAIT_IRQ _IOW(GEPF_MAGIC, GEPF_CMD_WAIT_IRQ, GEPF_WAIT_IRQ_STRUCT)
#define GEPF_CLEAR_IRQ _IOW(GEPF_MAGIC, GEPF_CMD_CLEAR_IRQ, GEPF_CLEAR_IRQ_STRUCT)
#define GEPF_ENQNUE_NUM _IOW(GEPF_MAGIC, GEPF_CMD_ENQUE_NUM, int)
#define GEPF_ENQUE _IOWR(GEPF_MAGIC, GEPF_CMD_ENQUE, GEPF_Config)
#define GEPF_ENQUE_REQ _IOWR(GEPF_MAGIC, GEPF_CMD_ENQUE_REQ, GEPF_Request)
#define GEPF_DEQUE_NUM _IOR(GEPF_MAGIC, GEPF_CMD_DEQUE_NUM, int)
#define GEPF_DEQUE _IOWR(GEPF_MAGIC, GEPF_CMD_DEQUE, GEPF_Config)
#define GEPF_DEQUE_REQ _IOWR(GEPF_MAGIC, GEPF_CMD_DEQUE_REQ, GEPF_Request)
#endif
