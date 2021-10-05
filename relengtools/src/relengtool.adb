with Ada.Text_IO;
with DDS.Mq;
with Ada.Command_Line;
with GNAT.Expect;
with GNAT.OS_Lib;
with GNAT.Strings;
procedure Relengtool is
   use Ada.Text_IO;

   procedure Check_Version_Binary is
      pragma Warnings (Off);
   begin
      --  Validate project and source versions.
      if $VERSION /= DDS.Mq.VERSION then
         Put_Line (Standard_Error, "Declared project version '" & $VERSION & "' Mismatch with source version => '" & DDS.Mq.VERSION & "'.");
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      end if;
   end Check_Version_Binary;

   procedure Check_Dirty is
      use GNAT.OS_Lib;
      use GNAT.Expect;

      GIT    : String_Access := Locate_Exec_On_Path ("git");
      Status : aliased Integer;

   begin
      if Get_Command_Output (GIT.all, Argument_String_To_List ("status -s").all, Input => "", Status => Status'Access)'Length > 0 then
         Put_Line (Standard_Error, "Folder is not clean!");
         Put_Line (Standard_Error, Get_Command_Output (GIT.all, Argument_String_To_List ("status").all, Input => "", Status => Status'Access));
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      end if;
   end;

begin
   Check_Version_Binary;
   Check_Dirty;
end Relengtool;
