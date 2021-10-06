with Ada.Command_Line;
with Ada.Directories;
with Ada.Strings.Fixed;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with DDS.Mq;
with GNAT.Expect;
with GNAT.Formatted_String;
with GNAT.OS_Lib;
with GNAT.Regpat;
with GNAT.String_Split;
with GNAT.Strings;
with GNATCOLL.Opt_Parse;

procedure Relengtool is
   use Ada.Text_IO;
   use GNAT.OS_Lib;
   use Ada.Strings.Unbounded;

   package Arg is
      use GNATCOLL.Opt_Parse;
      Parser : Argument_Parser := Create_Argument_Parser
        (Help => "Relengtool");

      package Tag is new Parse_Flag
        (Parser => Parser,
         Long   => "--tag",
         Help   => "git tag.");

      package Version is new Parse_Flag
        (Parser => Parser,
         Long   => "--version",
         Help   => "Print version and quit");

      package Verbose is new Parse_Flag
        (Parser => Parser,
         Short  => "-v",
         Long   => "--verbose",
         Help   => "Be verbose.");

      package Patch is new Parse_Flag
        (Parser => Parser,
         Long   => "--patch",
         Help   => "Bump patch version.");

      package Minor is new Parse_Flag
        (Parser => Parser,
         Long   => "--minor",
         Help   => "Bump Minor version.");

      package Major is new Parse_Flag
        (Parser => Parser,
         Long   => "--major",
         Help   => "Bump major version.");

      Default_VersionSet : constant String := "0.0.0";
      package VersionSet is new Parse_Option (Parser      => Parser,
                                              Long        => "--set-version",
                                              Help        => "Files containing version numbers to be updated default; """ & Default_VersionSet & """.",
                                              Arg_Type    => Unbounded_String,
                                              Default_Val => To_Unbounded_String (Default_VersionSet));

      Default_RelengFile : constant String := ".releng";
      package RelengFile is new Parse_Option (Parser      => Parser,
                                              Long        => "--relengfile",
                                              Help        => "Files containing version numbers to be updated default; """ & Default_RelengFile & """.",
                                              Arg_Type    => Unbounded_String,
                                              Default_Val => To_Unbounded_String (Default_RelengFile));

   end Arg;

   GIT    : constant GNAT.OS_Lib.String_Access := Locate_Exec_On_Path ("git");
   OK     : Boolean := True;
   procedure Log_Line (Line : String) is
   begin
      if Arg.Verbose.Get then
         Put_Line (Line);
      end if;
   end;
   procedure Check_Version_Binary is
      pragma Warnings (Off);
   begin
      --  Validate project and source versions.
      if $VERSION /= DDS.Mq.VERSION then
         Put_Line (Standard_Error, "Declared project version '" & $VERSION & "' Mismatch with source version => '" & DDS.Mq.VERSION & "'.");
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
         OK := False;
      else
         Log_Line ("Declared project version '" & $VERSION & "' Matches with source version => '" & DDS.Mq.VERSION & "'.");
      end if;
   end Check_Version_Binary;

   procedure Check_Dirty is
      Status : aliased Integer;

      use GNAT.Expect;
   begin
      if Get_Command_Output (GIT.all, Argument_String_To_List ("status -s").all, Input => "", Status => Status'Access)'Length > 0 then
         Put_Line (Standard_Error, "Folder is not clean!");
         Put_Line (Standard_Error, Get_Command_Output (GIT.all, Argument_String_To_List ("status").all, Input => "", Status => Status'Access));
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
         OK := False;
      else
         Log_Line ("Folder is clean.");
      end if;
   end;

   procedure Check_Branch (Name : String) is
      use GNAT.Expect;
      use GNAT.String_Split;
      use GNAT.Formatted_String;
      Status : aliased Integer;
   begin
      Log_Line ("Checking for branch " & Name);
      declare
         Elements : Slice_Set := Create (Get_Command_Output (GIT.all, Argument_String_To_List ("branch").all, Input => "", Status => Status'Access), "" & ASCII.LF);
      begin
         for Ix in 1 .. Slice_Count (Elements) loop
            declare
               S : constant String := Slice (Elements, Ix);
            begin
               if S (S'First) = '*' then
                  if S (S'First + 2 .. S'Last) /= Name then
                     Put_Line (Standard_Error, "Not on requested branch:""" & Name & """ (on branch:""" & S (S'First + 2 .. S'Last) & """).");
                     Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
                     OK := False;
                  else
                     Put_Line (Standard_Error, "On requested branch:""" & Name & """.");
                  end if;
               end if;
            end;
         end loop;
      end;
   end;

   use all type GNAT.Regpat.Regexp_Flags;
   Matcher : GNAT.Regpat.Pattern_Matcher := GNAT.Regpat.Compile
     (Expression =>  "(.*VERSION(\s*:\s*constant\s+Standard.String|)\s*:=\s*"")\d+\.\d+\.\d+(""\s*;.*)",
      Flags      => GNAT.Regpat.Multiple_Lines + GNAT.Regpat.Case_Insensitive + GNAT.Regpat.Single_Line);
   Matches : GNAT.Regpat.Match_Array (1 .. GNAT.Regpat.Paren_Count (Matcher));

   function Next (S : String) return String is
      use GNAT.String_Split;
      use GNAT.Formatted_String;
      Elements : GNAT.String_Split.Slice_Set := Create (S, ".");
      Patch    : Integer := Integer'Value (Slice (Elements, 3));
      Minor    : Integer := Integer'Value (Slice (Elements, 2));
      Major    : Integer := Integer'Value (Slice (Elements, 1));
      Format   : GNAT.Formatted_String.Formatted_String := +("%d.%d.%d");
   begin
      if Arg.Patch.Get then
         Patch := Patch + 1;
      end if;
      if Arg.Minor.Get then
         Minor := Minor + 1;
         Patch := 0;

      end if;
      if Arg.Major.Get then
         Major := Major + 1;
         Minor := 0;
         Patch := 0;
      end if;
      return -(Format & Major & Minor & Patch);
   end;

   procedure Update_Version (To : String := Next ($VERSION)) is

      procedure Update_File (Path : String) is
         F           : GNAT.OS_Lib.File_Descriptor := GNAT.OS_Lib.Open_Read (Path, GNAT.OS_Lib.Text);
         Buffer_Size : Natural := Natural (GNAT.OS_Lib.File_Length (F));
         Buffer      : String (1 .. Buffer_Size);
         Last        : Integer;
      begin
         Log_Line ("Update Version number in : """ & Path & """ to """ & To & """.");
         Last := GNAT.OS_Lib.Read (F, Buffer'Address, Buffer'Length);
         GNAT.OS_Lib.Close (F);
         GNAT.Regpat.Match (Matcher, Buffer, Matches);

         F := GNAT.OS_Lib.Create_File (Path, GNAT.OS_Lib.Text);
         Last := GNAT.OS_Lib.Write (F, Buffer (Matches (1).First)'Address, Matches (1).Last - Matches (1).First + 1);
         Last := GNAT.OS_Lib.Write (F, To'Address, To'Length);
         Last := GNAT.OS_Lib.Write (F,  Buffer (Matches (3).First)'Address, Matches (3).Last - Matches (3).First + 1);
         GNAT.OS_Lib.Close (F);
      end Update_File;
   begin
      if Ada.Directories.Exists (To_String (Arg.RelengFile.Get)) then
         declare
            Inf : Ada.Text_IO.File_Type;
         begin
            Log_Line ("Using releng file """ & To_String (Arg.RelengFile.Get) & """.");
            Open (Inf, In_File, To_String (Arg.RelengFile.Get));
            while not End_Of_File (Inf) loop
               declare
                  Line : constant String := Ada.Strings.Fixed.Trim (Get_Line (Inf), Ada.Strings.Both);
               begin
                  if Line'Length > 2 and then
                    Line (Line'First .. Line'First + 1) /= "--" and then
                    Line (Line'First) /= ';'  and then
                    Line (Line'First) /= '#'
                  then
                     if Ada.Directories.Exists (Line) then
                        Update_File (Line);
                     else
                        Put_Line (Standard_Error, "File :" & Line & " Not found");
                        Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
                        OK := False;
                     end if;
                  end if;
               end;
            end loop;
            Close (Inf);
         end;
      else
         Put_Line (Standard_Error, "No releng file """ & To_String (Arg.RelengFile.Get & """ found."));
         Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
         OK := False;
      end if;
   end Update_Version;

   procedure TAG is
      use GNAT.Expect;
      Status : aliased Integer;
   begin
      Log_Line ("Adding tag: """ & $PROJECT & "-" & $VERSION & """.");
      Put_Line (Standard_Error, Get_Command_Output (GIT.all, Argument_String_To_List ("tag -f " & $PROJECT & "-" & $VERSION).all, Input => "", Status => Status'Access));
   end TAG;
begin
   if Arg.Parser.Parse then
      if Arg.Version.Get then
         Put_Line ($VERSION);
         return;
      end if;
      Check_Version_Binary;
      Check_Dirty;
      Check_Branch ("master");
      if OK and then Arg.Tag.Get then
         TAG;
      end if;

      if Arg.Default_VersionSet /= To_String (Arg.VersionSet.Get) then
         Update_Version (To_String (Arg.VersionSet.Get));
      end if;

      if OK and then (Arg.Patch.Get or else Arg.Minor.Get or else Arg.Major.Get) then
         Update_Version;
      end if;
   end if;
end Relengtool;
