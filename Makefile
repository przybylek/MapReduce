#
# This is a simple makefile to assist with quickly building the Exercises of MP2.
#
# To build and execute a particular exercise:
#    - For a single exercise, type 'make runA' to run exercise A.
#    - For all exercises, 'make'.
#
#
HADOOP_CLASSPATH := ${JAVA_HOME}/lib/tools.jar
export HADOOP_CLASSPATH

HDFS=pso

OBJDIR=build

JAR := MapReducePSO.jar

TARGETS := $(addprefix run, A B C D E F)

.PHONY: final $(TARGETS) clean

final: $(TARGETS)

runA: $(OBJDIR)/TitleCount.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/A-output/
	hadoop jar $(JAR) TitleCount -D stopwords=/$(HDFS)/misc/stopwords.txt -D delimiters=/$(HDFS)/misc/delimiters.txt /$(HDFS)/titles /$(HDFS)/A-output

runB: $(OBJDIR)/TopTitles.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/B-output/
	hadoop jar $(JAR) TopTitles -D stopwords=/$(HDFS)/misc/stopwords.txt -D delimiters=/$(HDFS)/misc/delimiters.txt -D N=5 /$(HDFS)/titles /$(HDFS)/B-output

runC: $(OBJDIR)/TopTitleStatistics.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/C-output/
	hadoop jar $(JAR) TopTitleStatistics -D stopwords=/$(HDFS)/misc/stopwords.txt -D delimiters=/$(HDFS)/misc/delimiters.txt -D N=5 /$(HDFS)/titles /$(HDFS)/C-output

runD: $(OBJDIR)/OrphanPages.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/D-output/
	hadoop jar $(JAR) OrphanPages /$(HDFS)/links /$(HDFS)/D-output

runE: $(OBJDIR)/TopPopularLinks.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/E-output/
	hadoop jar $(JAR) TopPopularLinks -D N=5 /$(HDFS)/links /$(HDFS)/E-output

runF: $(OBJDIR)/PopularityLeague.class
	jar -cvf $(JAR) -C $(OBJDIR)/ ./
	hadoop fs -rm -r -f /$(HDFS)/F-output/
	hadoop jar $(JAR) PopularityLeague -D league=/$(HDFS)/misc/league.txt /$(HDFS)/links /$(HDFS)/F-output

$(OBJDIR)/%.class: %.java | $(OBJDIR)
	hadoop com.sun.tools.javac.Main $< -d $(OBJDIR)

$(OBJDIR):
	mkdir $@

.PHONY: clean
clean:
	rm -f $(OBJDIR)/* $(JAR)
	hadoop fs -rm -r -f /$(HDFS)/*-output/
