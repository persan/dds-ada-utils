with Ada.Text_IO;
with DDS.Mq;
with Ada.Command_Line;
with GNAT.Expect;
with GNAT.OS_Lib;
with GNAT.Strings;
with Ada.Strings.Unbounded;
with GNATCOLL.Opt_Parse;

procedure Relengtool is
   use Ada.Text_IO;
   use GNAT.OS_Lib;
   OK : Boolean := True;
   package Arg is
      use GNATCOLL.Opt_Parse;
      use Ada.Strings.Unbounded;
      Parser : Argument_Parser := Create_Argument_Parser
        (Help => "Relengtool");

      package Tag is new Parse_Flag
        (Parser => Parser,
         Long   => "--tag",
         Help   => "git tag-");

      package Version is new Parse_Flag
        (Parser => Parser,
         Long   => "--version",
         Help   => "Print version and quit");

   end Arg;

   procedure Check_Version_Binary is
      pragma Warnings (Off);
   begin
      --  Validate project and source versions.
      if $VERSION /= DDS.Mq.VERSION then
         Put_Line (Standard_Error, "Declared project version '" & $VERSION & "' Mismatch with source version => '" & DDS.Mq.VERSION & "'.");
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
         OK := False;
      end if;
   end Check_Version_Binary;

   procedure Check_Dirty is
      GIT    : String_Access := Locate_Exec_On_Path ("git");
      Status : aliased Integer;

      use GNAT.Expect;
   begin
      if Get_Command_Output (GIT.all, Argument_String_To_List ("status -s").all, Input => "", Status => Status'Access)'Length > 0 then
         Put_Line (Standard_Error, "Folder is not clean!");
         Put_Line (Standard_Error, Get_Command_Output (GIT.all, Argument_String_To_List ("status").all, Input => "", Status => Status'Access));
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
         OK := False;
      end if;
   end;
   procedure TAG is
   begin
      if OK then
         null;
      end if;
   end TAG;
begin
   if Arg.Parser.Parse then
      if Arg.Version.Get then
         Put_Line ($VERSION);
         return;
      end if;
      Check_Version_Binary;
      Check_Dirty;
      if Arg.Tag.Get then
         TAG;
      end if;
   end if;
end Relengtool;
