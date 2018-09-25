import sbt._
import Keys._

  lazy val workSettings =  Seq(
    scalaVersion := "2.12.6",
    retrieveManaged := true
  )


  lazy val figaroWork = Project("Work", file("."))
    .settings(workSettings)
    .settings (scalacOptions ++= Seq(
	"-feature",
	"-language:existentials",
	"-deprecation",
	"-language:postfixOps"
    ))
    .settings(libraryDependencies ++= Seq(
      "com.cra.figaro" %% "figaro" % "latest.release"
    // Using rainier Development Version 25. September 2018  
    // "com.stripe" %% "rainier-core" % "latest.release"
    ))
