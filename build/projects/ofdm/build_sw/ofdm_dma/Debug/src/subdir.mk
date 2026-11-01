################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/ad9361.c \
../src/ad9361_api.c \
../src/ad9361_conv.c \
../src/board_phy.c \
../src/dma_transport.c \
../src/link.c \
../src/main.c \
../src/net_trace.c \
../src/platform.c \
../src/services.c \
../src/util.c 

OBJS += \
./src/ad9361.o \
./src/ad9361_api.o \
./src/ad9361_conv.o \
./src/board_phy.o \
./src/dma_transport.o \
./src/link.o \
./src/main.o \
./src/net_trace.o \
./src/platform.o \
./src/services.o \
./src/util.o 

C_DEPS += \
./src/ad9361.d \
./src/ad9361_api.d \
./src/ad9361_conv.d \
./src/board_phy.d \
./src/dma_transport.d \
./src/link.d \
./src/main.d \
./src/net_trace.d \
./src/platform.d \
./src/services.d \
./src/util.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -DBOARD_ID=10 -DBOARD_SUBNET=137 -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I/home/amd/ofdm/eeSDR_ofdm_loopback/build_sw/dma_platform/export/dma_platform/sw/dma_platform/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


