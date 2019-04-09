#This target is to ensure accidental execution of Makefile as a bash script will not execute commands like rm in unexpected directories and exit gracefully.
.prevent_execution:
	exit 0


#CC = gcc
CC=/opt/poky/1.6.2/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-gcc

BLACKBOX_FLAG = N
ANALYTICS_FLAG = N
#remove @ for no make command prints
DEBUG = @

APP_DIR = .
APP_INCLUDE_DIRS += -I./header/libcommon -I./header/appcommon -I./header/obd2app -I./header/xls
APP_LIBRARY_DIR = -L./lib 
APP_NAME = iWaveOBD2FW
ifeq ($(BLACKBOX_FLAG), Y)
APP_SRC_FILES = src/cloud_comm.c src/cloud_init.c src/init_callbacks.c src/init_main.c src/mode_pid.c src/standard.c src/standard_pkt_json.c src/standard_pkt_process.c src/standard_queue.c src/wrapper.c src/blackbox.c src/usb.c src/h_queue.c 
endif
ifeq ($(BLACKBOX_FLAG), N)
APP_SRC_FILES = src/cloud_comm.c src/cloud_init.c src/init_callbacks.c src/init_main.c src/mode_pid.c src/standard.c src/standard_pkt_json.c src/standard_pkt_process.c src/standard_queue.c src/wrapper.c src/h_queue.c
endif

# Logging level control
LOG_FLAGS += -DENABLE_IOT_DEBUG
LOG_FLAGS += -DENABLE_IOT_INFO
LOG_FLAGS += -DENABLE_IOT_WARN
LOG_FLAGS += -DENABLE_IOT_ERROR

COMPILER_FLAGS += $(LOG_FLAGS)
#If the processor is big endian uncomment the compiler flag
#COMPILER_FLAGS += -DREVERSED

#MBED_TLS_MAKE_CMD = $(MAKE) -C $(MBEDTLS_DIR)
#PRE_MAKE_CMD = $(MBED_TLS_MAKE_CMD)
PRE_MAKE_CMD = $(MAKE)

CPPFLAGS =
CPP_OPTS?=
CFLAGS+=-fPIC
C_OPTS?=

PATH1 = -I/opt/poky/1.6.2/sysroots/x86_64-pokysdk-linux/usr/include/
PATH2 = -I/opt/poky/1.6.2/sysroots/x86_64-pokysdk-linux/usr/include/libxml2/
PATH3 = -L/opt/poky/1.6.2/sysroots/cortexa9hf-vfp-neon-poky-linux-gnueabi/usr/lib
OUT_SAMPLE_PATH         = $(OUT_PLATFORM_DIR)
OUT_PLATFORM_DIR        = $(OUTPUT_DIR)/$(OUT_CC_SUBDIR)/$(CONF_SUBDIR)
OUT_PLATFORM_LIBDIR	= $(OUTPUT_LIBDIR)/$(OUT_CC_SUBDIR)/$(CONF_SUBDIR)
OUTPUT_LIBDIR		= $(SDK_DIR)build/lib
OUTPUT_DIR              = $(PROJ_DIR)/build/sample$(DEBUG_SUFFIX)
PROJ_DIR                = $(MAKE_DIR)/../..
MAKE_DIR=.

#MAKE_CMD = $(CC) $(CPPFLAGS) $(CPP_OPTS) $(CFLAGS) $(C_OPTS) -o $(APP_NAME) $(APP_SRC_FILES) $(LDFLAGS) $(LD_OPTS) $(LDLIBS) $(APP_LIBRARY_DIR) $(PATH1) -lOBD2 -lssl -lcrypto -lm -lrt -ldl $(APP_INCLUDE_DIRS) -I$(OUT_PLATFORM_LIBDIR) -I$(SDK_INCLUDE) -L$(OUT_PLATFORM_LIBDIR) -lpthread -lcurl -lz
#MAKE_CMD = $(CC) $(CFLAGS) -o $(APP_NAME) $(APP_SRC_FILES) $(APP_LIBRARY_DIR) $(PATH1) $(PATH2) -lOBD2 -lssl -lcrypto -lm -lrt -ldl $(APP_INCLUDE_DIRS) -lpthread -lcurl -lz -lxml2

#MAKE_CMD = $(CC) $(CFLAGS) -o $(APP_NAME) $(APP_SRC_FILES) $(PATH1) $(APP_INCLUDE_DIRS) -L/home/velayutha/peru/PRFIP/R2.0/PRFQN/SC/Keshav/USB_BOARD_IMPL_BOARD/src/libs/zlib/image/usr/lib -lz $(APP_LIBRARY_DIR) -lOBD2 -lssl -lcrypto -lcurl -I/opt/poky/1.6.2/sysroots/x86_64-pokysdk-linux/usr/include/libxml2/ -L/opt/poky/1.6.2/sysroots/cortexa9hf-vfp-neon-poky-linux-gnueabi/usr/lib -lm -ldl -L/home/velayutha/peru/PRFIP/R2.0/PRFQN/SC/Keshav/USB_BOARD_IMPL_BOARD/src/libs/image/usr/lib -lxml2 -L/opt/poky/1.6.2/sysroots/x86_64-pokysdk-linux/usr/lib -lpthread -lrt   
MAKE_CMD = $(CC) $(CFLAGS) -s -o $(APP_NAME) $(APP_SRC_FILES) $(PATH1) $(PATH2) $(APP_INCLUDE_DIRS) $(APP_LIBRARY_DIR) -lz -lOBD2 -lssl -lcrypto -lcurl -lxml2 $(PATH3) -lm -ldl -lpthread -lrt 
MESSAGING_THREAD_SAFETY?=true

# disable/enable async message dispatcher support
# applicable if MESSAGING_THREAD_SAFETY=true
MESSAGE_DISPATCHER?=true
MESSAGE_PERSISTENCE?=true
IMPLICIT_EDGE_COMPUTING?=true

# disable/enable virtualization support
# always uses MESSAGE_DISPATCHER=true
VIRTUALIZATION_SUPPORT?=true

# disable/enable indirect activation support
GATEWAY?=true


OUT_CC_SUBDIR?=$(shell uname -m | sed -e s/x86_64/x86/ -e s/i686/x86/ -e s/arm.*/arm/ -e s/sa110/arm/)

# used for library configuration
CONF_SUBDIR:=
ifeq ($(MESSAGING_THREAD_SAFETY), true)
    CONF_SUBDIR:=ts
else
    CONF_SUBDIR:=nots
endif
ifeq ($(MESSAGE_DISPATCHER), true)
    CONF_SUBDIR:=$(CONF_SUBDIR)_md
endif
ifeq ($(VIRTUALIZATION_SUPPORT), true)
    CONF_SUBDIR:=$(CONF_SUBDIR)_vs
endif
ifeq ($(GATEWAY), true)
    CONF_SUBDIR:=$(CONF_SUBDIR)_gw
endif


# used for library configuration
CONF_SUBDIR:=
ifeq ($(MESSAGING_THREAD_SAFETY), true)
    CONF_SUBDIR:=ts
else
    CONF_SUBDIR:=nots
endif
ifeq ($(MESSAGE_DISPATCHER), true)
    CONF_SUBDIR:=$(CONF_SUBDIR)_md
endif
ifeq ($(VIRTUALIZATION_SUPPORT), true)
    CONF_SUBDIR:=$(CONF_SUBDIR)_vs
endif
ifeq ($(GATEWAY), true)
    CONF_SUBDIR:=$(CONF_SUBDIR)_gw
endif


# gw_sample using Virtualization API | LIB_CFG=ts_md_vs_gw
ifeq ("true true true true", "$(MESSAGING_THREAD_SAFETY) $(MESSAGE_DISPATCHER) $(VIRTUALIZATION_SUPPORT) $(GATEWAY)")
    CURRENT_SAMPLE:=$(OBDII_SRC)
    CURRENT_SAMPLE_DIR:=$(SAMPLE_SRC_DIR)/$(OBDII_SUBDIR)
    CURRENT_SCS_SAMPLE:=$(STORAGE_SAMPLE_NAME)
endif

# sample directory
SAMPLE_DIR              = $(PROJ_DIR)/samples
# sample source directory
SAMPLE_SRC_DIR          = $(SAMPLE_DIR)/src

## executable samples extension
ifneq ($(PLATFORM_OS), cygwin)
    SAMPLE_EXT=.o
else
    SAMPLE_EXT=.exe
endif

ifeq ($(ANALYTICS_FLAG), Y)
MAKE_CMD += -lanalytics
endif

#MAKE_CMD = $(CC) $(SRC_FILES) $(COMPILER_FLAGS) -s -I/opt/poky/1.6.2/sysroots/x86_64-pokysdk-linux/usr/include/ $(APP_LIBRARY_DIRS) -lOBD -lrt -lm -o $(APP_NAME) $(LD_FLAG) $(EXTERNAL_LIBS) $(INCLUDE_ALL_DIRS)


all:
	#$(PRE_MAKE_CMD)
	$(DEBUG)$(MAKE_CMD)
	$(POST_MAKE_CMD)

clean:
	rm -f $(APP_DIR)/$(APP_NAME)
