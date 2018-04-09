# by dancal

CC = gcc
CPP = g++
LD = g++

#CC = /opt/rh/devtoolset-3/root/usr/bin/gcc
#CPP = /opt/rh/devtoolset-3/root/usr/bin/g++
#LD = /opt/rh/devtoolset-3/root/usr/bin/g++
#NASM = /opt/rh/devtoolset-3/root/usr/bin/as

CPU_OPT         = -march=native -msse4.2 -mmmx 

#release
OPTPROFILE      = -fpermissive -DNDEBUG -Wno-deprecated -Wextra -Wno-unused-parameter -fno-strict-aliasing -Wno-reorder -Wno-unused-value
OPTIMISATIONS   = -O2 -Wall -W -DPIC -fPIC -pipe ${OPTPROFILE} ${CPU_OPT}
OPT_LIBS		= -ljemalloc -lcjson

#debug
#OPTPROFILE		= -fpermissive 
#OPTIMISATIONS 	= -g -DWITHGPERFTOOLS -W -Wall -pipe ${OPTPROFILE} ${CPU_OPT}
#OPT_LIBS		= ./libs/gperftools/.libs/libprofiler.a -lunwind

OPT_STATIC_LIBS = -L/usr/lib64

CPP_INCLUDE 	= -I../aerospike-client-c/target/Linux-x86_64/include \
				  -I/usr/include \
			  	  -I/usr/local/include \

CPP_EXT_FLAGS 	= ${OPT_LIBS} \
				  -lpthread -levent \
				  -lstdc++ -lrt -lc -lm -ldl -lz -lbz2 -lcrypto -lssl \
				  -lboost_filesystem -lboost_system -lboost_iostreams

# default flags
C_FLAGS 		= ${DEBUG} ${OPTIMISATIONS}
CPP_FLAGS 		= -std=c++0x ${DEBUG} ${OPTIMISATIONS} ${CPP_INCLUDE}
LDFLAGS 		= ${OPT_STATIC_LIBS} ${CPP_EXT_FLAGS}

#target 
ASE_BIN_NAME	= bin/uniq_line

OBJ_ASE_CPP 	= src/main.opp \

OBJ_ASE_C 		=
EXT_OBJS_C		= 
		
TARGETS = ${ASE_BIN_NAME}

all:	${TARGETS}

${ASE_BIN_NAME}: ${OBJ_ASE_C} ${EXT_OBJS_C} ${OBJ_ASE_CPP}
	${LD} ${CPP_FLAGS} -o $@ $^ ${LDFLAGS}

# compile c files
%.o:	%.c
	${CC} ${C_FLAGS} -c $< -MD -MF $(<:%.c=%.dep) -o $@

# compile c++ files
%.opp:	%.cpp
	${CPP} ${CPP_FLAGS} -c $< -MD -MF $(<:%.cpp=%.dep) -o $@

.PHONY:	clean all
clean:
	rm -f ${TARGETS}
	rm -f *.[hc]pp~ Makefile~ core
	rm -f ${OBJ_ASE_C}
	rm -f ${OBJ_ASE_CPP}
	rm -f $(OBJ_ASE_C:%.o=%.dep) $(OBJ_ASE_CPP:%.opp=%.dep)

-include $(OBJ_ASE_C:%.o=%.dep) $(OBJ_ASE_CPP:%.opp=%.dep)
