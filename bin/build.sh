#!/usr/bin/env sh

# KIP Engine Build Script

set -e

# Get the absolute path of the build script
SCRIPT="$0"
while [ -h "$SCRIPT" ] ; do
    SCRIPT=`readlink "$SCRIPT"`
done

# Get the base directory of the repo
DIR=`dirname $SCRIPT`/..
cd $DIR
BASE=`pwd`

. "$BASE/bin/common.sh"
. "$BASE/bin/vendors.sh"

# Full rebuild?
if test "$REBUILD" = "1" ; then
    echo "Rebuild set."
    CLEAN=clean
else
    echo "Incremental build set. Use \"REBUILD=1 $0\" for clean rebuild."
    CLEAN=
fi

echo "Going to build KIP Engine Platform..."
BASE_TARGETS="update compile commons/publish output/publish"

if test "$SKIP_PROCESS" = "1" ; then
    echo "Skip building process assemblies."
else
    echo "+ Assemble Process Hadoop Scalding"
    BASE_TARGETS="$BASE_TARGETS processHadoopScalding/assembly"

    echo "+ Assemble Process Commons Evaluations Scala Parameter Generator"
    BASE_TARGETS="$BASE_TARGETS processEnginesCommonsEvalScalaParamGen/assembly"

    echo "+ Assemble Process Commons Evaluations Scala U2I Training-Test Splitter"
    BASE_TARGETS="$BASE_TARGETS processEnginesCommonsEvalScalaU2ITrainingTestSplit/assembly"
fi

# Build Generic Single Machine ItemRec Data Preparator
echo "+ Pack Single Machine Generic ItemRec Data Preparator"
BASE_TARGETS="$BASE_TARGETS processEnginesItemRecAlgoScalaGeneric/pack"

# Build Mahout ItemRec Job and Model Construcotor
echo "+ Pack Mahout ItemRec Job and Model Constructor"
BASE_TARGETS="$BASE_TARGETS processEnginesItemRecAlgoScalaMahout/pack"

# Build GraphChi Model Constructor
echo "+ Pack GraphChi ItemRec Model Constructor"
BASE_TARGETS="$BASE_TARGETS processEnginesItemRecAlgoScalaGraphChi/pack"

# Build Generic Single Machine ItemSim Data Preparator
echo "+ Pack Single Machine Generic ItemSim Data Preparator"
BASE_TARGETS="$BASE_TARGETS processEnginesItemSimAlgoScalaGeneric/pack"

# Build Mahout ItemSim Job and Model Construcotor
echo "+ Pack Mahout ItemSim Job and Model Constructor"
BASE_TARGETS="$BASE_TARGETS processEnginesItemSimAlgoScalaMahout/pack"

# Build GraphChi Model Constructor
echo "+ Pack GraphChi ItemSim Model Constructor"
BASE_TARGETS="$BASE_TARGETS processEnginesItemSimAlgoScalaGraphChi/pack"

# Build Single Machine U2I Action Splitter
echo "+ Pack Single Machine U2I Action Splitter"
BASE_TARGETS="$BASE_TARGETS processEnginesCommonsEvalScalaU2ISplit/pack"

# Build Single Machine MAP@k
echo "+ Pack Single Machine MAP@k"
BASE_TARGETS="$BASE_TARGETS processEnginesItemRecEvalScalaMetricsMAP/pack"

# Build Single Machine Top-K Collector
echo "+ Pack Single Machine Top-K Collector"
BASE_TARGETS="$BASE_TARGETS processEnginesCommonsEvalScalaTopKItems/pack"

# Build connection check tool
echo "+ Pack Connection Check Tool"
BASE_TARGETS="$BASE_TARGETS toolsConncheck/pack"

# Build settings initialization tool
echo "+ Pack Settings Initialization Tool"
BASE_TARGETS="$BASE_TARGETS toolsSettingsInit/pack"

# Build software manager
echo "+ Pack Software Manager"
BASE_TARGETS="$BASE_TARGETS toolsSoftwareManager/pack"

# Build user tool
echo "+ Pack User Tool"
BASE_TARGETS="$BASE_TARGETS toolsUsers/pack"

$SBT $CLEAN $BASE_TARGETS

# Build admin server
echo "Going to build KIP Engine Platform Admin Server..."
cd $BASE/servers/admin
$PLAY $CLEAN update compile

# Build API server
echo "Going to build KIP Engine Platform API Server..."
cd $BASE/servers/api
$PLAY $CLEAN update compile

# Build scheduler server
echo "Going to build KIP Engine Platform Scheduler Server..."
cd $BASE/servers/scheduler
$PLAY $CLEAN update compile
