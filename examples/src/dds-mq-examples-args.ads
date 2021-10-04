with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with DDS.DomainParticipant;
with DDS.DomainParticipantFactory;
with DDS.Topic;
with GNATCOLL.Opt_Parse; use GNATCOLL.Opt_Parse;
with GNAT.Source_Info;
package DDS.Mq.Examples.Args is

   Parser : Argument_Parser := Create_Argument_Parser
     (Help => "P");

   function Convert (S : Standard.String) return DDS.DomainId_T is (DDS.DomainId_T'Value (S));

   package Quiet is new Parse_Flag
     (Parser => Parser,
      Short  => "-q",
      Long   => "--quiet",
      Help   => "Whether the tool should be quiet or not");

   Defult_Domain_Id : constant DDS.DomainId_T := 0;
   package Domain_Id is new Parse_Option
     (Parser      => Parser,
      Long        => "--domain_id",
      Arg_Type    => DDS.DomainId_T,
      Help        => "What domain id to use Default is" & Defult_Domain_Id'Img,
      Default_Val => Defult_Domain_Id);

   Default_Library_Name : constant Standard.String := "BuiltinQosLib";
   package Library_Name is new Parse_Option
     (Parser      => Parser,
      Short       => "-l",
      Long        => "--library",
      Arg_Type    => Unbounded_String,
      Help        => "What library to use Default is """ & Default_Library_Name & """",
      Default_Val => To_Unbounded_String (Default_Library_Name));

   Default_Profile_Name : constant Standard.String := "Generic.StrictReliable.LowLatency";
   package Profile_Name is new Parse_Option
     (Parser      => Parser,
      Short       => "-p",
      Long        => "--profile",
      Arg_Type    => Unbounded_String,
      Help        => "What library to use Default is """ & Default_Profile_Name & """",
      Default_Val => To_Unbounded_String (Default_Profile_Name));

   Default_Topic_Name : constant Standard.String := "dds/test/mq";
   package Topic_Name is new Parse_Option
     (Parser      => Parser,
      Short       => "-t",
      Long        => "--topic",
      Arg_Type    => Unbounded_String,
      Help        => "What library to use Default is """ & Default_Topic_Name & """.",
      Default_Val => To_Unbounded_String (Default_Topic_Name));

   function "+" (S : Unbounded_String) return DDS.String is (To_DDS_String (To_String (S)));

   package Verbose is new Parse_Flag
     (Parser => Parser,
      Short  => "-v",
      Long   => "--verbose",
      Help   => "Be verbose");

   package Version is new Parse_Flag
     (Parser => Parser,
      Long   => "--version",
      Help   => "Print current program version and exit");

end DDS.Mq.Examples.Args;
