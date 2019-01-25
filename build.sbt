name := course.value + "-" + assignment.value

scalaVersion := "2.11.12"

scalacOptions ++= Seq("-deprecation")

courseId := "e8VseYIYEeWxQQoymFg8zQ"

resolvers += Resolver.sonatypeRepo("releases")

// grading libraries
libraryDependencies += "junit" % "junit" % "4.10" % Test
libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % "2.1.0" % "provided",
  "org.apache.spark" %% "spark-sql" % "2.1.0" % "provided",
  "mysql" % "mysql-connector-java" % "5.1.12"
)

// include the common dir
commonSourcePackages += "common"

libraryDependencies += "org.apache.spark" %% "spark-yarn" %  "2.1.0" % "provided"
libraryDependencies += "org.apache.spark" %% "spark-hive" %  "2.1.0" % "provided"
